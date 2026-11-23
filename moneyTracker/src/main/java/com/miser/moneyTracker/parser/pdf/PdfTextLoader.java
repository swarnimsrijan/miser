package com.miser.moneyTracker.parser.pdf;

import com.miser.moneyTracker.parser.StatementParseException;
import com.miser.moneyTracker.parser.StatementPasswordException;
import org.apache.pdfbox.Loader;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.encryption.InvalidPasswordException;
import org.apache.pdfbox.text.PDFTextStripper;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

/** Opens a (possibly encrypted) PDF and returns its text as position-sorted lines. */
public final class PdfTextLoader {

    private PdfTextLoader() {}

    public static List<String> loadLines(byte[] pdf, String password) {
        boolean hasPassword = password != null && !password.isEmpty();
        // Loader.loadPDF(bytes) still opens PDFs that only carry an owner
        // password (print/copy restrictions), which many banks set.
        try (PDDocument document = hasPassword ? Loader.loadPDF(pdf, password) : Loader.loadPDF(pdf)) {
            PDFTextStripper stripper = new PDFTextStripper();
            stripper.setSortByPosition(true);
            String text = stripper.getText(document);
            return text == null ? List.of() : Arrays.asList(text.split("\\r?\\n"));
        } catch (InvalidPasswordException e) {
            throw new StatementPasswordException(hasPassword
                    ? StatementPasswordException.Reason.PASSWORD_INCORRECT
                    : StatementPasswordException.Reason.PASSWORD_REQUIRED);
        } catch (IOException e) {
            throw new StatementParseException("Failed to read PDF statement", e);
        }
    }
}
