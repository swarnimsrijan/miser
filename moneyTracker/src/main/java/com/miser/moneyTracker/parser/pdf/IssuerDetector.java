package com.miser.moneyTracker.parser.pdf;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Optional;
import java.util.regex.Pattern;

/**
 * Identifies the issuing bank from the statement header. Only the first lines
 * are scanned: narrations routinely mention other banks ("NEFT FROM HDFC BANK"),
 * so scanning the whole document would misattribute statements.
 */
public final class IssuerDetector {

    private IssuerDetector() {}

    private static final int HEADER_LINES = 40;

    // Codes match bank names seeded in the banks table, upper-cased.
    private static final Map<String, Pattern> ISSUERS = new LinkedHashMap<>();
    static {
        add("HDFC", "\\bHDFC\\s+BANK\\b");
        add("ICICI", "\\bICICI\\s+BANK\\b");
        add("AXIS", "\\bAXIS\\s+BANK\\b");
        add("SBI", "\\bSTATE\\s+BANK\\s+OF\\s+INDIA\\b|\\bSBI\\s*CARDS?\\b");
        add("KOTAK", "\\bKOTAK\\s+MAHINDRA\\b|\\bKOTAK\\s+BANK\\b");
        add("IDFC", "\\bIDFC\\s+FIRST\\b");
        add("YES", "\\bYES\\s+BANK\\b");
        add("INDUSIND", "\\bINDUSIND\\b");
        add("AMEX", "\\bAMERICAN\\s+EXPRESS\\b");
        add("AU", "\\bAU\\s+SMALL\\s+FINANCE\\b");
        add("RBL", "\\bRBL\\s+BANK\\b");
        add("FEDERAL", "\\bFEDERAL\\s+BANK\\b");
        add("BOB", "\\bBANK\\s+OF\\s+BARODA\\b|\\bBOBCARD\\b");
        add("PNB", "\\bPUNJAB\\s+NATIONAL\\s+BANK\\b");
        add("CANARA", "\\bCANARA\\s+BANK\\b");
        add("UNION", "\\bUNION\\s+BANK\\s+OF\\s+INDIA\\b");
        add("SCB", "\\bSTANDARD\\s+CHARTERED\\b");
        add("HSBC", "\\bHSBC\\b");
    }

    private static void add(String code, String regex) {
        ISSUERS.put(code, Pattern.compile(regex, Pattern.CASE_INSENSITIVE));
    }

    /** @return the issuer mentioned most often in the header, if any. */
    public static Optional<String> detect(List<String> lines) {
        String header = String.join("\n", lines.subList(0, Math.min(lines.size(), HEADER_LINES)));
        String best = null;
        long bestCount = 0;
        for (Map.Entry<String, Pattern> entry : ISSUERS.entrySet()) {
            long count = entry.getValue().matcher(header).results().count();
            if (count > bestCount) {
                best = entry.getKey();
                bestCount = count;
            }
        }
        return Optional.ofNullable(best);
    }

    /** Maps a bank name like "HDFC" or "Kotak" onto an issuer code, or null. */
    public static String fromHint(String bankName) {
        if (bankName == null || bankName.isBlank()) return null;
        String normalized = bankName.toUpperCase(Locale.ENGLISH).replaceAll("[^A-Z]", "");
        if (ISSUERS.containsKey(normalized)) return normalized;
        for (Map.Entry<String, Pattern> entry : ISSUERS.entrySet()) {
            if (entry.getValue().matcher(bankName).find()) return entry.getKey();
        }
        return normalized.isEmpty() ? null : normalized;
    }
}
