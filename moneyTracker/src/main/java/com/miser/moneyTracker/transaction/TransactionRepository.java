package com.miser.moneyTracker.transaction;

import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

public interface TransactionRepository
        extends JpaRepository<Transaction, Long>, JpaSpecificationExecutor<Transaction> {

    List<Transaction> findByUserId(Long userId);
    List<Transaction> findByUserIdAndTransactionDateBetween(Long userId, LocalDate from, LocalDate to);
    long countByStatementId(Long statementId);
    List<Transaction> findByStatementId(Long statementId);
    Optional<Transaction> findByIdAndUserId(Long id, Long userId);

    @Query("""
            select coalesce(sum(t.amount), 0) from Transaction t
            where t.user.id = :userId and t.transactionType = :type and t.transfer = false
              and t.transactionDate between :from and :to
            """)
    BigDecimal sumByType(@Param("userId") Long userId, @Param("type") TransactionType type,
                         @Param("from") LocalDate from, @Param("to") LocalDate to);

    @Query("""
            select year(t.transactionDate), month(t.transactionDate), t.transactionType, sum(t.amount)
            from Transaction t
            where t.user.id = :userId and t.transfer = false
              and t.transactionDate between :from and :to
            group by year(t.transactionDate), month(t.transactionDate), t.transactionType
            order by year(t.transactionDate), month(t.transactionDate)
            """)
    List<Object[]> monthlyTotals(@Param("userId") Long userId,
                                 @Param("from") LocalDate from, @Param("to") LocalDate to);

    @Query("""
            select coalesce(c.name, 'Uncategorized'), sum(t.amount), count(t)
            from Transaction t left join t.category c
            where t.user.id = :userId and t.transactionType = :type and t.transfer = false
              and t.transactionDate between :from and :to
            group by c.name
            order by sum(t.amount) desc
            """)
    List<Object[]> totalsByCategory(@Param("userId") Long userId, @Param("type") TransactionType type,
                                    @Param("from") LocalDate from, @Param("to") LocalDate to);

    @Query("""
            select m.name, sum(t.amount), count(t)
            from Transaction t join t.merchant m
            where t.user.id = :userId and t.transactionType = :type and t.transfer = false
              and t.transactionDate between :from and :to
            group by m.name
            order by sum(t.amount) desc
            """)
    List<Object[]> totalsByMerchant(@Param("userId") Long userId, @Param("type") TransactionType type,
                                    @Param("from") LocalDate from, @Param("to") LocalDate to,
                                    Pageable pageable);

    /** Latest known running balance per bank account, summed. */
    @Query(value = """
            select coalesce(sum(latest.balance), 0) from (
                select distinct on (account_id) balance
                from transactions
                where user_id = :userId and account_id is not null and balance is not null
                order by account_id, transaction_date desc, id desc
            ) latest
            """, nativeQuery = true)
    BigDecimal latestBalancesTotal(@Param("userId") Long userId);

    /** Net credit card spend (debits minus payments/refunds) across all cards. */
    @Query("""
            select coalesce(sum(case when t.transactionType = com.miser.moneyTracker.transaction.TransactionType.DEBIT
                                     then t.amount else -t.amount end), 0)
            from Transaction t
            where t.user.id = :userId and t.creditCard is not null
            """)
    BigDecimal creditCardOutstanding(@Param("userId") Long userId);
}
