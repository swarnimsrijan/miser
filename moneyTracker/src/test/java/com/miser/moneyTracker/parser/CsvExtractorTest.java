package com.miser.moneyTracker.parser;

import org.junit.jupiter.api.Test;

import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

class CsvExtractorTest {

    private final CsvExtractor extractor = new CsvExtractor();

    private static InputStream csv(String content) {
        return new ByteArrayInputStream(content.getBytes(StandardCharsets.UTF_8));
    }

    @Test
    void parsesSplitDebitCreditColumnsWithPreamble() {
        String content = """
                Account Statement,,,,,
                Customer Name: John,,,,,
                ,,,,,
                Date,Narration,Chq./Ref.No.,Withdrawal Amt.,Deposit Amt.,Closing Balance
                01/04/2025,UPI-SWIGGY-swiggy@icici-402935,UPI-509912,450.00,,"12,550.00"
                03/04/2025,SALARY APR 2025 ACME CORP,NEFT-88123,,"85,000.00","97,550.00"
                ,,,,,
                Total,,,450.00,"85,000.00",
                """;

        List<RawTransaction> txns = extractor.extract(csv(content));

        assertEquals(2, txns.size());
        RawTransaction debit = txns.get(0);
        assertEquals(LocalDate.of(2025, 4, 1), debit.getDate());
        assertEquals("DEBIT", debit.getType());
        assertEquals(0, new BigDecimal("450.00").compareTo(debit.getAmount()));
        assertEquals(0, new BigDecimal("12550.00").compareTo(debit.getBalance()));
        assertEquals("UPI-509912", debit.getReference());

        RawTransaction credit = txns.get(1);
        assertEquals("CREDIT", credit.getType());
        assertEquals(0, new BigDecimal("85000.00").compareTo(credit.getAmount()));
    }

    @Test
    void parsesSingleAmountColumnWithTypeColumn() {
        String content = """
                Date,Description,Amount,Type,Balance
                05-04-2025,AMAZON PAY INDIA,1299.00,DR,11251.00
                06-04-2025,REFUND FLIPKART,499.00,CR,11750.00
                """;

        List<RawTransaction> txns = extractor.extract(csv(content));

        assertEquals(2, txns.size());
        assertEquals("DEBIT", txns.get(0).getType());
        assertEquals("CREDIT", txns.get(1).getType());
    }

    @Test
    void parsesSignedAmounts() {
        String content = """
                Transaction Date,Details,Amount
                2025-04-10,UBER RIDE,-350.50
                2025-04-11,CASHBACK,25.00
                """;

        List<RawTransaction> txns = extractor.extract(csv(content));

        assertEquals(2, txns.size());
        assertEquals("DEBIT", txns.get(0).getType());
        assertEquals(0, new BigDecimal("350.50").compareTo(txns.get(0).getAmount()));
        assertEquals("CREDIT", txns.get(1).getType());
    }

    @Test
    void failsClearlyWhenNoHeaderFound() {
        assertThrows(StatementParseException.class,
                () -> extractor.extract(csv("just,some,random\nvalues,without,headers\n")));
    }

    @Test
    void creditCardExportTreatsPositiveAsChargeAndNegativeAsPayment() {
        String content = """
                Date,Description,Amount
                05/04/2025,ZOMATO,350.00
                10/04/2025,PAYMENT RECEIVED,-5000.00
                """;

        List<RawTransaction> txns = extractor.extract(csv(content), ExtractionContext.creditCard()).transactions();

        assertEquals("DEBIT", txns.get(0).getType());
        assertEquals("CREDIT", txns.get(1).getType());
        assertEquals(0, new BigDecimal("5000.00").compareTo(txns.get(1).getAmount()));
    }
}
