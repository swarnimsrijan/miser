package com.miser.moneyTracker.parser.pdf;

import com.miser.moneyTracker.parser.RawTransaction;
import com.miser.moneyTracker.parser.StatementKind;
import com.miser.moneyTracker.parser.pdf.StatementLine.Marker;
import com.miser.moneyTracker.parser.pdf.StatementLine.MoneyToken;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;
import java.util.List;
import java.util.regex.Pattern;

/**
 * Fallback for bank-account PDFs of any issuer. Trailing money tokens are read
 * as [debit] [credit] amount and running balance. Direction is taken, in order,
 * from Dr/Cr markers, an explicit sign, the running-balance delta, which of the
 * debit/credit columns is filled, and finally narration keywords.
 */
@Component
public class GenericBankLayout extends LineLayout {

    private static final Pattern CREDIT_KEYWORDS = Pattern.compile(
            "(?i)\\b(salary|refund|interest\\s+(credit|paid)|cashback|reversal|dividend|int\\.?pd)\\b");

    private static final class State implements ParseState {
        BigDecimal previousBalance;
    }

    @Override
    public String id() { return "generic-bank"; }

    @Override
    public boolean supports(StatementKind kind, String issuer) {
        return kind == StatementKind.BANK_ACCOUNT;
    }

    @Override
    protected ParseState newState() { return new State(); }

    @Override
    protected RawTransaction parseLine(StatementLine line, ParseState parseState) {
        State state = (State) parseState;
        List<MoneyToken> tokens = line.money();
        int n = tokens.size();
        if (n == 0) return null;

        BigDecimal balance = null;
        MoneyToken amountToken;
        MoneyToken firstAmountColumn;
        String columnType = null;
        if (n == 1) {
            amountToken = tokens.get(0);
            firstAmountColumn = amountToken;
        } else {
            balance = balanceValue(tokens.get(n - 1));
            MoneyToken beforeBalance = tokens.get(n - 2);
            amountToken = beforeBalance;
            firstAmountColumn = beforeBalance;
            // "<debit> <credit> <balance>" with the unused column printed as 0.00.
            if (n >= 3) {
                MoneyToken debitColumn = tokens.get(n - 3);
                if (debitColumn.isZero() != beforeBalance.isZero()) {
                    firstAmountColumn = debitColumn;
                    amountToken = debitColumn.isZero() ? beforeBalance : debitColumn;
                    columnType = debitColumn.isZero() ? "CREDIT" : "DEBIT";
                }
            }
        }

        BigDecimal previousBalance = state.previousBalance;
        // Track the balance even for non-transaction rows (e.g. "OPENING BALANCE
        // 0.00 10,000.00") so the first real transaction gets a correct delta.
        if (balance != null) state.previousBalance = balance;
        if (amountToken.isZero()) return null;

        String description = blankToNull(line.textBefore(firstAmountColumn));
        return RawTransaction.builder()
                .date(line.date())
                .description(description)
                .amount(amountToken.value().abs())
                .type(resolveType(amountToken, balance, previousBalance, columnType, description))
                .balance(balance)
                .build();
    }

    private static BigDecimal balanceValue(MoneyToken token) {
        // "1,234.00 Dr" on a balance means overdrawn.
        return token.marker() == Marker.DR ? token.value().abs().negate() : token.value();
    }

    private static String resolveType(MoneyToken amount, BigDecimal balance, BigDecimal previousBalance,
                                      String columnType, String description) {
        if (amount.marker() == Marker.CR) return "CREDIT";
        if (amount.marker() == Marker.DR) return "DEBIT";
        if (amount.value().signum() < 0) return "DEBIT";
        if (amount.isPlus()) return "CREDIT";
        if (balance != null && previousBalance != null && balance.compareTo(previousBalance) != 0) {
            return balance.compareTo(previousBalance) > 0 ? "CREDIT" : "DEBIT";
        }
        if (columnType != null) return columnType;
        if (description != null && CREDIT_KEYWORDS.matcher(description).find()) return "CREDIT";
        return "DEBIT";
    }
}
