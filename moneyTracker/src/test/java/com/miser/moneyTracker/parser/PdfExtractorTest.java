package com.miser.moneyTracker.parser;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.PDPageContentStream;
import org.apache.pdfbox.pdmodel.font.PDType1Font;
import org.apache.pdfbox.pdmodel.font.Standard14Fonts;
import org.junit.jupiter.api.Test;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

class PdfExtractorTest {

    @Test
    void parsesTextPdfUsingRunningBalanceForDirection() throws Exception {
        byte[] pdf = pdfWithLines(
                "Bank Statement - April 2025",
                "Date Narration Amount Balance",
                "01/04/2025 OPENING BALANCE 0.00 10,000.00",
                "02/04/2025 UPI-ZOMATO-zomato@paytm 350.00 9,650.00",
                "03/04/2025 SALARY ACME CORP 85,000.00 94,650.00");

        List<RawTransaction> txns = new PdfExtractor().extract(new ByteArrayInputStream(pdf));

        // The zero-amount opening-balance row is not a transaction, but its
        // balance seeds the delta used to derive direction for later rows.
        assertEquals(2, txns.size());
        RawTransaction zomato = txns.get(0);
        assertEquals(LocalDate.of(2025, 4, 2), zomato.getDate());
        assertEquals("DEBIT", zomato.getType());
        assertEquals(0, new BigDecimal("350.00").compareTo(zomato.getAmount()));
        assertEquals("CREDIT", txns.get(1).getType());
    }

    @Test
    void failsClearlyOnPdfWithoutTransactions() throws Exception {
        byte[] pdf = pdfWithLines("This PDF has no transactions at all");
        assertThrows(StatementParseException.class,
                () -> new PdfExtractor().extract(new ByteArrayInputStream(pdf)));
    }

    private static byte[] pdfWithLines(String... lines) throws Exception {
        try (PDDocument document = new PDDocument();
             ByteArrayOutputStream out = new ByteArrayOutputStream()) {
            PDPage page = new PDPage();
            document.addPage(page);
            try (PDPageContentStream content = new PDPageContentStream(document, page)) {
                content.setFont(new PDType1Font(Standard14Fonts.FontName.HELVETICA), 10);
                float y = 750;
                for (String line : lines) {
                    content.beginText();
                    content.newLineAtOffset(50, y);
                    content.showText(line);
                    content.endText();
                    y -= 15;
                }
            }
            document.save(out);
            return out.toByteArray();
        }
    }
}
