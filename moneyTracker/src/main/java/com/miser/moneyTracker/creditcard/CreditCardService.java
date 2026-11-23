package com.miser.moneyTracker.creditcard;

import com.miser.moneyTracker.bank.BankRepository;
import com.miser.moneyTracker.common.exception.ResourceNotFoundException;
import com.miser.moneyTracker.user.CurrentUserService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class CreditCardService {

    private final CreditCardRepository creditCardRepository;
    private final BankRepository bankRepository;
    private final CurrentUserService currentUserService;

    @Transactional
    public CreditCardResponse create(CreateCreditCardRequest request) {
        var bank = bankRepository.findById(request.getBankId())
                .orElseThrow(() -> new ResourceNotFoundException("Bank not found"));
        CreditCard card = CreditCard.builder()
                .user(currentUserService.getCurrentUser())
                .bank(bank)
                .cardName(request.getCardName())
                .maskedNumber(request.getMaskedNumber())
                .creditLimit(request.getCreditLimit())
                .billingDate(request.getBillingDate())
                .dueDate(request.getDueDate())
                .currency(request.getCurrency())
                .status("ACTIVE")
                .build();
        return CreditCardResponse.from(creditCardRepository.save(card));
    }

    @Transactional(readOnly = true)
    public List<CreditCardResponse> getAllForCurrentUser() {
        return creditCardRepository.findByUserId(currentUserService.getCurrentUserId()).stream()
                .map(CreditCardResponse::from)
                .toList();
    }
}
