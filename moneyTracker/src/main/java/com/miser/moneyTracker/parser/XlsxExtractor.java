package com.miser.moneyTracker.parser;

import org.apache.poi.EncryptedDocumentException;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.springframework.stereotype.Component;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

@Component
public class XlsxExtractor implements StatementExtractor {

    @Override
    public ExtractionResult extract(InputStream input, ExtractionContext context) {
        List<List<String>> rows = new ArrayList<>();
        // DataFormatter renders cells as displayed (dates as dd/MM/yyyy etc.),
        // which the shared normalizer knows how to parse.
        DataFormatter formatter = new DataFormatter();
        try (Workbook workbook = WorkbookFactory.create(input, context.password())) {
            Sheet sheet = workbook.getSheetAt(0);
            for (Row row : sheet) {
                List<String> cells = new ArrayList<>();
                short lastCell = row.getLastCellNum();
                for (int c = 0; c < lastCell; c++) {
                    Cell cell = row.getCell(c, Row.MissingCellPolicy.RETURN_BLANK_AS_NULL);
                    cells.add(cell == null ? "" : formatter.formatCellValue(cell));
                }
                rows.add(cells);
            }
        } catch (EncryptedDocumentException e) {
            // Thrown both when a password is needed and when the given one is wrong.
            throw new StatementPasswordException(context.password() == null
                    ? StatementPasswordException.Reason.PASSWORD_REQUIRED
                    : StatementPasswordException.Reason.PASSWORD_INCORRECT);
        } catch (Exception e) {
            throw new StatementParseException("Failed to read Excel statement", e);
        }
        return new ExtractionResult(
                TableNormalizer.normalize(rows, context.kind()), context.issuerHint(), "table-xlsx");
    }
}
