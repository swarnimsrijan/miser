package com.miser.moneyTracker.transaction;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class UpdateTransactionCategoryRequest {
    @NotNull private Long categoryId;
    private Long subCategoryId;
}
