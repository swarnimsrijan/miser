package com.miser.moneyTracker.parser.normalizer;

import lombok.Builder;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;

@Data
@Builder
public class RawTransaction {
    private LocalDate date;
    private String description;
    private BigDecimal amount;
    private String type; // CREDIT or DEBIT
    private BigDecimal balance;
    private String reference;
}
