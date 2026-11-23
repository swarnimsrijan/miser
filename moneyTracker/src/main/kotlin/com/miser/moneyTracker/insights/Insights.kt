package com.miser.moneyTracker.insights

import com.miser.moneyTracker.budget.BudgetService
import com.miser.moneyTracker.budget.BudgetState
import com.miser.moneyTracker.common.money
import com.miser.moneyTracker.common.percentOf
import com.miser.moneyTracker.common.sum
import com.miser.moneyTracker.goal.GoalService
import com.miser.moneyTracker.user.CurrentUserService
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController
import java.math.BigDecimal
import java.math.RoundingMode
import java.time.LocalDate
import java.time.temporal.ChronoUnit
import kotlin.math.abs
import kotlin.math.sqrt

enum class Frequency(val days: Double) { WEEKLY(7.0), MONTHLY(30.44), QUARTERLY(91.3), YEARLY(365.25) }

data class RecurringPayment(
    val name: String,
    val category: String?,
    val frequency: Frequency,
    val typicalAmount: BigDecimal,
    val monthlyEquivalent: BigDecimal,
    val occurrences: Int,
    val lastDate: LocalDate,
    val nextExpectedDate: LocalDate,
    /** False when the last charge is overdue by more than half a period (likely cancelled). */
    val active: Boolean,
)

enum class TipSeverity { INFO, WARNING, ALERT }

data class Tip(val type: String, val severity: TipSeverity, val title: String, val message: String,
               val amount: BigDecimal? = null)

/**
 * Detects subscriptions/EMIs/SIPs: the same merchant (or narration) charged at
 * a regular interval with a stable amount.
 */
internal object RecurringDetector {

    private val NOISE = Regex("[^A-Z ]")
    private val STOP_WORDS = setOf("UPI", "POS", "NEFT", "IMPS", "ACH", "ECS", "NACH", "DR", "CR", "TO", "BY",
        "THE", "PVT", "LTD", "INDIA", "PAYMENT", "TXN", "REF", "IN", "AND", "FOR")

    fun key(merchant: String?, description: String?): String? {
        if (!merchant.isNullOrBlank()) return merchant.trim()
        val words = (description ?: return null).uppercase().replace(NOISE, " ")
            .split(" ").filter { it.length > 2 && it !in STOP_WORDS }
        return words.take(3).joinToString(" ").ifBlank { null }
    }

    fun detect(rows: List<SpendingAnalytics.DebitRow>, asOf: LocalDate): List<RecurringPayment> =
        rows.groupBy { key(it.merchant, it.description) }
            .filterKeys { it != null }
            .mapNotNull { (name, charges) -> analyse(name!!, charges.sortedBy { it.date }, asOf) }
            .sortedByDescending { it.monthlyEquivalent }

    private fun analyse(name: String, charges: List<SpendingAnalytics.DebitRow>, asOf: LocalDate): RecurringPayment? {
        // Several charges on one day (split bills) count once.
        val byDay = charges.groupBy { it.date }.map { (_, sameDay) -> sameDay.first().date to sameDay.map { it.amount }.sum() }
        if (byDay.size < 3) return null
        val intervals = byDay.zipWithNext { a, b -> ChronoUnit.DAYS.between(a.first, b.first).toDouble() }
        val median = intervals.sorted()[intervals.size / 2]
        val frequency = Frequency.entries.firstOrNull { abs(median - it.days) <= it.days * 0.2 } ?: return null
        if (coefficientOfVariation(intervals) > 0.35) return null

        val amounts = byDay.map { it.second.toDouble() }
        if (coefficientOfVariation(amounts) > 0.25) return null
        val typical = BigDecimal.valueOf(amounts.sorted()[amounts.size / 2]).money()

        val last = byDay.last().first
        val next = last.plusDays(frequency.days.toLong())
        val active = ChronoUnit.DAYS.between(next, asOf) <= frequency.days / 2
        return RecurringPayment(
            name = name,
            category = charges.last().category,
            frequency = frequency,
            typicalAmount = typical,
            monthlyEquivalent = typical.multiply(BigDecimal.valueOf(Frequency.MONTHLY.days / frequency.days)).money(),
            occurrences = byDay.size,
            lastDate = last,
            nextExpectedDate = next,
            active = active,
        )
    }

    private fun coefficientOfVariation(values: List<Double>): Double {
        val mean = values.average()
        if (mean == 0.0) return 0.0
        val variance = values.sumOf { (it - mean) * (it - mean) } / values.size
        return sqrt(variance) / mean
    }
}

@Service
class InsightService(
    private val analytics: SpendingAnalytics,
    private val budgets: BudgetService,
    private val goals: GoalService,
    private val currentUser: CurrentUserService,
) {

    @Transactional(readOnly = true)
    fun recurring(): List<RecurringPayment> = recurring(currentUser.getCurrentUserId())

    fun recurring(userId: Long): List<RecurringPayment> {
        val anchor = analytics.anchorMonth(userId)
        val asOf = anchor.atEndOfMonth()
        return RecurringDetector.detect(analytics.debits(userId, anchor.minusMonths(11).atDay(1), asOf), asOf)
    }

    @Transactional(readOnly = true)
    fun tips(): List<Tip> {
        val userId = currentUser.getCurrentUserId()
        val anchor = analytics.anchorMonth(userId)
        val tips = mutableListOf<Tip>()

        budgets.status(userId, anchor, LocalDate.now()).forEach { b ->
            when (b.status) {
                BudgetState.EXCEEDED -> tips += Tip("BUDGET", TipSeverity.ALERT, "${b.category} budget exceeded",
                    "You spent ${b.spent} against a cap of ${b.monthlyLimit} in ${b.month}.", b.spent - b.monthlyLimit)
                BudgetState.WARNING -> tips += Tip("BUDGET", TipSeverity.WARNING, "${b.category} budget at ${b.percentUsed}%",
                    "At this pace you'll spend about ${b.projectedSpend} this month (cap ${b.monthlyLimit}).", b.projectedSpend)
                BudgetState.ON_TRACK -> {}
            }
        }

        // Category spikes: latest month vs the average of the three before it.
        val latest = analytics.categorySpend(userId, anchor.atDay(1), anchor.atEndOfMonth())
        val prior = analytics.categorySpend(userId, anchor.minusMonths(3).atDay(1), anchor.minusMonths(1).atEndOfMonth())
            .associate { it.category to it.amount.divide(BigDecimal.valueOf(3), 2, RoundingMode.HALF_UP) }
        latest.forEach { c ->
            val before = prior[c.category] ?: return@forEach
            val increase = c.amount - before
            if (before.signum() > 0 && increase > BigDecimal.valueOf(500) && increase.percentOf(before) >= BigDecimal.valueOf(25)) {
                tips += Tip("SPIKE", TipSeverity.WARNING, "${c.category} up ${increase.percentOf(before)}%",
                    "${c.category} was ${c.amount.money()} in $anchor vs a ${before} monthly average before.", increase.money())
            }
        }

        val subscriptions = recurring(userId).filter { it.active }
        if (subscriptions.isNotEmpty()) {
            val total = subscriptions.map { it.monthlyEquivalent }.sum().money()
            tips += Tip("RECURRING", TipSeverity.INFO, "${subscriptions.size} recurring payments",
                "They cost about $total a month. Cancel any you no longer use.", total)
        }

        val baseline = analytics.baseline(userId)
        if (baseline.avgIncome.signum() > 0) {
            val rate = baseline.avgSavings.percentOf(baseline.avgIncome)
            if (rate < BigDecimal.valueOf(20)) {
                val gap = baseline.avgIncome.multiply(BigDecimal("0.20")).subtract(baseline.avgSavings).money()
                tips += Tip("SAVINGS_RATE", if (rate.signum() < 0) TipSeverity.ALERT else TipSeverity.WARNING,
                    "Savings rate $rate%", "Saving 20% of income would mean setting aside $gap more each month.", gap)
            }
        }

        goals.describe(goals.rows(userId), baseline.avgSavings, LocalDate.now())
            .filter { it.onTrack == false }
            .forEach { g ->
                tips += Tip("GOAL", TipSeverity.WARNING, "${g.name} is off track",
                    "Save ${g.requiredMonthly} a month to reach it by ${g.targetDate}.", g.requiredMonthly)
            }
        return tips.sortedBy { it.severity.ordinal * -1 }
    }
}

@RestController
@RequestMapping("/api/insights")
class InsightController(private val insights: InsightService) {

    /** Subscriptions, EMIs and other regular payments detected from the last 12 months. */
    @GetMapping("/recurring")
    fun recurring() = insights.recurring()

    /** Actionable savings tips: budget alerts, spending spikes, subscriptions, savings rate, goals. */
    @GetMapping("/tips")
    fun tips() = insights.tips()
}
