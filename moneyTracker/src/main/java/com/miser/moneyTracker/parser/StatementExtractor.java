package com.miser.moneyTracker.parser;

import java.io.InputStream;
import java.util.List;

public interface StatementExtractor {

    ExtractionResult extract(InputStream input, ExtractionContext context);

    /** Convenience for bank-account statements with no password. */
    default List<RawTransaction> extract(InputStream input) {
        return extract(input, ExtractionContext.bankAccount()).transactions();
    }
}
