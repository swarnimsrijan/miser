package com.miser.moneyTracker.parser;

/**
 * Per-upload inputs for extractors.
 *
 * @param kind        bank account or credit card statement
 * @param issuerHint  bank name of the linked account/card (e.g. "HDFC"), used
 *                    when the issuer cannot be detected from the document
 * @param password    optional PDF password. Used only in memory to open the
 *                    document; never logged or persisted.
 */
public record ExtractionContext(StatementKind kind, String issuerHint, String password) {

    public static ExtractionContext bankAccount() {
        return new ExtractionContext(StatementKind.BANK_ACCOUNT, null, null);
    }

    public static ExtractionContext creditCard() {
        return new ExtractionContext(StatementKind.CREDIT_CARD, null, null);
    }

    public ExtractionContext withPassword(String newPassword) {
        return new ExtractionContext(kind, issuerHint, newPassword);
    }

    // Records print every component by default; keep the password out of logs.
    @Override
    public String toString() {
        return "ExtractionContext[kind=" + kind + ", issuerHint=" + issuerHint
                + ", password=" + (password == null ? "none" : "***") + "]";
    }
}
