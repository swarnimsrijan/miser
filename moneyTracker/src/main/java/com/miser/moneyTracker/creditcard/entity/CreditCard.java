package com.miser.moneyTracker.creditcard.entity;

import com.miser.moneyTracker.bank.entity.Bank;
import com.miser.moneyTracker.user.entity.User;
import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "credit_cards")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CreditCard {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "bank_id", nullable = false)
    private Bank bank;

    @Column(name = "card_name", nullable = false)
    private String cardName;

    @Column(name = "masked_number")
    private String maskedNumber;

    @Column(name = "credit_limit")
    private BigDecimal creditLimit;

    @Column(name = "billing_date")
    private Integer billingDate;

    @Column(name = "due_date")
    private Integer dueDate;

    @Column(nullable = false)
    private String currency;

    @Column(nullable = false)
    private String status;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }
}
