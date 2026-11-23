package com.miser.moneyTracker.categorization;

import com.miser.moneyTracker.category.Category;
import com.miser.moneyTracker.category.SubCategory;
import com.miser.moneyTracker.merchant.Merchant;

public record CategorizationResult(Merchant merchant, Category category, SubCategory subCategory) {
}
