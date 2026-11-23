package com.miser.moneyTracker.account;

import java.time.LocalDateTime;

public record AccountResponse(
        Long id,
        Long bankId,
        String bankName,
        String nickname,
        String accountNumberMasked,
        AccountType accountType,
        String currency,
        String status,
        LocalDateTime createdAt) {

    public static AccountResponse from(Account account) {
        return new AccountResponse(
                account.getId(),
                account.getBank().getId(),
                account.getBank().getName(),
                account.getNickname(),
                account.getAccountNumberMasked(),
                account.getAccountType(),
                account.getCurrency(),
                account.getStatus(),
                account.getCreatedAt());
    }
}
