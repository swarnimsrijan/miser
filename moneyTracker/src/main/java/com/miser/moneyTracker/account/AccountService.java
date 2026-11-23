package com.miser.moneyTracker.account;

import com.miser.moneyTracker.bank.BankRepository;
import com.miser.moneyTracker.common.exception.ResourceNotFoundException;
import com.miser.moneyTracker.user.CurrentUserService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class AccountService {

    private final AccountRepository accountRepository;
    private final BankRepository bankRepository;
    private final CurrentUserService currentUserService;

    @Transactional
    public AccountResponse create(CreateAccountRequest request) {
        var bank = bankRepository.findById(request.getBankId())
                .orElseThrow(() -> new ResourceNotFoundException("Bank not found"));
        Account account = Account.builder()
                .user(currentUserService.getCurrentUser())
                .bank(bank)
                .nickname(request.getNickname())
                .accountNumberMasked(request.getAccountNumberMasked())
                .accountType(request.getAccountType())
                .currency(request.getCurrency())
                .status("ACTIVE")
                .build();
        return AccountResponse.from(accountRepository.save(account));
    }

    @Transactional(readOnly = true)
    public List<AccountResponse> getAllForCurrentUser() {
        return accountRepository.findByUserId(currentUserService.getCurrentUserId()).stream()
                .map(AccountResponse::from)
                .toList();
    }
}
