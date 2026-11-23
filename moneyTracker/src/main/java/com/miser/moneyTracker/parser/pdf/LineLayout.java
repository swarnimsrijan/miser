package com.miser.moneyTracker.parser.pdf;

import com.miser.moneyTracker.parser.RawTransaction;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

/**
 * Base for layouts where every transaction begins on a line starting with a
 * date. Handles narrations that wrap onto following lines, which is common
 * (UPI/NEFT references, long merchant names).
 */
public abstract class LineLayout implements PdfLayout {

    private static final int MAX_CONTINUATION_LINES = 2;
    private static final int MAX_CONTINUATION_LENGTH = 70;

    // Page furniture and table headers that must never be glued onto a narration.
    private static final Pattern NOISE = Pattern.compile(
            "(?i)\\b(page|statement|balance|total|opening|closing|summary|account|customer|"
            + "branch|ifsc|micr|address|generated|computer|signature|continued|carried|brought|"
            + "forward|narration|particulars|withdrawal|deposit|reward|points|limit|due|gstin|"
            + "cin|toll|helpline|email|registered|office)\\b|www\\.|https?:|\\bdate\\b");

    /** Per-document mutable state (e.g. last running balance). */
    protected interface ParseState {}

    protected abstract ParseState newState();

    /** @return a transaction for this dated line, or null if it is not one. */
    protected abstract RawTransaction parseLine(StatementLine line, ParseState state);

    @Override
    public List<RawTransaction> parse(List<String> lines) {
        List<RawTransaction> transactions = new ArrayList<>();
        ParseState state = newState();
        RawTransaction last = null;
        int continuations = 0;
        for (String rawLine : lines) {
            StatementLine line = StatementLine.parse(rawLine);
            if (line != null) {
                RawTransaction txn = parseLine(line, state);
                if (txn != null) transactions.add(txn);
                last = txn;
                continuations = 0;
                continue;
            }
            if (last != null && continuations < MAX_CONTINUATION_LINES && isContinuation(rawLine)) {
                String description = last.getDescription();
                String extra = rawLine.trim();
                last.setDescription(description == null ? extra : description + " " + extra);
                continuations++;
            } else {
                last = null;
            }
        }
        return transactions;
    }

    private static boolean isContinuation(String line) {
        String trimmed = line == null ? "" : line.trim();
        return !trimmed.isEmpty()
                && trimmed.length() <= MAX_CONTINUATION_LENGTH
                && trimmed.chars().anyMatch(Character::isLetterOrDigit)
                && StatementLine.moneyTokens(trimmed).isEmpty()
                && !NOISE.matcher(trimmed).find();
    }

    protected static String blankToNull(String value) {
        return value == null || value.isBlank() ? null : value.trim();
    }
}
