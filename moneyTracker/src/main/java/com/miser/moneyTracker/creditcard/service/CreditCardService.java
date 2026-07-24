package com.miser.moneyTracker.creditcard.service;

import com.miser.moneyTracker.bank.repository.BankRepository;
import com.miser.moneyTracker.common.exception.ResourceNotFoundException;
import com.miser.moneyTracker.creditcard.dto.CreateCreditCardRequest;
import com.miser.moneyTracker.creditcard.entity.CreditCard;
import com.miser.moneyTracker.creditcard.repository.CreditCardRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
@RequiredArgsConstructor
public class CreditCardService {

    private final CreditCardRepository creditCardRepository;
    private final BankRepository bankRepository;

    public CreditCard create(CreateCreditCardRequest request) {
        var bank = bankRepository.findById(request.getBankId())
                .orElseThrow(() -> new ResourceNotFoundException("Bank not found"));
        CreditCard card = CreditCard.builder()
                .bank(bank)
                .cardName(request.getCardName())
                .maskedNumber(request.getMaskedNumber())
                .creditLimit(request.getCreditLimit())
                .billingDate(request.getBillingDate())
                .dueDate(request.getDueDate())
                .currency(request.getCurrency())
                .status("ACTIVE")
                .build();
        return creditCardRepository.save(card);
    }

    public List<CreditCard> getAllForCurrentUser() {
        // TODO: get user from security context
        return creditCardRepository.findAll();
    }
}
