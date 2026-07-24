package com.miser.moneyTracker.creditcard.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import java.math.BigDecimal;

@Data
public class CreateCreditCardRequest {
    @NotNull
    private Long bankId;
    @NotBlank
    private String cardName;
    private String maskedNumber;
    private BigDecimal creditLimit;
    private Integer billingDate;
    private Integer dueDate;
    @NotBlank
    private String currency;
}
