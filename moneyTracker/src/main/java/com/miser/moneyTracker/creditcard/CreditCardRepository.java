package com.miser.moneyTracker.creditcard;

import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface CreditCardRepository extends JpaRepository<CreditCard, Long> {
    List<CreditCard> findByUserId(Long userId);

    /** Owner-scoped lookup with the bank loaded, for use outside a transaction. */
    @EntityGraph(attributePaths = "bank")
    Optional<CreditCard> findWithBankByIdAndUserId(Long id, Long userId);
}
