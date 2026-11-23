package com.miser.moneyTracker.parser;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * Turns a grid of cells (from CSV or XLSX) into RawTransactions.
 * Locates the header row (statements often have preamble lines above it),
 * maps bank-specific column names onto canonical fields, and normalizes
 * each data row. Handles both split debit/credit columns and single
 * amount columns (with a DR/CR type column or signed amounts).
 */
public final class TableNormalizer {

    private TableNormalizer() {}

    private static final Set<String> DATE_HEADERS = Set.of(
            "date", "txn date", "transaction date", "value date", "tran date",
            "value dt", "post date", "posting date", "trans date");
    private static final Set<String> DESCRIPTION_HEADERS = Set.of(
            "description", "narration", "particulars", "details", "transaction details",
            "transaction remarks", "remarks", "transaction description", "merchant");
    private static final Set<String> DEBIT_HEADERS = Set.of(
            "debit", "withdrawal", "withdrawal amt", "withdrawal amount", "debit amount",
            "dr", "dr amount", "paid out", "withdrawal amt inr", "debit inr", "money out");
    private static final Set<String> CREDIT_HEADERS = Set.of(
            "credit", "deposit", "deposit amt", "deposit amount", "credit amount",
            "cr", "cr amount", "paid in", "deposit amt inr", "credit inr", "money in");
    private static final Set<String> AMOUNT_HEADERS = Set.of(
            "amount", "transaction amount", "amount inr", "amt", "txn amount");
    private static final Set<String> TYPE_HEADERS = Set.of(
            "type", "dr cr", "cr dr", "transaction type", "debit credit", "dr or cr");
    private static final Set<String> BALANCE_HEADERS = Set.of(
            "balance", "closing balance", "running balance", "available balance",
            "balance amt", "closing balance inr", "balance inr");
    private static final Set<String> REFERENCE_HEADERS = Set.of(
            "ref no", "reference", "reference no", "reference number", "cheque no",
            "chq no", "chq ref no", "chq ref number", "utr", "utr no",
            "transaction id", "txn id", "ref no cheque no");

    private record ColumnMap(int date, int description, int debit, int credit,
                             int amount, int type, int balance, int reference) {

        boolean isUsable() {
            return date >= 0 && (debit >= 0 || credit >= 0 || amount >= 0);
        }
    }

    public static List<RawTransaction> normalize(List<List<String>> rows) {
        return normalize(rows, StatementKind.BANK_ACCOUNT);
    }

    /**
     * @param kind credit-card exports usually list charges as positive and
     *             payments/refunds as negative (the reverse of bank exports),
     *             so the sign convention for single-amount columns flips.
     */
    public static List<RawTransaction> normalize(List<List<String>> rows, StatementKind kind) {
        int headerIndex = -1;
        ColumnMap columns = null;
        // Statements commonly carry account metadata above the table; scan for the header.
        for (int i = 0; i < Math.min(rows.size(), 30); i++) {
            ColumnMap candidate = mapColumns(rows.get(i));
            if (candidate.isUsable()) {
                headerIndex = i;
                columns = candidate;
                break;
            }
        }
        if (columns == null) {
            throw new StatementParseException(
                    "Could not locate a header row with date and amount columns");
        }

        List<RawTransaction> transactions = new ArrayList<>();
        for (int i = headerIndex + 1; i < rows.size(); i++) {
            RawTransaction txn = normalizeRow(rows.get(i), columns, kind);
            if (txn != null) {
                transactions.add(txn);
            }
        }
        return transactions;
    }

    private static ColumnMap mapColumns(List<String> row) {
        Map<String, Integer> indexByField = new HashMap<>();
        for (int i = 0; i < row.size(); i++) {
            String header = ParseUtils.normalizeHeader(row.get(i));
            if (header.isEmpty()) continue;
            putIfMatch(indexByField, "date", i, header, DATE_HEADERS);
            putIfMatch(indexByField, "description", i, header, DESCRIPTION_HEADERS);
            putIfMatch(indexByField, "debit", i, header, DEBIT_HEADERS);
            putIfMatch(indexByField, "credit", i, header, CREDIT_HEADERS);
            putIfMatch(indexByField, "amount", i, header, AMOUNT_HEADERS);
            putIfMatch(indexByField, "type", i, header, TYPE_HEADERS);
            putIfMatch(indexByField, "balance", i, header, BALANCE_HEADERS);
            putIfMatch(indexByField, "reference", i, header, REFERENCE_HEADERS);
        }
        return new ColumnMap(
                indexByField.getOrDefault("date", -1),
                indexByField.getOrDefault("description", -1),
                indexByField.getOrDefault("debit", -1),
                indexByField.getOrDefault("credit", -1),
                indexByField.getOrDefault("amount", -1),
                indexByField.getOrDefault("type", -1),
                indexByField.getOrDefault("balance", -1),
                indexByField.getOrDefault("reference", -1));
    }

    private static void putIfMatch(Map<String, Integer> indexByField, String field,
                                   int index, String header, Set<String> synonyms) {
        if (indexByField.containsKey(field)) return;
        if (synonyms.contains(header)) {
            indexByField.put(field, index);
            return;
        }
        // Fallback for suffixed variants like "withdrawal amt 500067123".
        for (String synonym : synonyms) {
            if (synonym.length() > 3 && header.startsWith(synonym + " ")) {
                indexByField.put(field, index);
                return;
            }
        }
    }

    private static RawTransaction normalizeRow(List<String> row, ColumnMap columns, StatementKind kind) {
        LocalDate date = ParseUtils.parseDate(cell(row, columns.date()));
        if (date == null) return null; // footer, totals or blank line

        BigDecimal debit = columns.debit() >= 0 ? positiveOrNull(ParseUtils.parseAmount(cell(row, columns.debit()))) : null;
        BigDecimal credit = columns.credit() >= 0 ? positiveOrNull(ParseUtils.parseAmount(cell(row, columns.credit()))) : null;

        BigDecimal amount;
        String type;
        if (debit != null) {
            amount = debit;
            type = "DEBIT";
        } else if (credit != null) {
            amount = credit;
            type = "CREDIT";
        } else if (columns.amount() >= 0) {
            BigDecimal raw = ParseUtils.parseAmount(cell(row, columns.amount()));
            if (raw == null) return null;
            type = resolveType(cell(row, columns.type()), cell(row, columns.amount()), raw, kind);
            amount = raw.abs();
        } else {
            return null;
        }

        return RawTransaction.builder()
                .date(date)
                .description(trimToNull(cell(row, columns.description())))
                .amount(amount)
                .type(type)
                .balance(ParseUtils.parseAmount(cell(row, columns.balance())))
                .reference(trimToNull(cell(row, columns.reference())))
                .build();
    }

    private static String resolveType(String typeCell, String amountCell, BigDecimal rawAmount,
                                      StatementKind kind) {
        String type = typeCell == null ? "" : typeCell.trim().toUpperCase();
        if (type.startsWith("D")) return "DEBIT";
        if (type.startsWith("C")) return "CREDIT";
        String amountText = amountCell == null ? "" : amountCell.toUpperCase();
        if (amountText.endsWith("CR")) return "CREDIT";
        if (amountText.endsWith("DR")) return "DEBIT";
        if (kind == StatementKind.CREDIT_CARD) {
            // Card exports: positive = charge, negative = payment/refund.
            return rawAmount.signum() < 0 ? "CREDIT" : "DEBIT";
        }
        // Signed bank exports: negative means money out.
        return rawAmount.signum() < 0 ? "DEBIT" : "CREDIT";
    }

    private static BigDecimal positiveOrNull(BigDecimal value) {
        return value == null || value.signum() == 0 ? null : value.abs();
    }

    private static String cell(List<String> row, int index) {
        if (index < 0 || index >= row.size()) return null;
        return row.get(index);
    }

    private static String trimToNull(String value) {
        if (value == null) return null;
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }
}
