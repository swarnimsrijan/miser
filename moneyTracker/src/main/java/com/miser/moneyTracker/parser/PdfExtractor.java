package com.miser.moneyTracker.parser;

import com.miser.moneyTracker.parser.pdf.GenericBankLayout;
import com.miser.moneyTracker.parser.pdf.GenericCreditCardLayout;
import com.miser.moneyTracker.parser.pdf.IssuerDetector;
import com.miser.moneyTracker.parser.pdf.PdfLayout;
import com.miser.moneyTracker.parser.pdf.PdfTextLoader;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.io.InputStream;
import java.util.Comparator;
import java.util.List;

/**
 * Text-based PDF statements from any bank or card issuer. Opens the document
 * (with the user's password if encrypted), detects the issuer from the header,
 * then tries the matching layouts - issuer-specific first, generic last - and
 * returns the first non-empty result. Scanned/image PDFs are not supported.
 */
@Component
public class PdfExtractor implements StatementExtractor {

    private final List<PdfLayout> layouts;

    /** Generic layouts only; for tests and non-Spring use. */
    public PdfExtractor() {
        this(List.of(new GenericBankLayout(), new GenericCreditCardLayout()));
    }

    @Autowired
    public PdfExtractor(List<PdfLayout> layouts) {
        this.layouts = layouts.stream()
                .sorted(Comparator.comparingInt(PdfLayout::priority).reversed())
                .toList();
    }

    @Override
    public ExtractionResult extract(InputStream input, ExtractionContext context) {
        byte[] bytes;
        try {
            bytes = input.readAllBytes();
        } catch (IOException e) {
            throw new StatementParseException("Failed to read PDF statement", e);
        }
        List<String> lines = PdfTextLoader.loadLines(bytes, context.password());
        if (lines.stream().allMatch(String::isBlank)) {
            throw new StatementParseException(
                    "No text found in PDF - scanned/image statements are not supported");
        }

        String issuer = IssuerDetector.detect(lines)
                .orElseGet(() -> IssuerDetector.fromHint(context.issuerHint()));
        for (PdfLayout layout : layouts) {
            if (!layout.supports(context.kind(), issuer)) continue;
            List<RawTransaction> transactions = layout.parse(lines);
            if (!transactions.isEmpty()) {
                return new ExtractionResult(transactions, issuer, layout.id());
            }
        }
        throw new StatementParseException("No transactions recognized in PDF - unsupported "
                + (issuer == null ? "" : issuer + " ") + "statement layout");
    }
}
