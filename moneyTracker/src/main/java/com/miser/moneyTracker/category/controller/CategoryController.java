package com.miser.moneyTracker.category.controller;

import com.miser.moneyTracker.category.entity.Category;
import com.miser.moneyTracker.category.entity.SubCategory;
import com.miser.moneyTracker.category.repository.CategoryRepository;
import com.miser.moneyTracker.category.repository.SubCategoryRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/categories")
@RequiredArgsConstructor
public class CategoryController {

    private final CategoryRepository categoryRepository;
    private final SubCategoryRepository subCategoryRepository;

    @GetMapping
    public List<Category> getAll() {
        return categoryRepository.findAll();
    }

    @GetMapping("/{id}/subcategories")
    public List<SubCategory> getSubCategories(@PathVariable Long id) {
        return subCategoryRepository.findByCategoryId(id);
    }
}
