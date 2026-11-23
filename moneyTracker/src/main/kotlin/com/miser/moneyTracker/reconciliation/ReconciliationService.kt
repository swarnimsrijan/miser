package com.miser.moneyTracker.reconciliation

import com.miser.moneyTracker.user.CurrentUserService
import org.springframework.jdbc.core.simple.JdbcClient
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController
import java.math.BigDecimal
import java.time.LocalDate
import java.time.temporal.ChronoUnit
import kotlin.math.abs

/**
 * Finds money moving between the user's own accounts and cards and marks both
 * legs as transfers:
 *  - bank debit  <-> credit-card credit (paying the card bill), within 7 days
 *  - bank debit  <-> credit on a different own bank account, within 3 days
 * Amounts must match exactly; each transaction is used at most once and the
 * closest date wins.
 */
@Service
class ReconciliationService(private val jdbc: JdbcClient) {

    private data class Leg(
        val id: Long, val date: LocalDate, val amount: BigDecimal, val debit: Boolean,
        val accountId: Long?, val cardId: Long?,
    )

    @Transactional
    fun reconcile(userId: Long): Int {
        val legs = jdbc.sql(
            """
            select id, transaction_date, amount, transaction_type, account_id, credit_card_id
            from transactions where user_id = :userId and not is_transfer
            order by transaction_date, id
            """
        ).param("userId", userId).query { rs, _ ->
            Leg(
                id = rs.getLong("id"),
                date = rs.getObject("transaction_date", LocalDate::class.java),
                amount = rs.getBigDecimal("amount"),
                debit = rs.getString("transaction_type") == "DEBIT",
                accountId = rs.getObject("account_id", java.lang.Long::class.java)?.toLong(),
                cardId = rs.getObject("credit_card_id", java.lang.Long::class.java)?.toLong(),
            )
        }.list()

        val creditsByAmount = legs.filter { !it.debit }.groupBy { it.amount.stripTrailingZeros() }
        val used = HashSet<Long>()
        var pairs = 0
        for (debit in legs.filter { it.debit && it.accountId != null }) {
            val match = creditsByAmount[debit.amount.stripTrailingZeros()].orEmpty()
                .filter { it.id !in used && isCounterpart(debit, it) }
                .minByOrNull { abs(ChronoUnit.DAYS.between(debit.date, it.date)) }
                ?: continue
            used += debit.id
            used += match.id
            link(debit.id, match.id)
            link(match.id, debit.id)
            pairs++
        }
        return pairs
    }

    private fun isCounterpart(debit: Leg, credit: Leg): Boolean {
        val days = abs(ChronoUnit.DAYS.between(debit.date, credit.date))
        return when {
            credit.cardId != null -> days <= 7
            credit.accountId != null && credit.accountId != debit.accountId -> days <= 3
            else -> false
        }
    }

    private fun link(id: Long, pairId: Long) {
        jdbc.sql("update transactions set is_transfer = true, transfer_pair_id = :pair where id = :id")
            .param("pair", pairId).param("id", id).update()
    }
}

data class ReconciliationResult(val linkedPairs: Int)

@RestController
@RequestMapping("/api/reconciliation")
class ReconciliationController(
    private val reconciliationService: ReconciliationService,
    private val currentUserService: CurrentUserService,
) {
    /** Re-runs transfer detection over all of the user's transactions. */
    @PostMapping("/run")
    fun run() = ReconciliationResult(reconciliationService.reconcile(currentUserService.getCurrentUserId()))
}
