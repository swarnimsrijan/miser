import 'package:flutter_test/flutter_test.dart';
import 'package:miser_app/core/api/auth_interceptor.dart';
import 'package:miser_app/core/auth/auth_service.dart';
import 'package:miser_app/features/home/dashboard_api.dart';

import '../helpers/fakes.dart';

void main() {
  test('dashboard maps (field names from DashboardService.java) parse into models', () async {
    final adapter = FakeAdapter((r) => switch (r.uri.path) {
          '/api/dashboard/summary' => {
              'from': '2026-11-01',
              'to': '2026-11-24',
              'totalIncome': 125000.5,
              'totalExpense': 80000,
              'net': 45000.5,
              'savingsRatePercent': 36.0,
            },
          '/api/dashboard/networth' => {
              'bankBalances': 500000,
              'creditCardOutstanding': 25000.25,
              'networth': 474999.75,
              'note': 'Based on statement running balances',
            },
          '/api/dashboard/monthly' => [
              {'month': '2026-10', 'income': 100000, 'expense': 70000, 'net': 30000},
              {'month': '2026-11', 'income': 125000.5, 'expense': 80000, 'net': 45000.5},
            ],
          '/api/dashboard/category' => [
              {'category': 'Food', 'totalSpent': 12000, 'transactionCount': 31},
              {'category': null, 'totalSpent': 500, 'transactionCount': 2},
            ],
          _ => const FakeResponse(404),
        });
    final dio = fakeDio(adapter);
    dio.interceptors.add(
      AuthInterceptor(FakeAuthService(initial: const AuthState(AuthStatus.signedIn)), dio),
    );
    final api = DashboardApi(dio);

    final summary = await api.summary(from: DateTime(2026, 11, 1), to: DateTime(2026, 11, 24));
    expect(summary.totalIncome, 125000.5);
    expect(summary.savingsRatePercent, 36.0);
    expect(summary.from, DateTime(2026, 11, 1));
    expect(adapter.requests.first.uri.query, 'from=2026-11-01&to=2026-11-24');
    expect(adapter.requests.first.options.headers['Authorization'], 'Bearer token-1');

    final nw = await api.networth();
    expect(nw.networth, 474999.75);
    expect(nw.creditCardOutstanding, 25000.25);

    final monthly = await api.monthly();
    expect(monthly.map((m) => m.month), ['2026-10', '2026-11']);
    expect(monthly.last.net, 45000.5);

    final cats = await api.byCategory();
    expect(cats.first.category, 'Food');
    expect(cats.first.transactionCount, 31);
    expect(cats.last.category, 'Uncategorized');
  });
}
