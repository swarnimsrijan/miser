package com.miser.moneyTracker.bank.controller;

import com.miser.moneyTracker.bank.entity.Bank;
import com.miser.moneyTracker.bank.repository.BankRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/banks")
@RequiredArgsConstructor
public class BankController {

    private final BankRepository bankRepository;

    @GetMapping
    public List<Bank> getAll() {
        return bankRepository.findAll();
    }
}
