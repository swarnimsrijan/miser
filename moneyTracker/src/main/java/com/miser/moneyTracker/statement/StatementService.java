package com.miser.moneyTracker.statement;

import com.miser.moneyTracker.account.Account;
import com.miser.moneyTracker.account.AccountRepository;
import com.miser.moneyTracker.categorization.CategorizationResult;
import com.miser.moneyTracker.categorization.CategorizationService;
import com.miser.moneyTracker.common.exception.ConflictException;
import com.miser.moneyTracker.common.exception.ResourceNotFoundException;
import com.miser.moneyTracker.creditcard.CreditCard;
import com.miser.moneyTracker.creditcard.CreditCardRepository;
import com.miser.moneyTracker.parser.CsvExtractor;
import com.miser.moneyTracker.parser.ExtractionContext;
import com.miser.moneyTracker.parser.ExtractionResult;
import com.miser.moneyTracker.parser.PdfExtractor;
import com.miser.moneyTracker.parser.RawTransaction;
import com.miser.moneyTracker.parser.StatementExtractor;
import com.miser.moneyTracker.parser.StatementKind;
import com.miser.moneyTracker.parser.StatementParseException;
import com.miser.moneyTracker.parser.XlsxExtractor;
import com.miser.moneyTracker.transaction.Transaction;
import com.miser.moneyTracker.transaction.TransactionRepository;
import com.miser.moneyTracker.transaction.TransactionType;
import com.miser.moneyTracker.user.CurrentUserService;
import com.miser.moneyTracker.user.User;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.TransactionTemplate;
import org.springframework.web.multipart.MultipartFile;

import com.miser.moneyTracker.reconciliation.ReconciliationService;
import com.miser.moneyTracker.storage.StatementStorage;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HexFormat;
import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class StatementService {

    public static final String STATUS_PENDING = "PENDING";
    public static final String STATUS_PARSED = "PARSED";
    public static final String STATUS_FAILED = "FAILED";

    private final StatementRepository statementRepository;
    private final TransactionRepository transactionRepository;
    private final AccountRepository accountRepository;
    private final CreditCardRepository creditCardRepository;
    private final CurrentUserService currentUserService;
    private final CategorizationService categorizationService;
    private final StatementStorage statementStorage;
    private final ReconciliationService reconciliationService;
    private final CsvExtractor csvExtractor;
    private final XlsxExtractor xlsxExtractor;
    private final PdfExtractor pdfExtractor;
    private final TransactionTemplate transactionTemplate;

    /**
     * Full pipeline: dedupe by checksum, store the file, extract raw
     * transactions with the format-specific extractor, auto-categorize and
     * persist them. The statement ends up PARSED or FAILED, never lost.
     */
    public StatementResponse upload(MultipartFile file, Long accountId, Long creditCardId) {
        return upload(file, accountId, creditCardId, null);
    }

    /**
     * @param password optional password for encrypted PDF/XLSX statements. Used
     *                 only in memory to open the file; never logged or stored.
     */
    public StatementResponse upload(MultipartFile file, Long accountId, Long creditCardId,
                                    String password) {
        if ((accountId == null) == (creditCardId == null)) {
            throw new IllegalArgumentException(
                    "Provide exactly one of accountId or creditCardId");
        }
        User user = currentUserService.getCurrentUser();

        Account account = null;
        CreditCard creditCard = null;
        if (accountId != null) {
            account = accountRepository.findWithBankByIdAndUserId(accountId, user.getId())
                    .orElseThrow(() -> new ResourceNotFoundException("Account not found"));
        } else {
            creditCard = creditCardRepository.findWithBankByIdAndUserId(creditCardId, user.getId())
                    .orElseThrow(() -> new ResourceNotFoundException("Credit card not found"));
        }

        byte[] content = readBytes(file);
        String checksum = checksum(content);
        if (statementRepository.existsByUserIdAndChecksumAndStatusNot(user.getId(), checksum, STATUS_FAILED)) {
            throw new ConflictException("This statement has already been uploaded");
        }

        String storageKey = statementStorage.store(
                user.getId(), file.getOriginalFilename(), content, file.getContentType());
        Statement statement = statementRepository.save(Statement.builder()
                .user(user)
                .account(account)
                .creditCard(creditCard)
                .statementType(detectType(file.getOriginalFilename()))
                .fileUrl(storageKey)
                .checksum(checksum)
                .status(STATUS_PENDING)
                .build());

        try {
            ExtractionResult extraction = extract(statement, content, extractionContext(statement, password));
            statement.setIssuer(extraction.issuer());
            statement.setParserLayout(extraction.layout());
            Long saved = transactionTemplate.execute(
                    status -> persistTransactions(statement, extraction.transactions()));
            // Link card payments / own-account transfers so totals are not double counted.
            reconciliationService.reconcile(user.getId());
            return StatementResponse.from(statement, saved == null ? 0 : saved);
        } catch (RuntimeException e) {
            statement.setStatus(STATUS_FAILED);
            statementRepository.save(statement);
            // Only the exception message is logged; it never contains the password.
            log.warn("Failed to parse statement {}: {}", statement.getId(), e.getMessage());
            if (e instanceof StatementParseException) throw e;
            throw new StatementParseException("Failed to process statement: " + e.getMessage(), e);
        }
    }

    private static ExtractionContext extractionContext(Statement statement, String password) {
        boolean card = statement.getCreditCard() != null;
        String bankName = card
                ? statement.getCreditCard().getBank().getName()
                : statement.getAccount().getBank().getName();
        return new ExtractionContext(
                card ? StatementKind.CREDIT_CARD : StatementKind.BANK_ACCOUNT,
                bankName,
                password == null || password.isEmpty() ? null : password);
    }

    private ExtractionResult extract(Statement statement, byte[] content, ExtractionContext context) {
        StatementExtractor extractor = switch (statement.getStatementType()) {
            case CSV -> csvExtractor;
            case XLSX -> xlsxExtractor;
            case PDF -> pdfExtractor;
        };
        ExtractionResult result = extractor.extract(new ByteArrayInputStream(content), context);
        if (result.transactions().isEmpty()) {
            throw new StatementParseException("No transactions found in statement");
        }
        return result;
    }

    // Runs inside a TransactionTemplate so the transactions and the statement
    // status flip commit atomically (self-invoked @Transactional would not apply).
    private long persistTransactions(Statement statement, List<RawTransaction> rawTransactions) {
        String currency = statement.getAccount() != null
                ? statement.getAccount().getCurrency()
                : statement.getCreditCard().getCurrency();

        LocalDate from = null;
        LocalDate to = null;
        List<Transaction> transactions = new ArrayList<>(rawTransactions.size());
        for (RawTransaction raw : rawTransactions) {
            CategorizationResult categorization = categorizationService.categorize(raw.getDescription());
            transactions.add(Transaction.builder()
                    .user(statement.getUser())
                    .account(statement.getAccount())
                    .creditCard(statement.getCreditCard())
                    .statement(statement)
                    .transactionDate(raw.getDate())
                    .description(raw.getDescription())
                    .merchant(categorization.merchant())
                    .category(categorization.category())
                    .subCategory(categorization.subCategory())
                    .amount(raw.getAmount())
                    .transactionType("CREDIT".equals(raw.getType())
                            ? TransactionType.CREDIT : TransactionType.DEBIT)
                    .balance(raw.getBalance())
                    .currency(currency)
                    .reference(raw.getReference())
                    .build());
            if (from == null || raw.getDate().isBefore(from)) from = raw.getDate();
            if (to == null || raw.getDate().isAfter(to)) to = raw.getDate();
        }
        transactionRepository.saveAll(transactions);

        statement.setFromDate(from);
        statement.setToDate(to);
        statement.setStatus(STATUS_PARSED);
        statementRepository.save(statement);
        return transactions.size();
    }

    @Transactional(readOnly = true)
    public List<StatementResponse> getAllForCurrentUser() {
        Long userId = currentUserService.getCurrentUserId();
        return statementRepository.findByUserIdOrderByUploadedAtDesc(userId).stream()
                .map(s -> StatementResponse.from(s, transactionRepository.countByStatementId(s.getId())))
                .toList();
    }

    /** Deletes a statement, its transactions and the stored file. */
    public void delete(Long statementId) {
        Long userId = currentUserService.getCurrentUserId();
        Statement statement = statementRepository.findById(statementId)
                .filter(s -> s.getUser().getId().equals(userId))
                .orElseThrow(() -> new ResourceNotFoundException("Statement not found"));
        transactionTemplate.executeWithoutResult(status -> {
            List<Transaction> transactions = transactionRepository.findByStatementId(statementId);
            // Release transfer partners on other statements before deleting.
            for (Transaction t : transactions) {
                if (t.getTransferPairId() != null) {
                    transactionRepository.findByIdAndUserId(t.getTransferPairId(), userId).ifPresent(pair -> {
                        pair.setTransfer(false);
                        pair.setTransferPairId(null);
                    });
                }
            }
            transactionRepository.deleteAll(transactions);
            statementRepository.delete(statement);
        });
        try {
            statementStorage.delete(statement.getFileUrl());
        } catch (RuntimeException e) {
            log.warn("Statement {} deleted but its file could not be removed: {}", statementId, e.getMessage());
        }
    }

    private static byte[] readBytes(MultipartFile file) {
        try {
            return file.getBytes();
        } catch (IOException e) {
            throw new StatementParseException("Failed to read uploaded file", e);
        }
    }

    private static String checksum(byte[] content) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            return HexFormat.of().formatHex(digest.digest(content));
        } catch (NoSuchAlgorithmException e) {
            throw new IllegalStateException("Failed to compute statement checksum", e);
        }
    }

    private StatementType detectType(String filename) {
        if (filename == null) return StatementType.CSV;
        String lower = filename.toLowerCase();
        if (lower.endsWith(".pdf")) return StatementType.PDF;
        if (lower.endsWith(".xlsx") || lower.endsWith(".xls")) return StatementType.XLSX;
        return StatementType.CSV;
    }
}
