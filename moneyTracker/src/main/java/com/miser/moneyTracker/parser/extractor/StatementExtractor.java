package com.miser.moneyTracker.parser.extractor;

import com.miser.moneyTracker.parser.normalizer.RawTransaction;
import java.io.InputStream;
import java.util.List;

public interface StatementExtractor {
    List<RawTransaction> extract(InputStream input);
}
