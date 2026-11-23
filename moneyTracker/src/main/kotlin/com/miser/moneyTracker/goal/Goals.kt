package com.miser.moneyTracker.goal

import com.miser.moneyTracker.common.exception.ResourceNotFoundException
import com.miser.moneyTracker.common.money
import com.miser.moneyTracker.common.percentOf
import com.miser.moneyTracker.insights.SpendingAnalytics
import com.miser.moneyTracker.user.CurrentUserService
import jakarta.validation.Valid
import jakarta.validation.constraints.DecimalMin
import jakarta.validation.constraints.Max
import jakarta.validation.constraints.Min
import jakarta.validation.constraints.NotBlank
import jakarta.validation.constraints.Size
import org.springframework.http.HttpStatus
import org.springframework.jdbc.core.simple.JdbcClient
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import org.springframework.web.bind.annotation.*
import java.math.BigDecimal
import java.math.RoundingMode
import java.time.LocalDate
import java.time.YearMonth
import java.time.temporal.ChronoUnit

enum class GoalStatus { ACTIVE, ACHIEVED, PAUSED }

data class CreateGoalRequest(
    @field:NotBlank @field:Size(max = 255) val name: String,
    @field:DecimalMin("0.01") val targetAmount: BigDecimal,
    val targetDate: LocalDate? = null,
    @field:DecimalMin("0") val savedAmount: BigDecimal = BigDecimal.ZERO,
    /** 1 = highest. Savings are allocated to goals in priority order. */
    @field:Min(1) @field:Max(5) val priority: Int = 3,
)

data class UpdateGoalRequest(
    @field:Size(max = 255) val name: String? = null,
    @field:DecimalMin("0.01") val targetAmount: BigDecimal? = null,
    val targetDate: LocalDate? = null,
    @field:Min(1) @field:Max(5) val priority: Int? = null,
    val status: GoalStatus? = null,
)

data class ContributionRequest(
    /** Negative to withdraw. */
    val amount: BigDecimal,
    @field:Size(max = 255) val note: String? = null,
)

data class GoalResponse(
    val id: Long,
    val name: String,
    val targetAmount: BigDecimal,
    val savedAmount: BigDecimal,
    val remaining: BigDecimal,
    val percentComplete: BigDecimal,
    val targetDate: LocalDate?,
    val priority: Int,
    val status: GoalStatus,
    /** Needed per month from now to hit the target date. */
    val requiredMonthly: BigDecimal?,
    /** When the goal completes if average monthly savings go to goals in priority order. */
    val projectedCompletion: YearMonth?,
    val onTrack: Boolean?,
)

internal data class GoalRow(
    val id: Long, val name: String, val target: BigDecimal, val saved: BigDecimal,
    val targetDate: LocalDate?, val priority: Int, val status: GoalStatus,
)

/** Projects goal completion months given a monthly amount available for goals. */
internal object GoalProjection {

    fun project(goals: List<GoalRow>, monthlySavings: BigDecimal, start: YearMonth): Map<Long, YearMonth?> {
        val result = HashMap<Long, YearMonth?>()
        var monthsUsed = BigDecimal.ZERO
        val ordered = goals.filter { it.status == GoalStatus.ACTIVE }
            .sortedWith(compareBy<GoalRow> { it.priority }.thenBy { it.targetDate ?: LocalDate.MAX })
        for (goal in ordered) {
            val remaining = (goal.target - goal.saved).max(BigDecimal.ZERO)
            if (remaining.signum() == 0) { result[goal.id] = start; continue }
            if (monthlySavings.signum() <= 0) { result[goal.id] = null; continue }
            monthsUsed += remaining.divide(monthlySavings, 4, RoundingMode.HALF_UP)
            result[goal.id] = start.plusMonths(monthsUsed.setScale(0, RoundingMode.CEILING).toLong())
        }
        return result
    }
}

@Service
class GoalService(
    private val jdbc: JdbcClient,
    private val analytics: SpendingAnalytics,
    private val currentUser: CurrentUserService,
) {

    @Transactional(readOnly = true)
    fun list(): List<GoalResponse> {
        val userId = currentUser.getCurrentUserId()
        return describe(rows(userId), analytics.baseline(userId).avgSavings, LocalDate.now())
    }

    internal fun rows(userId: Long): List<GoalRow> = jdbc.sql(
        """
        select id, name, target_amount, saved_amount, target_date, priority, status
        from savings_goals where user_id = :u order by priority, created_at
        """
    ).param("u", userId).query { rs, _ ->
        GoalRow(rs.getLong("id"), rs.getString("name"), rs.getBigDecimal("target_amount"),
            rs.getBigDecimal("saved_amount"), rs.getObject("target_date", LocalDate::class.java),
            rs.getInt("priority"), GoalStatus.valueOf(rs.getString("status")))
    }.list()

    internal fun describe(goals: List<GoalRow>, monthlySavings: BigDecimal, today: LocalDate): List<GoalResponse> {
        val start = YearMonth.from(today)
        val projections = GoalProjection.project(goals, monthlySavings, start)
        return goals.map { g ->
            val remaining = (g.target - g.saved).max(BigDecimal.ZERO).money()
            val required = g.targetDate?.takeIf { g.status == GoalStatus.ACTIVE }?.let { date ->
                val months = ChronoUnit.MONTHS.between(start, YearMonth.from(date)).coerceAtLeast(1)
                remaining.divide(BigDecimal.valueOf(months), 2, RoundingMode.HALF_UP)
            }
            val projected = projections[g.id]
            val onTrack = if (g.targetDate == null || g.status != GoalStatus.ACTIVE) null
                else projected != null && !projected.isAfter(YearMonth.from(g.targetDate))
            GoalResponse(g.id, g.name, g.target.money(), g.saved.money(), remaining,
                g.saved.percentOf(g.target), g.targetDate, g.priority, g.status, required, projected, onTrack)
        }
    }

    @Transactional
    fun create(request: CreateGoalRequest): GoalResponse {
        val userId = currentUser.getCurrentUserId()
        val id = jdbc.sql(
            """
            insert into savings_goals (user_id, name, target_amount, saved_amount, target_date, priority)
            values (:u, :name, :target, :saved, :date, :priority) returning id
            """
        ).param("u", userId).param("name", request.name.trim()).param("target", request.targetAmount.money())
            .param("saved", request.savedAmount.money()).param("date", request.targetDate)
            .param("priority", request.priority).query(java.lang.Long::class.java).single().toLong()
        return get(userId, id)
    }

    @Transactional
    fun update(id: Long, request: UpdateGoalRequest): GoalResponse {
        val userId = currentUser.getCurrentUserId()
        val current = rows(userId).find { it.id == id } ?: throw ResourceNotFoundException("Goal not found")
        jdbc.sql(
            """
            update savings_goals set name = :name, target_amount = :target, target_date = :date,
                   priority = :priority, status = :status
            where id = :id and user_id = :u
            """
        ).param("name", request.name?.trim() ?: current.name)
            .param("target", (request.targetAmount ?: current.target).money())
            .param("date", request.targetDate ?: current.targetDate)
            .param("priority", request.priority ?: current.priority)
            .param("status", (request.status ?: current.status).name)
            .param("id", id).param("u", userId).update()
        return get(userId, id)
    }

    @Transactional
    fun contribute(id: Long, request: ContributionRequest): GoalResponse {
        val userId = currentUser.getCurrentUserId()
        val goal = rows(userId).find { it.id == id } ?: throw ResourceNotFoundException("Goal not found")
        require(request.amount.signum() != 0) { "amount must not be zero" }
        val saved = (goal.saved + request.amount).money()
        require(saved.signum() >= 0) { "Withdrawal exceeds saved amount" }
        jdbc.sql("insert into goal_contributions (goal_id, amount, note) values (:g, :a, :n)")
            .param("g", id).param("a", request.amount.money()).param("n", request.note).update()
        val status = when {
            saved >= goal.target -> GoalStatus.ACHIEVED
            goal.status == GoalStatus.ACHIEVED -> GoalStatus.ACTIVE
            else -> goal.status
        }
        jdbc.sql("update savings_goals set saved_amount = :s, status = :st where id = :id")
            .param("s", saved).param("st", status.name).param("id", id).update()
        return get(userId, id)
    }

    @Transactional
    fun delete(id: Long) {
        val deleted = jdbc.sql("delete from savings_goals where id = :id and user_id = :u")
            .param("id", id).param("u", currentUser.getCurrentUserId()).update()
        if (deleted == 0) throw ResourceNotFoundException("Goal not found")
    }

    private fun get(userId: Long, id: Long): GoalResponse =
        describe(rows(userId), analytics.baseline(userId).avgSavings, LocalDate.now()).find { it.id == id }
            ?: throw ResourceNotFoundException("Goal not found")
}

@RestController
@RequestMapping("/api/goals")
class GoalController(private val goals: GoalService) {

    @GetMapping
    fun list() = goals.list()

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    fun create(@Valid @RequestBody request: CreateGoalRequest) = goals.create(request)

    @PatchMapping("/{id}")
    fun update(@PathVariable id: Long, @Valid @RequestBody request: UpdateGoalRequest) = goals.update(id, request)

    @PostMapping("/{id}/contributions")
    fun contribute(@PathVariable id: Long, @Valid @RequestBody request: ContributionRequest) =
        goals.contribute(id, request)

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    fun delete(@PathVariable id: Long) = goals.delete(id)
}
