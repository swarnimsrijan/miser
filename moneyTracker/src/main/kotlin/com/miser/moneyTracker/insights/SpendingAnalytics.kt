package com.miser.moneyTracker.insights

import com.miser.moneyTracker.common.money
import com.miser.moneyTracker.common.sum
import org.springframework.jdbc.core.simple.JdbcClient
import org.springframework.stereotype.Component
import java.math.BigDecimal
import java.math.RoundingMode
import java.time.LocalDate
import java.time.YearMonth

data class MonthFlow(val month: YearMonth, val income: BigDecimal, val expense: BigDecimal) {
    val savings: BigDecimal get() = income - expense
}

data class CategorySpend(val categoryId: Long?, val category: String, val amount: BigDecimal)

/** Baseline monthly averages computed from recent history. */
data class Baseline(
    val months: List<YearMonth>,
    val avgIncome: BigDecimal,
    val avgExpense: BigDecimal,
    val categories: List<CategorySpend>,
) {
    val avgSavings: BigDecimal get() = avgIncome - avgExpense
}

/**
 * Read-side aggregates over transactions. Transfers between own accounts are
 * always excluded; category spend is net of refunds in the same category.
 */
@Component
class SpendingAnalytics(private val jdbc: JdbcClient) {

    /** Month of the most recent transaction, or the current month if none. */
    fun anchorMonth(userId: Long): YearMonth =
        jdbc.sql("select max(transaction_date) from transactions where user_id = :u")
            .param("u", userId).query(LocalDate::class.java).optional()
            .map(YearMonth::from).orElse(YearMonth.now())

    fun monthlyFlows(userId: Long, from: YearMonth, to: YearMonth): List<MonthFlow> {
        val rows = jdbc.sql(
            """
            select date_trunc('month', transaction_date)::date as m,
                   coalesce(sum(case when transaction_type = 'CREDIT' then amount end), 0) as income,
                   coalesce(sum(case when transaction_type = 'DEBIT' then amount end), 0) as expense
            from transactions
            where user_id = :u and not is_transfer and transaction_date between :from and :to
            group by 1 order by 1
            """
        ).param("u", userId).param("from", from.atDay(1)).param("to", to.atEndOfMonth())
            .query { rs, _ ->
                MonthFlow(YearMonth.from(rs.getObject("m", LocalDate::class.java)),
                    rs.getBigDecimal("income"), rs.getBigDecimal("expense"))
            }.list()
        return rows
    }

    /** Net spend per category (debits minus same-category refunds) in [from, to]. */
    fun categorySpend(userId: Long, from: LocalDate, to: LocalDate): List<CategorySpend> =
        jdbc.sql(
            """
            select t.category_id, coalesce(c.name, 'Uncategorized') as name,
                   sum(case when t.transaction_type = 'DEBIT' then t.amount else -t.amount end) as net
            from transactions t left join categories c on c.id = t.category_id
            where t.user_id = :u and not t.is_transfer and t.transaction_date between :from and :to
            group by t.category_id, c.name
            -- income categories net negative and drop out here
            having sum(case when t.transaction_type = 'DEBIT' then t.amount else -t.amount end) > 0
            order by net desc
            """
        ).param("u", userId).param("from", from).param("to", to)
            .query { rs, _ ->
                CategorySpend(rs.getObject("category_id", java.lang.Long::class.java)?.toLong(),
                    rs.getString("name"), rs.getBigDecimal("net"))
            }.list()

    /**
     * Averages over the last [months] months that have data, ending at the
     * most recent statement month.
     */
    fun baseline(userId: Long, months: Int = 3): Baseline {
        val anchor = anchorMonth(userId)
        val flows = monthlyFlows(userId, anchor.minusMonths(months.toLong() - 1), anchor)
        if (flows.isEmpty()) return Baseline(emptyList(), BigDecimal.ZERO, BigDecimal.ZERO, emptyList())
        val n = BigDecimal.valueOf(flows.size.toLong())
        val categories = categorySpend(userId, flows.first().month.atDay(1), flows.last().month.atEndOfMonth())
            .map { it.copy(amount = it.amount.divide(n, 2, RoundingMode.HALF_UP)) }
        return Baseline(
            months = flows.map { it.month },
            avgIncome = flows.map { it.income }.sum().divide(n, 2, RoundingMode.HALF_UP),
            avgExpense = flows.map { it.expense }.sum().divide(n, 2, RoundingMode.HALF_UP),
            categories = categories,
        )
    }

    data class DebitRow(
        val date: LocalDate, val amount: BigDecimal, val description: String?,
        val merchant: String?, val category: String?,
    )

    fun debits(userId: Long, from: LocalDate, to: LocalDate): List<DebitRow> =
        jdbc.sql(
            """
            select t.transaction_date, t.amount, t.description, m.name as merchant, c.name as category
            from transactions t
            left join merchants m on m.id = t.merchant_id
            left join categories c on c.id = t.category_id
            where t.user_id = :u and t.transaction_type = 'DEBIT' and not t.is_transfer
              and t.transaction_date between :from and :to
            order by t.transaction_date
            """
        ).param("u", userId).param("from", from).param("to", to)
            .query { rs, _ ->
                DebitRow(rs.getObject("transaction_date", LocalDate::class.java), rs.getBigDecimal("amount").money(),
                    rs.getString("description"), rs.getString("merchant"), rs.getString("category"))
            }.list()
}
