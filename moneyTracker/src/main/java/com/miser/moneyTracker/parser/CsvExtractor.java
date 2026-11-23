package com.miser.moneyTracker.parser;

import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVParser;
import org.apache.commons.csv.CSVRecord;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

@Component
public class CsvExtractor implements StatementExtractor {

    @Override
    public ExtractionResult extract(InputStream input, ExtractionContext context) {
        CSVFormat format = CSVFormat.DEFAULT.builder()
                .setIgnoreEmptyLines(true)
                .setTrim(true)
                .build();
        List<List<String>> rows = new ArrayList<>();
        try (CSVParser parser = CSVParser.parse(
                new InputStreamReader(input, StandardCharsets.UTF_8), format)) {
            for (CSVRecord record : parser) {
                rows.add(record.toList());
            }
        } catch (IOException e) {
            throw new StatementParseException("Failed to read CSV statement", e);
        }
        return new ExtractionResult(
                TableNormalizer.normalize(rows, context.kind()), context.issuerHint(), "table-csv");
    }
}
