package com.miser.moneyTracker.category.repository;

import com.miser.moneyTracker.category.entity.Category;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CategoryRepository extends JpaRepository<Category, Long> {
}
