package com.miser.moneyTracker.transaction;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;

@RestController
@RequestMapping("/api/transactions")
@RequiredArgsConstructor
public class TransactionController {

    private final TransactionService transactionService;

    @GetMapping
    public Page<TransactionResponse> search(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate from,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate to,
            @RequestParam(required = false) Long accountId,
            @RequestParam(required = false) Long creditCardId,
            @RequestParam(required = false) Long categoryId,
            @RequestParam(required = false) TransactionType type,
            @RequestParam(required = false) String q,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "50") int size) {
        return transactionService.search(from, to, accountId, creditCardId, categoryId, type, q, page, size);
    }

    /** Manually mark/unmark a transaction as a transfer between own accounts. */
    @PatchMapping("/{id}/transfer")
    public TransactionResponse updateTransfer(@PathVariable Long id,
                                              @RequestBody java.util.Map<String, Boolean> body) {
        Boolean transfer = body.get("transfer");
        if (transfer == null) throw new IllegalArgumentException("transfer is required");
        return transactionService.updateTransfer(id, transfer);
    }

    @PatchMapping("/{id}/category")
    public TransactionResponse updateCategory(@PathVariable Long id,
                                              @Valid @RequestBody UpdateTransactionCategoryRequest request) {
        return transactionService.updateCategory(id, request);
    }
}
