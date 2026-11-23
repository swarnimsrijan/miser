package com.miser.moneyTracker.budget

import com.miser.moneyTracker.common.exception.ResourceNotFoundException
import com.miser.moneyTracker.common.money
import com.miser.moneyTracker.common.percentOf
import com.miser.moneyTracker.insights.SpendingAnalytics
import com.miser.moneyTracker.user.CurrentUserService
import jakarta.validation.Valid
import jakarta.validation.constraints.DecimalMin
import jakarta.validation.constraints.Max
import jakarta.validation.constraints.Min
import org.springframework.format.annotation.DateTimeFormat
import org.springframework.http.HttpStatus
import org.springframework.jdbc.core.simple.JdbcClient
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import org.springframework.web.bind.annotation.*
import java.math.BigDecimal
import java.math.RoundingMode
import java.time.LocalDate
import java.time.YearMonth

data class BudgetRequest(
    @field:DecimalMin("0.01") val monthlyLimit: BigDecimal,
    @field:Min(1) @field:Max(100) val alertThresholdPercent: Int = 80,
)

data class BudgetResponse(
    val categoryId: Long,
    val category: String,
    val monthlyLimit: BigDecimal,
    val alertThresholdPercent: Int,
)

enum class BudgetState { ON_TRACK, WARNING, EXCEEDED }

data class BudgetStatus(
    val categoryId: Long,
    val category: String,
    val month: YearMonth,
    val monthlyLimit: BigDecimal,
    val spent: BigDecimal,
    val remaining: BigDecimal,
    val percentUsed: BigDecimal,
    /** Month-end spend at the current pace (equals spent for past months). */
    val projectedSpend: BigDecimal,
    val status: BudgetState,
)

@Service
class BudgetService(
    private val jdbc: JdbcClient,
    private val analytics: SpendingAnalytics,
    private val currentUser: CurrentUserService,
) {

    @Transactional(readOnly = true)
    fun list(): List<BudgetResponse> = list(currentUser.getCurrentUserId())

    fun list(userId: Long): List<BudgetResponse> = jdbc.sql(
        """
        select b.category_id, c.name, b.monthly_limit, b.alert_threshold_percent
        from budgets b join categories c on c.id = b.category_id
        where b.user_id = :u order by c.name
        """
    ).param("u", userId).query { rs, _ ->
        BudgetResponse(rs.getLong(1), rs.getString(2), rs.getBigDecimal(3), rs.getInt(4))
    }.list()

    @Transactional
    fun upsert(categoryId: Long, request: BudgetRequest): BudgetResponse {
        val userId = currentUser.getCurrentUserId()
        val category = jdbc.sql("select name from categories where id = :id").param("id", categoryId)
            .query(String::class.java).optional().orElseThrow { ResourceNotFoundException("Category not found") }
        jdbc.sql(
            """
            insert into budgets (user_id, category_id, monthly_limit, alert_threshold_percent)
            values (:u, :c, :limit, :pct)
            on conflict (user_id, category_id)
            do update set monthly_limit = excluded.monthly_limit,
                          alert_threshold_percent = excluded.alert_threshold_percent
            """
        ).param("u", userId).param("c", categoryId).param("limit", request.monthlyLimit.money())
            .param("pct", request.alertThresholdPercent).update()
        return BudgetResponse(categoryId, category, request.monthlyLimit.money(), request.alertThresholdPercent)
    }

    @Transactional
    fun delete(categoryId: Long) {
        val deleted = jdbc.sql("delete from budgets where user_id = :u and category_id = :c")
            .param("u", currentUser.getCurrentUserId()).param("c", categoryId).update()
        if (deleted == 0) throw ResourceNotFoundException("Budget not found")
    }

    @Transactional(readOnly = true)
    fun status(month: YearMonth?): List<BudgetStatus> {
        val userId = currentUser.getCurrentUserId()
        return status(userId, month ?: analytics.anchorMonth(userId), LocalDate.now())
    }

    fun status(userId: Long, month: YearMonth, today: LocalDate): List<BudgetStatus> {
        val spendByCategory = analytics.categorySpend(userId, month.atDay(1), month.atEndOfMonth())
            .associate { it.categoryId to it.amount }
        val daysInMonth = month.lengthOfMonth()
        val elapsed = when {
            YearMonth.from(today) == month -> today.dayOfMonth
            YearMonth.from(today).isAfter(month) -> daysInMonth
            else -> 0
        }
        return list(userId).map { budget ->
            val spent = (spendByCategory[budget.categoryId] ?: BigDecimal.ZERO).money()
            val projected = if (elapsed in 1 until daysInMonth) {
                spent.multiply(BigDecimal.valueOf(daysInMonth.toLong()))
                    .divide(BigDecimal.valueOf(elapsed.toLong()), 2, RoundingMode.HALF_UP)
            } else spent
            val percent = spent.percentOf(budget.monthlyLimit)
            val state = when {
                spent > budget.monthlyLimit -> BudgetState.EXCEEDED
                percent >= BigDecimal.valueOf(budget.alertThresholdPercent.toLong()) ||
                    projected > budget.monthlyLimit -> BudgetState.WARNING
                else -> BudgetState.ON_TRACK
            }
            BudgetStatus(budget.categoryId, budget.category, month, budget.monthlyLimit, spent,
                (budget.monthlyLimit - spent).money(), percent, projected, state)
        }
    }
}

@RestController
@RequestMapping("/api/budgets")
class BudgetController(private val budgets: BudgetService) {

    @GetMapping
    fun list() = budgets.list()

    /** Create or replace the monthly cap for a category. */
    @PutMapping("/{categoryId}")
    fun upsert(@PathVariable categoryId: Long, @Valid @RequestBody request: BudgetRequest) =
        budgets.upsert(categoryId, request)

    @DeleteMapping("/{categoryId}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    fun delete(@PathVariable categoryId: Long) = budgets.delete(categoryId)

    /** Spend vs cap per budget for a month (yyyy-MM; default: latest statement month). */
    @GetMapping("/status")
    fun status(@RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM") month: YearMonth?) =
        budgets.status(month)
}
