package com.miser.moneyTracker.parser;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.PDPageContentStream;
import org.apache.pdfbox.pdmodel.encryption.AccessPermission;
import org.apache.pdfbox.pdmodel.encryption.StandardProtectionPolicy;
import org.apache.pdfbox.pdmodel.font.PDType1Font;
import org.apache.pdfbox.pdmodel.font.Standard14Fonts;
import org.junit.jupiter.api.Test;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Synthetic statements shaped like common Indian bank / card layouts. They
 * exercise the generic layouts; real-format fixtures belong next to them.
 */
class MultiIssuerPdfTest {

    private final PdfExtractor extractor = new PdfExtractor();

    @Test
    void bankStatementWithValueDateWrappedNarrationAndDebitCreditColumns() throws Exception {
        byte[] pdf = pdf(null,
                "HDFC BANK Ltd.            Statement of account",
                "Date Narration Value Dt Withdrawal Amt. Deposit Amt. Closing Balance",
                "01/04/25 OPENING BALANCE 01/04/25 0.00 0.00 20,000.00",
                "02/04/25 UPI-SWIGGY-swiggy@icici 02/04/25 450.00 0.00 19,550.00",
                "UPI/509912345/Payment for food",
                "Page 1 of 2",
                "05-APR-2025 05-APR-2025 NEFT CR-ACME CORP SALARY 0.00 85,000.00 1,04,550.00");

        ExtractionResult result = extractor.extract(new ByteArrayInputStream(pdf),
                new ExtractionContext(StatementKind.BANK_ACCOUNT, null, null));

        assertEquals("HDFC", result.issuer());
        assertEquals("generic-bank", result.layout());
        List<RawTransaction> txns = result.transactions();
        assertEquals(2, txns.size());

        RawTransaction swiggy = txns.get(0);
        assertEquals("DEBIT", swiggy.getType());
        assertEquals(0, new BigDecimal("450.00").compareTo(swiggy.getAmount()));
        assertEquals(0, new BigDecimal("19550.00").compareTo(swiggy.getBalance()));
        // Wrapped narration joined; the page footer is not glued on.
        assertTrue(swiggy.getDescription().startsWith("UPI-SWIGGY-swiggy@icici"));
        assertTrue(swiggy.getDescription().endsWith("UPI/509912345/Payment for food"));

        RawTransaction salary = txns.get(1);
        assertEquals(LocalDate.of(2025, 4, 5), salary.getDate());
        assertEquals("CREDIT", salary.getType());
        assertEquals(0, new BigDecimal("85000.00").compareTo(salary.getAmount()));
    }

    @Test
    void creditCardStatementWithMarkersForeignAmountsAndSummaryRows() throws Exception {
        byte[] pdf = pdf(null,
                "ICICI Bank Credit Card Statement",
                "Statement Date 15/04/2025   Payment Due Date 05/05/2025",
                "15/04/2025 Total Amount Due 12,345.67",
                "Date SerNo. Transaction Details Reward Points Amount (in Rs.)",
                "18/03/2025 SWIGGY BANGALORE IN 12 450.00",
                "20/03/2025 14:22:10 AMAZON WEB SERVICES USD 12.00 1,034.56",
                "25/03/2025 BBPS PAYMENT RECEIVED - THANK YOU 10,000.00 CR",
                "28/03/2025 FLIPKART REFUND + ₹ 499.00",
                "30/03/2025 IGST-VPS2502 18.00");

        ExtractionResult result = extractor.extract(new ByteArrayInputStream(pdf),
                new ExtractionContext(StatementKind.CREDIT_CARD, "HDFC", null));

        // Header wins over the account's bank hint.
        assertEquals("ICICI", result.issuer());
        assertEquals("generic-credit-card", result.layout());
        List<RawTransaction> txns = result.transactions();
        assertEquals(5, txns.size(), () -> txns.toString());

        assertEquals("DEBIT", txns.get(0).getType());
        assertEquals(0, new BigDecimal("450.00").compareTo(txns.get(0).getAmount()));

        RawTransaction aws = txns.get(1);
        assertEquals("AMAZON WEB SERVICES", aws.getDescription());
        assertEquals(0, new BigDecimal("1034.56").compareTo(aws.getAmount()));
        assertEquals("DEBIT", aws.getType());

        assertEquals("CREDIT", txns.get(2).getType());
        assertEquals(0, new BigDecimal("10000.00").compareTo(txns.get(2).getAmount()));
        assertEquals("CREDIT", txns.get(3).getType());
        assertEquals(0, new BigDecimal("499.00").compareTo(txns.get(3).getAmount()));
        assertEquals("DEBIT", txns.get(4).getType());
    }

    @Test
    void usesBankHintWhenHeaderHasNoIssuer() throws Exception {
        byte[] pdf = pdf(null,
                "Card statement",
                "03 Apr 2025 UBER INDIA 320.00");

        ExtractionResult result = extractor.extract(new ByteArrayInputStream(pdf),
                new ExtractionContext(StatementKind.CREDIT_CARD, "Kotak", null));

        assertEquals("KOTAK", result.issuer());
        assertEquals(1, result.transactions().size());
    }

    @Test
    void opensPasswordProtectedPdf() throws Exception {
        byte[] pdf = pdf("ABCD0101",
                "AXIS BANK",
                "02/04/2025 ATM WDL 2,000.00 8,000.00");

        StatementPasswordException missing = assertThrows(StatementPasswordException.class,
                () -> extractor.extract(new ByteArrayInputStream(pdf), ExtractionContext.bankAccount()));
        assertEquals(StatementPasswordException.Reason.PASSWORD_REQUIRED, missing.getReason());

        StatementPasswordException wrong = assertThrows(StatementPasswordException.class,
                () -> extractor.extract(new ByteArrayInputStream(pdf),
                        ExtractionContext.bankAccount().withPassword("nope")));
        assertEquals(StatementPasswordException.Reason.PASSWORD_INCORRECT, wrong.getReason());

        ExtractionResult result = extractor.extract(new ByteArrayInputStream(pdf),
                ExtractionContext.bankAccount().withPassword("ABCD0101"));
        assertEquals("AXIS", result.issuer());
        assertEquals(1, result.transactions().size());
    }

    @Test
    void contextToStringRedactsPassword() {
        String text = ExtractionContext.bankAccount().withPassword("hunter2").toString();
        assertFalse(text.contains("hunter2"));
    }

    private static byte[] pdf(String userPassword, String... lines) throws Exception {
        try (PDDocument document = new PDDocument();
             ByteArrayOutputStream out = new ByteArrayOutputStream()) {
            PDPage page = new PDPage();
            document.addPage(page);
            // Standard 14 fonts are WinAnsi-only; "₹" is not encodable there.
            PDType1Font font = new PDType1Font(Standard14Fonts.FontName.HELVETICA);
            try (PDPageContentStream content = new PDPageContentStream(document, page)) {
                content.setFont(font, 9);
                float y = 750;
                for (String line : lines) {
                    content.beginText();
                    content.newLineAtOffset(30, y);
                    content.showText(line.replace("₹", "Rs."));
                    content.endText();
                    y -= 14;
                }
            }
            if (userPassword != null) {
                StandardProtectionPolicy policy = new StandardProtectionPolicy(
                        "owner-" + userPassword, userPassword, new AccessPermission());
                policy.setEncryptionKeyLength(128);
                document.protect(policy);
            }
            document.save(out);
            return out.toByteArray();
        }
    }
}
