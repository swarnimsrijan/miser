package com.miser.moneyTracker.parser;

/**
 * The PDF is encrypted and the supplied password was missing or wrong.
 * Distinct from other parse failures so clients can prompt for a password.
 */
public class StatementPasswordException extends StatementParseException {

    public enum Reason { PASSWORD_REQUIRED, PASSWORD_INCORRECT }

    private final Reason reason;

    public StatementPasswordException(Reason reason) {
        super(reason == Reason.PASSWORD_REQUIRED
                ? "Statement PDF is password protected - provide the password"
                : "Incorrect password for statement PDF");
        this.reason = reason;
    }

    public Reason getReason() { return reason; }
}
