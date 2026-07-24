package com.miser.moneyTracker.transaction.controller;

import com.miser.moneyTracker.transaction.entity.Transaction;
import com.miser.moneyTracker.transaction.repository.TransactionRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.*;
import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/api/transactions")
@RequiredArgsConstructor
public class TransactionController {

    private final TransactionRepository transactionRepository;

    @GetMapping
    public List<Transaction> getAll(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate from,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate to) {
        // TODO: filter by current user from security context
        if (from != null && to != null) {
            return transactionRepository.findByUserIdAndTransactionDateBetween(null, from, to);
        }
        return transactionRepository.findAll();
    }
}
