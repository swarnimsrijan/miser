package com.miser.moneyTracker.planner

import com.miser.moneyTracker.common.HUNDRED
import com.miser.moneyTracker.common.money
import com.miser.moneyTracker.common.sum
import com.miser.moneyTracker.goal.GoalProjection
import com.miser.moneyTracker.goal.GoalService
import com.miser.moneyTracker.insights.Baseline
import com.miser.moneyTracker.insights.SpendingAnalytics
import com.miser.moneyTracker.user.CurrentUserService
import jakarta.validation.Valid
import jakarta.validation.constraints.DecimalMin
import jakarta.validation.constraints.Max
import jakarta.validation.constraints.Min
import jakarta.validation.constraints.Size
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import org.springframework.web.bind.annotation.*
import java.math.BigDecimal
import java.time.LocalDate
import java.time.YearMonth

data class CategoryChange(
    val categoryId: Long?,
    /** e.g. -30 to cut a category by 30%. */
    @field:DecimalMin("-100") val changePercent: BigDecimal,
)

data class OneOff(
    val month: YearMonth,
    /** Positive = extra expense (e.g. a trip), negative = extra income (e.g. a bonus). */
    val amount: BigDecimal,
    @field:Size(max = 100) val label: String? = null,
)

data class WhatIfRequest(
    @field:Min(1) @field:Max(60) val months: Int = 12,
    @field:DecimalMin("-100") val incomeChangePercent: BigDecimal = BigDecimal.ZERO,
    val extraMonthlyIncome: BigDecimal = BigDecimal.ZERO,
    @field:Valid val categoryChanges: List<CategoryChange> = emptyList(),
    @field:Valid val oneOffs: List<OneOff> = emptyList(),
)

data class ProjectedMonth(
    val month: YearMonth, val income: BigDecimal, val expense: BigDecimal,
    val savings: BigDecimal, val cumulativeSavings: BigDecimal,
)

data class CategoryLine(val categoryId: Long?, val category: String, val baselineMonthly: BigDecimal,
                        val scenarioMonthly: BigDecimal)

data class Scenario(
    val monthlyIncome: BigDecimal,
    val monthlyExpense: BigDecimal,
    val monthlySavings: BigDecimal,
    val totalSavings: BigDecimal,
    val months: List<ProjectedMonth>,
)

data class GoalEta(val goalId: Long, val name: String, val targetDate: LocalDate?,
                   val baselineCompletion: YearMonth?, val scenarioCompletion: YearMonth?)

data class WhatIfResponse(
    /** Months of history the averages are based on. */
    val basedOn: List<YearMonth>,
    val baseline: Scenario,
    val scenario: Scenario,
    val monthlySavingsDelta: BigDecimal,
    val categories: List<CategoryLine>,
    val goals: List<GoalEta>,
)

/**
 * Projects cash flow forward from recent averages and applies "what if"
 * adjustments (income change, category cuts, one-off events), then shows how
 * goal completion dates move.
 */
@Service
class PlannerService(
    private val analytics: SpendingAnalytics,
    private val goals: GoalService,
    private val currentUser: CurrentUserService,
) {

    @Transactional(readOnly = true)
    fun whatIf(request: WhatIfRequest): WhatIfResponse {
        val userId = currentUser.getCurrentUserId()
        return simulate(analytics.baseline(userId), goals.rows(userId), request, YearMonth.now())
    }

    internal fun simulate(
        baseline: Baseline,
        goalRows: List<com.miser.moneyTracker.goal.GoalRow>,
        request: WhatIfRequest,
        start: YearMonth,
    ): WhatIfResponse {
        val changes = request.categoryChanges.associate { it.categoryId to it.changePercent }
        val categories = baseline.categories.map { c ->
            val pct = changes[c.categoryId] ?: BigDecimal.ZERO
            CategoryLine(c.categoryId, c.category, c.amount, (c.amount + c.amount * pct / HUNDRED).money())
        }
        val expenseDelta = categories.map { it.scenarioMonthly - it.baselineMonthly }.sum()
        val scenarioIncome = (baseline.avgIncome + baseline.avgIncome * request.incomeChangePercent / HUNDRED +
            request.extraMonthlyIncome).money()
        val scenarioExpense = (baseline.avgExpense + expenseDelta).max(BigDecimal.ZERO).money()

        val months = (0 until request.months).map { start.plusMonths(it.toLong()) }
        val oneOffsByMonth = request.oneOffs.groupBy { it.month }.mapValues { (_, v) -> v.map { it.amount }.sum() }

        val base = project(months, baseline.avgIncome.money(), baseline.avgExpense.money(), emptyMap())
        val scenario = project(months, scenarioIncome, scenarioExpense, oneOffsByMonth)

        val baseEta = GoalProjection.project(goalRows, base.monthlySavings, start)
        // One-offs shift goals too: spread their net effect over the horizon.
        val scenarioEta = GoalProjection.project(goalRows,
            scenario.totalSavings.divide(BigDecimal.valueOf(request.months.toLong()), 2, java.math.RoundingMode.HALF_UP), start)
        val etas = goalRows.filter { it.status == com.miser.moneyTracker.goal.GoalStatus.ACTIVE }.map {
            GoalEta(it.id, it.name, it.targetDate, baseEta[it.id], scenarioEta[it.id])
        }
        return WhatIfResponse(baseline.months, base, scenario,
            (scenario.monthlySavings - base.monthlySavings).money(), categories, etas)
    }

    private fun project(months: List<YearMonth>, income: BigDecimal, expense: BigDecimal,
                        oneOffs: Map<YearMonth, BigDecimal>): Scenario {
        var cumulative = BigDecimal.ZERO
        val projected = months.map { m ->
            val extra = oneOffs[m] ?: BigDecimal.ZERO
            val monthIncome = if (extra.signum() < 0) income - extra else income
            val monthExpense = if (extra.signum() > 0) expense + extra else expense
            val savings = monthIncome - monthExpense
            cumulative += savings
            ProjectedMonth(m, monthIncome.money(), monthExpense.money(), savings.money(), cumulative.money())
        }
        return Scenario(income, expense, (income - expense).money(), cumulative.money(), projected)
    }
}

@RestController
@RequestMapping("/api/planner")
class PlannerController(private val planner: PlannerService) {

    /** Baseline projection from recent averages. */
    @GetMapping("/forecast")
    fun forecast(@RequestParam(defaultValue = "12") months: Int) =
        planner.whatIf(WhatIfRequest(months = months.coerceIn(1, 60)))

    /** Compare a scenario (income change, category cuts, one-offs) against the baseline. */
    @PostMapping("/what-if")
    fun whatIf(@Valid @RequestBody request: WhatIfRequest) = planner.whatIf(request)
}
