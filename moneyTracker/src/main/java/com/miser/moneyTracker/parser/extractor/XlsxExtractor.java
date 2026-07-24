package com.miser.moneyTracker.parser.extractor;

import com.miser.moneyTracker.parser.normalizer.RawTransaction;
import org.springframework.stereotype.Component;
import java.io.InputStream;
import java.util.List;

@Component
public class XlsxExtractor implements StatementExtractor {

    @Override
    public List<RawTransaction> extract(InputStream input) {
        // TODO: implement XLSX parsing
        return List.of();
    }
}
