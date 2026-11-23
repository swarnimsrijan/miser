package com.miser.moneyTracker.parser.pdf;

import com.miser.moneyTracker.parser.RawTransaction;
import com.miser.moneyTracker.parser.StatementKind;

import java.util.List;

/**
 * Parses the text lines of one family of PDF statements. Register a
 * Spring bean per bank/card format; issuer-specific layouts should return a
 * higher {@link #priority()} than the generic fallbacks so they are tried first.
 */
public interface PdfLayout {

    String id();

    boolean supports(StatementKind kind, String issuer);

    default int priority() { return 0; }

    /** @return transactions in statement order; empty when the layout does not fit. */
    List<RawTransaction> parse(List<String> lines);
}
