// Hand-written models for the dashboard endpoints, which the OpenAPI spec
// only describes as untyped maps. Field names follow DashboardService.java.

num _num(Object? v) => switch (v) {
      final num n => n,
      final String s => num.tryParse(s) ?? 0,
      _ => 0,
    };

/// GET /api/dashboard/summary
class DashboardSummary {
  const DashboardSummary({
    required this.from,
    required this.to,
    required this.totalIncome,
    required this.totalExpense,
    required this.net,
    required this.savingsRatePercent,
  });

  factory DashboardSummary.fromJson(Map<String, Object?> json) =>
      DashboardSummary(
        from: DateTime.tryParse('${json['from']}'),
        to: DateTime.tryParse('${json['to']}'),
        totalIncome: _num(json['totalIncome']),
        totalExpense: _num(json['totalExpense']),
        net: _num(json['net']),
        savingsRatePercent: _num(json['savingsRatePercent']),
      );

  final DateTime? from;
  final DateTime? to;
  final num totalIncome;
  final num totalExpense;
  final num net;
  final num savingsRatePercent;
}

/// GET /api/dashboard/networth
class NetWorth {
  const NetWorth({
    required this.bankBalances,
    required this.creditCardOutstanding,
    required this.networth,
    this.note,
  });

  factory NetWorth.fromJson(Map<String, Object?> json) => NetWorth(
        bankBalances: _num(json['bankBalances']),
        creditCardOutstanding: _num(json['creditCardOutstanding']),
        networth: _num(json['networth']),
        note: json['note'] as String?,
      );

  final num bankBalances;
  final num creditCardOutstanding;
  final num networth;
  final String? note;
}

/// One element of GET /api/dashboard/monthly (`month` is `yyyy-MM`).
class MonthlyFlow {
  const MonthlyFlow({
    required this.month,
    required this.income,
    required this.expense,
    required this.net,
  });

  factory MonthlyFlow.fromJson(Map<String, Object?> json) => MonthlyFlow(
        month: '${json['month']}',
        income: _num(json['income']),
        expense: _num(json['expense']),
        net: _num(json['net']),
      );

  final String month;
  final num income;
  final num expense;
  final num net;
}

/// One element of GET /api/dashboard/category.
class CategorySpend {
  const CategorySpend({
    required this.category,
    required this.totalSpent,
    required this.transactionCount,
  });

  factory CategorySpend.fromJson(Map<String, Object?> json) => CategorySpend(
        category: (json['category'] as String?) ?? 'Uncategorized',
        totalSpent: _num(json['totalSpent']),
        transactionCount: _num(json['transactionCount']).toInt(),
      );

  final String category;
  final num totalSpent;
  final int transactionCount;
}
