package com.miser.moneyTracker.parser.pdf;

import com.miser.moneyTracker.parser.RawTransaction;
import com.miser.moneyTracker.parser.StatementKind;
import com.miser.moneyTracker.parser.pdf.StatementLine.Marker;
import com.miser.moneyTracker.parser.pdf.StatementLine.MoneyToken;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.regex.Pattern;

/**
 * Fallback for credit-card PDFs of any issuer. Card statements have no running
 * balance: the last money token on a line is the billed amount (an earlier one
 * is usually the foreign-currency amount). Everything is a charge unless the
 * amount is marked Cr / "+" / negative, or the narration is clearly a payment,
 * refund or reversal.
 */
@Component
public class GenericCreditCardLayout extends LineLayout {

    private static final Pattern CREDIT_KEYWORDS = Pattern.compile(
            "(?i)(payment\\s+(received|recd|-?\\s*thank\\s*you)|thank\\s+you|\\bbbps\\b|autopay|"
            + "auto\\s+debit\\s+payment|\\brefund|\\breversal|\\breversed|cash\\s?back|credit\\s+adj)");

    // Account-summary rows that also start with a date (statement/due date tables).
    private static final Pattern SUMMARY = Pattern.compile(
            "(?i)(total\\s+(amount|dues?|outstanding|payments?|purchases?)|minimum\\s+(amount\\s+)?due|"
            + "min\\.?\\s+amt|amount\\s+due|payment\\s+due|statement\\s+(date|period)|"
            + "(previous|opening|closing)\\s+balance|(credit|cash|available)\\s+limit)");

    private static final Pattern TRAILING_CURRENCY = Pattern.compile(
            "\\s+(USD|EUR|GBP|AED|SGD|JPY|AUD|CAD|CHF|THB|MYR|HKD|NZD|SAR|QAR|LKR|NPR)$");

    private static final ParseState NO_STATE = new ParseState() {};

    @Override
    public String id() { return "generic-credit-card"; }

    @Override
    public boolean supports(StatementKind kind, String issuer) {
        return kind == StatementKind.CREDIT_CARD;
    }

    @Override
    protected ParseState newState() { return NO_STATE; }

    @Override
    protected RawTransaction parseLine(StatementLine line, ParseState state) {
        List<MoneyToken> tokens = line.money();
        if (tokens.isEmpty()) return null;
        MoneyToken amount = tokens.get(tokens.size() - 1);
        if (amount.isZero()) return null;

        String description = TRAILING_CURRENCY.matcher(line.textBefore(tokens.get(0))).replaceFirst("");
        description = blankToNull(description);
        if (description == null || SUMMARY.matcher(description).find()) return null;

        return RawTransaction.builder()
                .date(line.date())
                .description(description)
                .amount(amount.value().abs())
                .type(resolveType(amount, description))
                .build();
    }

    private static String resolveType(MoneyToken amount, String description) {
        if (amount.marker() == Marker.CR) return "CREDIT";
        if (amount.marker() == Marker.DR) return "DEBIT";
        if (amount.value().signum() < 0 || amount.isPlus()) return "CREDIT";
        if (CREDIT_KEYWORDS.matcher(description).find()) return "CREDIT";
        return "DEBIT";
    }
}
