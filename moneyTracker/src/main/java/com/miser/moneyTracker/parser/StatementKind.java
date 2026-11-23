package com.miser.moneyTracker.parser;

/**
 * What the statement belongs to. Drives sign conventions: on a bank account a
 * positive unsigned amount with no other signal is ambiguous, while on a
 * credit card it is almost always a charge (money out).
 */
public enum StatementKind {
    BANK_ACCOUNT,
    CREDIT_CARD
}
