package com.miser.moneyTracker.report;

import com.miser.moneyTracker.transaction.Transaction;
import com.miser.moneyTracker.transaction.TransactionRepository;
import com.miser.moneyTracker.user.CurrentUserService;
import lombok.RequiredArgsConstructor;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.PDPageContentStream;
import org.apache.pdfbox.pdmodel.common.PDRectangle;
import org.apache.pdfbox.pdmodel.font.PDType1Font;
import org.apache.pdfbox.pdmodel.font.Standard14Fonts;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.UncheckedIOException;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.util.Comparator;
import java.util.List;

@Service
@RequiredArgsConstructor
public class ReportService {

    private static final String[] HEADERS = {
            "Date", "Description", "Merchant", "Category", "Sub-category",
            "Type", "Amount", "Balance", "Reference"};

    private final TransactionRepository transactionRepository;
    private final CurrentUserService currentUserService;

    @Transactional(readOnly = true)
    public byte[] csv(LocalDate from, LocalDate to) {
        StringBuilder out = new StringBuilder(String.join(",", HEADERS)).append('\n');
        for (Transaction t : fetch(from, to)) {
            String[] row = row(t);
            for (int i = 0; i < row.length; i++) {
                if (i > 0) out.append(',');
                out.append(escapeCsv(row[i]));
            }
            out.append('\n');
        }
        return out.toString().getBytes(StandardCharsets.UTF_8);
    }

    @Transactional(readOnly = true)
    public byte[] excel(LocalDate from, LocalDate to) {
        try (XSSFWorkbook workbook = new XSSFWorkbook();
             ByteArrayOutputStream out = new ByteArrayOutputStream()) {
            Sheet sheet = workbook.createSheet("Transactions");
            Row header = sheet.createRow(0);
            for (int i = 0; i < HEADERS.length; i++) {
                header.createCell(i).setCellValue(HEADERS[i]);
            }
            int rowIndex = 1;
            for (Transaction t : fetch(from, to)) {
                Row row = sheet.createRow(rowIndex++);
                String[] cells = row(t);
                for (int i = 0; i < cells.length; i++) {
                    if (i == 6 || i == 7) { // numeric columns
                        if (!cells[i].isEmpty()) {
                            row.createCell(i).setCellValue(Double.parseDouble(cells[i]));
                        }
                    } else {
                        row.createCell(i).setCellValue(cells[i]);
                    }
                }
            }
            workbook.write(out);
            return out.toByteArray();
        } catch (IOException e) {
            throw new UncheckedIOException("Failed to build Excel report", e);
        }
    }

    @Transactional(readOnly = true)
    public byte[] pdf(LocalDate from, LocalDate to) {
        List<Transaction> transactions = fetch(from, to);
        try (PDDocument document = new PDDocument();
             ByteArrayOutputStream out = new ByteArrayOutputStream()) {
            var font = new PDType1Font(Standard14Fonts.FontName.HELVETICA);
            var bold = new PDType1Font(Standard14Fonts.FontName.HELVETICA_BOLD);

            int index = 0;
            while (index == 0 || index < transactions.size()) {
                PDPage page = new PDPage(PDRectangle.A4);
                document.addPage(page);
                try (PDPageContentStream content = new PDPageContentStream(document, page)) {
                    float y = PDRectangle.A4.getHeight() - 40;
                    content.beginText();
                    content.setFont(bold, 12);
                    content.newLineAtOffset(40, y);
                    content.showText("Transaction Report");
                    content.endText();
                    y -= 25;

                    content.beginText();
                    content.setFont(bold, 8);
                    content.newLineAtOffset(40, y);
                    content.showText(String.format("%-11s %-45s %-16s %-7s %12s",
                            "Date", "Description", "Category", "Type", "Amount"));
                    content.endText();
                    y -= 14;

                    content.setFont(font, 8);
                    while (index < transactions.size() && y > 40) {
                        Transaction t = transactions.get(index++);
                        String line = String.format("%-11s %-45s %-16s %-7s %12s",
                                t.getTransactionDate(),
                                clip(safe(t.getDescription()), 45),
                                clip(t.getCategory() == null ? "" : t.getCategory().getName(), 16),
                                t.getTransactionType(),
                                t.getAmount().toPlainString());
                        content.beginText();
                        content.newLineAtOffset(40, y);
                        content.showText(sanitizePdf(line));
                        content.endText();
                        y -= 12;
                    }
                }
                if (transactions.isEmpty()) break;
            }
            document.save(out);
            return out.toByteArray();
        } catch (IOException e) {
            throw new UncheckedIOException("Failed to build PDF report", e);
        }
    }

    private List<Transaction> fetch(LocalDate from, LocalDate to) {
        LocalDate start = from != null ? from : LocalDate.EPOCH;
        LocalDate end = to != null ? to : LocalDate.now();
        return transactionRepository
                .findByUserIdAndTransactionDateBetween(currentUserService.getCurrentUserId(), start, end)
                .stream()
                .sorted(Comparator.comparing(Transaction::getTransactionDate))
                .toList();
    }

    private String[] row(Transaction t) {
        return new String[]{
                t.getTransactionDate().toString(),
                safe(t.getDescription()),
                t.getMerchant() == null ? "" : t.getMerchant().getName(),
                t.getCategory() == null ? "" : t.getCategory().getName(),
                t.getSubCategory() == null ? "" : t.getSubCategory().getName(),
                t.getTransactionType().name(),
                t.getAmount().toPlainString(),
                t.getBalance() == null ? "" : t.getBalance().toPlainString(),
                safe(t.getReference())};
    }

    private static String safe(String value) {
        return value == null ? "" : value;
    }

    private static String escapeCsv(String value) {
        if (value.contains(",") || value.contains("\"") || value.contains("\n")) {
            return '"' + value.replace("\"", "\"\"") + '"';
        }
        return value;
    }

    private static String clip(String value, int max) {
        return value.length() <= max ? value : value.substring(0, max - 1) + "…";
    }

    /** Standard-14 fonts only cover WinAnsi; replace anything outside it. */
    private static String sanitizePdf(String value) {
        StringBuilder sb = new StringBuilder(value.length());
        for (char c : value.toCharArray()) {
            sb.append(c >= 32 && c <= 255 ? c : '?');
        }
        return sb.toString();
    }
}
