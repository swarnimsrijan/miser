package com.miser.moneyTracker.parser.pdf;

import com.miser.moneyTracker.parser.ParseUtils;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * A PDF text line that starts with a date, split into the date, the remaining
 * body text and the money tokens found in the body. Shared by all layouts.
 */
public record StatementLine(LocalDate date, String body, List<MoneyToken> money) {

    /** CR/DR printed next to an amount. */
    public enum Marker { CR, DR }

    /**
     * @param value  signed amount (negative for "-", "(..)"; markers do not affect sign)
     * @param signed true when the token carried an explicit "+" or "-"
     */
    public record MoneyToken(String text, BigDecimal value, int start, int end,
                             Marker marker, boolean signed) {
        public boolean isPlus() { return text.startsWith("+"); }
        public boolean isZero() { return value.signum() == 0; }
    }

    private static final String DATE =
            "(?:\\d{1,2}[/.-]\\d{1,2}[/.-]\\d{2,4}"            // 02/04/2025, 2.4.25
            + "|\\d{4}-\\d{2}-\\d{2}"                          // 2025-04-02
            + "|\\d{1,2}[ -][A-Za-z]{3,9}[ ,-]+\\d{2,4})";     // 02 Apr 2025, 02-APR-25
    private static final String TIME =
            "(?:\\s+\\d{1,2}:\\d{2}(?::\\d{2})?(?:\\s*[AaPp][Mm])?)?";

    // Optional second date = value/posting date; optional time = card swipe time.
    private static final Pattern LINE = Pattern.compile(
            "^(" + DATE + ")" + TIME + "(?:\\s+" + DATE + TIME + ")?\\s+(.+)$");

    private static final Pattern MONEY = Pattern.compile(
            "(?<![\\w.,/-])"
            + "([+-]\\s?)?"
            + "(?:(?:₹|Rs\\.?|INR)\\s?)?"
            + "\\(?(?:\\d{1,3}(?:,\\d{2,3})+|\\d+)\\.\\d{2}\\)?"
            + "(?!\\d)"
            + "(?:\\s*((?i:cr|dr))\\b)?");

    /** @return the parsed line, or null if it does not start with a parseable date. */
    public static StatementLine parse(String line) {
        if (line == null) return null;
        Matcher matcher = LINE.matcher(line.trim());
        if (!matcher.matches()) return null;
        LocalDate date = parseDate(matcher.group(1));
        if (date == null) return null;
        String body = matcher.group(2);
        return new StatementLine(date, body, moneyTokens(body));
    }

    public static List<MoneyToken> moneyTokens(String text) {
        List<MoneyToken> tokens = new ArrayList<>();
        Matcher money = MONEY.matcher(text);
        while (money.find()) {
            BigDecimal value = ParseUtils.parseAmount(money.group());
            if (value == null) continue;
            String marker = money.group(2);
            tokens.add(new MoneyToken(money.group().trim(), value, money.start(), money.end(),
                    marker == null ? null : Marker.valueOf(marker.toUpperCase(Locale.ENGLISH)),
                    money.group(1) != null));
        }
        return tokens;
    }

    /** Body text before the given money token, trimmed. */
    public String textBefore(MoneyToken token) {
        return body.substring(0, token.start()).trim();
    }

    private static LocalDate parseDate(String raw) {
        // Textual months: unify separators ("02-APR-2025", "02 Apr, 2025") to spaces.
        String value = raw.matches(".*[A-Za-z].*") ? raw.replaceAll("[\\s,-]+", " ") : raw;
        return ParseUtils.parseDate(value);
    }
}
