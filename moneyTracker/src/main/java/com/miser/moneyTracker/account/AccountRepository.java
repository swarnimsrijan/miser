package com.miser.moneyTracker.account;

import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface AccountRepository extends JpaRepository<Account, Long> {
    List<Account> findByUserId(Long userId);

    /** Owner-scoped lookup with the bank loaded, for use outside a transaction. */
    @EntityGraph(attributePaths = "bank")
    Optional<Account> findWithBankByIdAndUserId(Long id, Long userId);
}
