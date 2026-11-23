import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miser_api/miser_api.dart';

import '../../core/api/api_providers.dart';
import 'dashboard_api.dart';
import 'dashboard_models.dart';

/// This month (backend default range).
final dashboardSummaryProvider = FutureProvider.autoDispose<DashboardSummary>(
  (ref) => ref.watch(dashboardApiProvider).summary(),
);

final netWorthProvider = FutureProvider.autoDispose<NetWorth>(
  (ref) => ref.watch(dashboardApiProvider).networth(),
);

/// Last 12 months, oldest first (the backend default range).
final monthlyFlowProvider = FutureProvider.autoDispose<List<MonthlyFlow>>(
  (ref) => ref.watch(dashboardApiProvider).monthly(),
);

/// This month's spend by category, largest first.
final categorySpendProvider = FutureProvider.autoDispose<List<CategorySpend>>((ref) async {
  final list = await ref.watch(dashboardApiProvider).byCategory();
  return list..sort((a, b) => b.totalSpent.compareTo(a.totalSpent));
});

final tipsProvider = FutureProvider.autoDispose<List<Tip>>((ref) async {
  final res = await ref.watch(miserApiProvider).getInsightControllerApi().tips();
  return res.data ?? const [];
});
