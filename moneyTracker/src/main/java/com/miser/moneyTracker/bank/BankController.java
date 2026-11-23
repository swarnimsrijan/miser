package com.miser.moneyTracker.bank;

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
