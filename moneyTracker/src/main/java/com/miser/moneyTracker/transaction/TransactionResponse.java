package com.miser.moneyTracker.transaction;

import java.math.BigDecimal;
import java.time.LocalDate;

public record TransactionResponse(
        Long id,
        LocalDate transactionDate,
        String description,
        String merchant,
        Long categoryId,
        String category,
        Long subCategoryId,
        String subCategory,
        BigDecimal amount,
        TransactionType transactionType,
        BigDecimal balance,
        String currency,
        String reference,
        Long accountId,
        Long creditCardId,
        boolean transfer) {

    public static TransactionResponse from(Transaction t) {
        return new TransactionResponse(
                t.getId(),
                t.getTransactionDate(),
                t.getDescription(),
                t.getMerchant() == null ? null : t.getMerchant().getName(),
                t.getCategory() == null ? null : t.getCategory().getId(),
                t.getCategory() == null ? null : t.getCategory().getName(),
                t.getSubCategory() == null ? null : t.getSubCategory().getId(),
                t.getSubCategory() == null ? null : t.getSubCategory().getName(),
                t.getAmount(),
                t.getTransactionType(),
                t.getBalance(),
                t.getCurrency(),
                t.getReference(),
                t.getAccount() == null ? null : t.getAccount().getId(),
                t.getCreditCard() == null ? null : t.getCreditCard().getId(),
                t.isTransfer());
    }
}
