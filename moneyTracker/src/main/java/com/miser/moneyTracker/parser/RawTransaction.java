package com.miser.moneyTracker.parser;

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
    private String type;
    private BigDecimal balance;
    private String reference;
}
