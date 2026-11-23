package com.miser.moneyTracker.creditcard;

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
    public CreditCardResponse create(@Valid @RequestBody CreateCreditCardRequest request) {
        return creditCardService.create(request);
    }

    @GetMapping
    public List<CreditCardResponse> getAll() {
        return creditCardService.getAllForCurrentUser();
    }
}
