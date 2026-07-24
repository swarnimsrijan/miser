package com.miser.moneyTracker.statement.entity;

import com.miser.moneyTracker.account.entity.Account;
import com.miser.moneyTracker.creditcard.entity.CreditCard;
import com.miser.moneyTracker.user.entity.User;
import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "statements")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Statement {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "account_id")
    private Account account;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "credit_card_id")
    private CreditCard creditCard;

    @Enumerated(EnumType.STRING)
    @Column(name = "statement_type", nullable = false)
    private StatementType statementType;

    @Column(name = "file_url", nullable = false)
    private String fileUrl;

    private String checksum;

    @Column(nullable = false)
    private String status;

    @Column(name = "uploaded_at", nullable = false, updatable = false)
    private LocalDateTime uploadedAt;

    @Column(name = "from_date")
    private LocalDate fromDate;

    @Column(name = "to_date")
    private LocalDate toDate;

    @PrePersist
    protected void onCreate() {
        uploadedAt = LocalDateTime.now();
    }
}
