package com.miser.moneyTracker.creditcard.controller;

import com.miser.moneyTracker.creditcard.dto.CreateCreditCardRequest;
import com.miser.moneyTracker.creditcard.entity.CreditCard;
import com.miser.moneyTracker.creditcard.service.CreditCardService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/credit-cards")
@RequiredArgsConstructor
public class CreditCardController {

    private final CreditCardService creditCardService;

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public CreditCard create(@Valid @RequestBody CreateCreditCardRequest request) {
        return creditCardService.create(request);
    }

    @GetMapping
    public List<CreditCard> getAll() {
        return creditCardService.getAllForCurrentUser();
    }
}
