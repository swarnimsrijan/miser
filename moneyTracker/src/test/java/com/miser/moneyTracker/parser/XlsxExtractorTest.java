package com.miser.moneyTracker.parser;

import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.junit.jupiter.api.Test;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;

class XlsxExtractorTest {

    @Test
    void parsesWorkbookWithDebitCreditColumns() throws Exception {
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        try (XSSFWorkbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("Statement");
            writeRow(sheet, 0, "Txn Date", "Particulars", "Debit", "Credit", "Balance");
            writeRow(sheet, 1, "02/05/2025", "POS 411111 BIG BAZAAR", "2500.00", "", "47500.00");
            writeRow(sheet, 2, "04/05/2025", "NEFT SALARY ACME", "", "85000.00", "132500.00");
            workbook.write(out);
        }

        List<RawTransaction> txns = new XlsxExtractor()
                .extract(new ByteArrayInputStream(out.toByteArray()));

        assertEquals(2, txns.size());
        assertEquals(LocalDate.of(2025, 5, 2), txns.get(0).getDate());
        assertEquals("DEBIT", txns.get(0).getType());
        assertEquals(0, new BigDecimal("2500.00").compareTo(txns.get(0).getAmount()));
        assertEquals("CREDIT", txns.get(1).getType());
    }

    private static void writeRow(Sheet sheet, int rowIndex, String... cells) {
        Row row = sheet.createRow(rowIndex);
        for (int i = 0; i < cells.length; i++) {
            row.createCell(i).setCellValue(cells[i]);
        }
    }
}
