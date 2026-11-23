package com.miser.moneyTracker.creditcard;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public record CreditCardResponse(
        Long id,
        Long bankId,
        String bankName,
        String cardName,
        String maskedNumber,
        BigDecimal creditLimit,
        Integer billingDate,
        Integer dueDate,
        String currency,
        String status,
        LocalDateTime createdAt) {

    public static CreditCardResponse from(CreditCard card) {
        return new CreditCardResponse(
                card.getId(),
                card.getBank().getId(),
                card.getBank().getName(),
                card.getCardName(),
                card.getMaskedNumber(),
                card.getCreditLimit(),
                card.getBillingDate(),
                card.getDueDate(),
                card.getCurrency(),
                card.getStatus(),
                card.getCreatedAt());
    }
}
