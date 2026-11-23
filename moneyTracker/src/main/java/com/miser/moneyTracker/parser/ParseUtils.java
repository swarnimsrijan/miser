package com.miser.moneyTracker.parser;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeFormatterBuilder;
import java.util.List;
import java.util.Locale;
import java.util.stream.Stream;

/**
 * Lenient parsing helpers for the messy values found in real bank statements.
 */
public final class ParseUtils {

    private ParseUtils() {}

    // India-first: day before month. ISO included for exports from netbanking portals.
    // Case-insensitive so "02-APR-2025" (common in Indian bank PDFs) parses like "02-Apr-2025".
    private static final List<DateTimeFormatter> DATE_FORMATS = Stream.of(
                    "dd/MM/yyyy", "dd-MM-yyyy", "dd.MM.yyyy",
                    "dd/MM/yy", "dd-MM-yy", "dd.MM.yy",
                    "yyyy-MM-dd",
                    "d MMM yyyy", "d-MMM-yyyy", "d MMM, yyyy", "d MMM yy", "d-MMM-yy",
                    "d MMMM yyyy", "MMM d, yyyy")
            .map(pattern -> new DateTimeFormatterBuilder()
                    .parseCaseInsensitive()
                    .appendPattern(pattern)
                    .toFormatter(Locale.ENGLISH))
            .toList();

    /** @return parsed date, or null when the value is not a recognizable date */
    public static LocalDate parseDate(String value) {
        if (value == null) return null;
        String trimmed = value.trim().replaceAll("\\s+", " ");
        if (trimmed.isEmpty()) return null;
        for (DateTimeFormatter format : DATE_FORMATS) {
            try {
                return LocalDate.parse(trimmed, format);
            } catch (Exception ignored) {
                // try next format
            }
        }
        return null;
    }

    /**
     * Parses amounts like "1,23,456.78", "INR 500.00", "₹1,200", "(450.00)" (negative),
     * "500.00 Cr". @return the amount (negative for parenthesised values), or null.
     */
    public static BigDecimal parseAmount(String value) {
        if (value == null) return null;
        String trimmed = value.trim();
        if (trimmed.isEmpty() || trimmed.equals("-")) return null;
        boolean negative = (trimmed.startsWith("(") && trimmed.endsWith(")"))
                || trimmed.startsWith("-");
        String cleaned = trimmed
                .replaceAll("(?i)(inr|rs\\.?|cr|dr)", "")
                .replaceAll("[₹$,()+\\-\\s]", "")
                .replace(" ", "");
        if (cleaned.isEmpty() || cleaned.equals("-")) return null;
        try {
            BigDecimal amount = new BigDecimal(cleaned);
            return negative ? amount.negate() : amount;
        } catch (NumberFormatException e) {
            return null;
        }
    }

    /** Normalizes a header cell for matching: lowercase, alphanumerics and single spaces only. */
    public static String normalizeHeader(String header) {
        if (header == null) return "";
        return header.toLowerCase(Locale.ENGLISH)
                .replaceAll("[^a-z0-9]+", " ")
                .trim();
    }
}
