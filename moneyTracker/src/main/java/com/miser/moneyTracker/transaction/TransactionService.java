package com.miser.moneyTracker.transaction;

import com.miser.moneyTracker.category.Category;
import com.miser.moneyTracker.category.CategoryRepository;
import com.miser.moneyTracker.category.SubCategory;
import com.miser.moneyTracker.category.SubCategoryRepository;
import com.miser.moneyTracker.common.exception.ResourceNotFoundException;
import com.miser.moneyTracker.user.CurrentUserService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class TransactionService {

    private final TransactionRepository transactionRepository;
    private final CategoryRepository categoryRepository;
    private final SubCategoryRepository subCategoryRepository;
    private final CurrentUserService currentUserService;

    @Transactional(readOnly = true)
    public Page<TransactionResponse> search(LocalDate from, LocalDate to,
                                            Long accountId, Long creditCardId,
                                            Long categoryId, TransactionType type,
                                            String query, int page, int size) {
        Long userId = currentUserService.getCurrentUserId();

        List<Specification<Transaction>> specs = new ArrayList<>();
        specs.add((root, q, cb) -> cb.equal(root.get("user").get("id"), userId));
        if (query != null && !query.isBlank()) {
            String pattern = "%" + query.trim().toLowerCase()
                    .replace("\\", "\\\\").replace("%", "\\%").replace("_", "\\_") + "%";
            specs.add((root, q, cb) -> cb.like(cb.lower(root.get("description")), pattern, '\\'));
        }
        if (from != null) {
            specs.add((root, q, cb) -> cb.greaterThanOrEqualTo(root.get("transactionDate"), from));
        }
        if (to != null) {
            specs.add((root, q, cb) -> cb.lessThanOrEqualTo(root.get("transactionDate"), to));
        }
        if (accountId != null) {
            specs.add((root, q, cb) -> cb.equal(root.get("account").get("id"), accountId));
        }
        if (creditCardId != null) {
            specs.add((root, q, cb) -> cb.equal(root.get("creditCard").get("id"), creditCardId));
        }
        if (categoryId != null) {
            specs.add((root, q, cb) -> cb.equal(root.get("category").get("id"), categoryId));
        }
        if (type != null) {
            specs.add((root, q, cb) -> cb.equal(root.get("transactionType"), type));
        }

        var pageable = PageRequest.of(page, Math.min(size, 200),
                Sort.by(Sort.Direction.DESC, "transactionDate", "id"));
        return transactionRepository.findAll(Specification.allOf(specs), pageable)
                .map(TransactionResponse::from);
    }

    @Transactional
    public TransactionResponse updateCategory(Long transactionId, UpdateTransactionCategoryRequest request) {
        Long userId = currentUserService.getCurrentUserId();
        Transaction transaction = transactionRepository.findByIdAndUserId(transactionId, userId)
                .orElseThrow(() -> new ResourceNotFoundException("Transaction not found"));

        Category category = categoryRepository.findById(request.getCategoryId())
                .orElseThrow(() -> new ResourceNotFoundException("Category not found"));
        SubCategory subCategory = null;
        if (request.getSubCategoryId() != null) {
            subCategory = subCategoryRepository.findById(request.getSubCategoryId())
                    .filter(sc -> sc.getCategory().getId().equals(category.getId()))
                    .orElseThrow(() -> new ResourceNotFoundException(
                            "Sub-category not found under the given category"));
        }
        transaction.setCategory(category);
        transaction.setSubCategory(subCategory);
        return TransactionResponse.from(transactionRepository.save(transaction));
    }

    @Transactional
    public TransactionResponse updateTransfer(Long transactionId, boolean transfer) {
        Long userId = currentUserService.getCurrentUserId();
        Transaction transaction = transactionRepository.findByIdAndUserId(transactionId, userId)
                .orElseThrow(() -> new ResourceNotFoundException("Transaction not found"));
        transaction.setTransfer(transfer);
        if (!transfer && transaction.getTransferPairId() != null) {
            // Unlinking one leg unlinks the pair.
            transactionRepository.findByIdAndUserId(transaction.getTransferPairId(), userId).ifPresent(pair -> {
                pair.setTransfer(false);
                pair.setTransferPairId(null);
            });
            transaction.setTransferPairId(null);
        }
        return TransactionResponse.from(transactionRepository.save(transaction));
    }
}
