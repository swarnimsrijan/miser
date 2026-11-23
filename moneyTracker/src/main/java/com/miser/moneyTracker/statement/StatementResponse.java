package com.miser.moneyTracker.statement;

import java.time.LocalDate;
import java.time.LocalDateTime;

public record StatementResponse(
        Long id,
        StatementType statementType,
        String status,
        Long accountId,
        Long creditCardId,
        LocalDate fromDate,
        LocalDate toDate,
        LocalDateTime uploadedAt,
        String issuer,
        String parserLayout,
        long transactionCount) {

    public static StatementResponse from(Statement statement, long transactionCount) {
        return new StatementResponse(
                statement.getId(),
                statement.getStatementType(),
                statement.getStatus(),
                statement.getAccount() == null ? null : statement.getAccount().getId(),
                statement.getCreditCard() == null ? null : statement.getCreditCard().getId(),
                statement.getFromDate(),
                statement.getToDate(),
                statement.getUploadedAt(),
                statement.getIssuer(),
                statement.getParserLayout(),
                transactionCount);
    }
}
