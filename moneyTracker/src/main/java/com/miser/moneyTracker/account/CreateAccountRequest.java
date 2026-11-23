package com.miser.moneyTracker.account;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class CreateAccountRequest {
    @NotNull private Long bankId;
    private String nickname;
    private String accountNumberMasked;
    @NotNull private AccountType accountType;
    @NotBlank private String currency;
}
