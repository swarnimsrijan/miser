package com.miser.moneyTracker.dashboard;

import com.miser.moneyTracker.transaction.TransactionRepository;
import com.miser.moneyTracker.transaction.TransactionType;
import com.miser.moneyTracker.user.CurrentUserService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.YearMonth;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class DashboardService {

    private final TransactionRepository transactionRepository;
    private final CurrentUserService currentUserService;

    /** Income, expense, net and savings rate for the period (default: current month). */
    public Map<String, Object> getSummary(LocalDate from, LocalDate to) {
        LocalDate start = from != null ? from : YearMonth.now().atDay(1);
        LocalDate end = to != null ? to : LocalDate.now();
        Long userId = currentUserService.getCurrentUserId();

        BigDecimal income = transactionRepository.sumByType(userId, TransactionType.CREDIT, start, end);
        BigDecimal expense = transactionRepository.sumByType(userId, TransactionType.DEBIT, start, end);
        BigDecimal net = income.subtract(expense);
        BigDecimal savingsRate = income.signum() > 0
                ? net.multiply(BigDecimal.valueOf(100)).divide(income, 1, RoundingMode.HALF_UP)
                : BigDecimal.ZERO;

        Map<String, Object> summary = new LinkedHashMap<>();
        summary.put("from", start);
        summary.put("to", end);
        summary.put("totalIncome", income);
        summary.put("totalExpense", expense);
        summary.put("net", net);
        summary.put("savingsRatePercent", savingsRate);
        return summary;
    }

    /** Spend grouped by category (default: current month). */
    public List<Map<String, Object>> getByCategory(LocalDate from, LocalDate to) {
        LocalDate start = from != null ? from : YearMonth.now().atDay(1);
        LocalDate end = to != null ? to : LocalDate.now();
        Long userId = currentUserService.getCurrentUserId();

        List<Map<String, Object>> result = new ArrayList<>();
        for (Object[] row : transactionRepository.totalsByCategory(
                userId, TransactionType.DEBIT, start, end)) {
            Map<String, Object> entry = new LinkedHashMap<>();
            entry.put("category", row[0]);
            entry.put("totalSpent", row[1]);
            entry.put("transactionCount", row[2]);
            result.add(entry);
        }
        return result;
    }

    /** Income/expense/net per month (default: last 12 months). */
    public List<Map<String, Object>> getMonthly(LocalDate from, LocalDate to) {
        LocalDate end = to != null ? to : LocalDate.now();
        LocalDate start = from != null ? from : YearMonth.from(end).minusMonths(11).atDay(1);
        Long userId = currentUserService.getCurrentUserId();

        Map<YearMonth, BigDecimal[]> byMonth = new LinkedHashMap<>();
        for (Object[] row : transactionRepository.monthlyTotals(userId, start, end)) {
            YearMonth month = YearMonth.of((Integer) row[0], (Integer) row[1]);
            BigDecimal[] flows = byMonth.computeIfAbsent(month,
                    m -> new BigDecimal[]{BigDecimal.ZERO, BigDecimal.ZERO});
            if (row[2] == TransactionType.CREDIT) {
                flows[0] = flows[0].add((BigDecimal) row[3]);
            } else {
                flows[1] = flows[1].add((BigDecimal) row[3]);
            }
        }

        List<Map<String, Object>> result = new ArrayList<>();
        byMonth.forEach((month, flows) -> {
            Map<String, Object> entry = new LinkedHashMap<>();
            entry.put("month", month.toString());
            entry.put("income", flows[0]);
            entry.put("expense", flows[1]);
            entry.put("net", flows[0].subtract(flows[1]));
            result.add(entry);
        });
        return result;
    }

    /** Top merchants by spend (default: current month, top 10). */
    public List<Map<String, Object>> getByMerchant(LocalDate from, LocalDate to, int limit) {
        LocalDate start = from != null ? from : YearMonth.now().atDay(1);
        LocalDate end = to != null ? to : LocalDate.now();
        Long userId = currentUserService.getCurrentUserId();

        List<Map<String, Object>> result = new ArrayList<>();
        for (Object[] row : transactionRepository.totalsByMerchant(
                userId, TransactionType.DEBIT, start, end, PageRequest.of(0, Math.min(limit, 100)))) {
            Map<String, Object> entry = new LinkedHashMap<>();
            entry.put("merchant", row[0]);
            entry.put("totalSpent", row[1]);
            entry.put("transactionCount", row[2]);
            result.add(entry);
        }
        return result;
    }

    /** Bank balances (latest running balance per account) minus credit card outstanding. */
    public Map<String, Object> getNetworth() {
        Long userId = currentUserService.getCurrentUserId();
        BigDecimal bankBalances = transactionRepository.latestBalancesTotal(userId);
        BigDecimal cardOutstanding = transactionRepository.creditCardOutstanding(userId);

        Map<String, Object> networth = new LinkedHashMap<>();
        networth.put("bankBalances", bankBalances);
        networth.put("creditCardOutstanding", cardOutstanding);
        networth.put("networth", bankBalances.subtract(cardOutstanding));
        networth.put("note", "Based on statement running balances and parsed card transactions");
        return networth;
    }

    /** Money in vs out for the period plus the monthly trend. */
    public Map<String, Object> getCashflow(LocalDate from, LocalDate to) {
        Map<String, Object> cashflow = new LinkedHashMap<>(getSummary(from, to));
        cashflow.put("monthly", getMonthly(from, to));
        return cashflow;
    }
}
