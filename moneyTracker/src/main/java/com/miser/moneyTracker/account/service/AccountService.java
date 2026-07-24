package com.miser.moneyTracker.account.service;

import com.miser.moneyTracker.account.dto.CreateAccountRequest;
import com.miser.moneyTracker.account.entity.Account;
import com.miser.moneyTracker.account.repository.AccountRepository;
import com.miser.moneyTracker.bank.repository.BankRepository;
import com.miser.moneyTracker.common.exception.ResourceNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
@RequiredArgsConstructor
public class AccountService {

    private final AccountRepository accountRepository;
    private final BankRepository bankRepository;

    public Account create(CreateAccountRequest request) {
        var bank = bankRepository.findById(request.getBankId())
                .orElseThrow(() -> new ResourceNotFoundException("Bank not found"));
        Account account = Account.builder()
                .bank(bank)
                .nickname(request.getNickname())
                .accountNumberMasked(request.getAccountNumberMasked())
                .accountType(request.getAccountType())
                .currency(request.getCurrency())
                .status("ACTIVE")
                .build();
        return accountRepository.save(account);
    }

    public List<Account> getAllForCurrentUser() {
        // TODO: get user from security context
        return accountRepository.findAll();
    }
}
