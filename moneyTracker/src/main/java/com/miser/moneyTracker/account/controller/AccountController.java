package com.miser.moneyTracker.account.controller;

import com.miser.moneyTracker.account.dto.CreateAccountRequest;
import com.miser.moneyTracker.account.entity.Account;
import com.miser.moneyTracker.account.service.AccountService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/accounts")
@RequiredArgsConstructor
public class AccountController {

    private final AccountService accountService;

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public Account create(@Valid @RequestBody CreateAccountRequest request) {
        return accountService.create(request);
    }

    @GetMapping
    public List<Account> getAll() {
        return accountService.getAllForCurrentUser();
    }
}
