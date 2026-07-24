package com.miser.moneyTracker.transaction.repository;

import com.miser.moneyTracker.transaction.entity.Transaction;
import org.springframework.data.jpa.repository.JpaRepository;
import java.time.LocalDate;
import java.util.List;

public interface TransactionRepository extends JpaRepository<Transaction, Long> {
    List<Transaction> findByUserId(Long userId);
    List<Transaction> findByUserIdAndTransactionDateBetween(Long userId, LocalDate from, LocalDate to);
    List<Transaction> findByUserIdAndAccountId(Long userId, Long accountId);
    List<Transaction> findByUserIdAndCreditCardId(Long userId, Long creditCardId);
    List<Transaction> findByUserIdAndCategoryId(Long userId, Long categoryId);
}
