import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:miser_api/miser_api.dart';
import 'package:miser_app/core/theme/app_theme.dart';
import 'package:miser_app/features/budgets/budget_status_card.dart';

BudgetStatus _status(BudgetStatusStatusEnum state, {num spent = 4000, num projected = 6000}) =>
    BudgetStatus(
      categoryId: 1,
      category: 'Food & Dining',
      month: '2026-11',
      monthlyLimit: 10000,
      spent: spent,
      remaining: 10000 - spent,
      percentUsed: spent * 100 / 10000,
      projectedSpend: projected,
      status: state,
    );

Future<void> _pump(WidgetTester tester, BudgetStatus s, {ThemeData? theme}) => tester.pumpWidget(
      MaterialApp(
        theme: theme ?? AppTheme.light(),
        home: Scaffold(body: SizedBox(width: 420, child: BudgetStatusCard(status: s))),
      ),
    );

LinearProgressIndicator _bar(WidgetTester tester) =>
    tester.widget(find.byKey(const Key('budget-progress')));

void main() {
  final scheme = AppTheme.light().colorScheme;

  testWidgets('ON_TRACK renders green with spent/limit and projection', (tester) async {
    await _pump(tester, _status(BudgetStatusStatusEnum.ON_TRACK));
    expect(find.text('On track'), findsOneWidget);
    expect(find.text('Food & Dining'), findsOneWidget);
    expect(find.text('₹4,000 of ₹10,000 (40%)'), findsOneWidget);
    expect(find.text('₹6,000 left'), findsOneWidget);
    expect(find.text('Projected: ₹6,000'), findsOneWidget);
    expect(_bar(tester).color, scheme.success);
    expect(_bar(tester).value, closeTo(0.4, 1e-9));
  });

  testWidgets('WARNING renders amber and flags the projected overrun', (tester) async {
    await _pump(tester, _status(BudgetStatusStatusEnum.WARNING, spent: 8500, projected: 12500));
    expect(find.text('Warning'), findsOneWidget);
    expect(_bar(tester).color, scheme.warning);
    expect(find.text('Projected: ₹12,500 — on pace to exceed'), findsOneWidget);
  });

  testWidgets('EXCEEDED renders in the error colour, caps the bar, shows overspend', (tester) async {
    await _pump(tester, _status(BudgetStatusStatusEnum.EXCEEDED, spent: 13000, projected: 15000));
    expect(find.text('Exceeded'), findsOneWidget);
    expect(_bar(tester).color, scheme.error);
    expect(_bar(tester).value, 1.0);
    expect(find.text('₹3,000 over'), findsOneWidget);
    expect(find.text('₹13,000 of ₹10,000 (130%)'), findsOneWidget);
  });

  testWidgets('status colours adapt to the dark theme', (tester) async {
    final dark = AppTheme.dark();
    await _pump(tester, _status(BudgetStatusStatusEnum.ON_TRACK), theme: dark);
    expect(_bar(tester).color, dark.colorScheme.success);
    expect(dark.colorScheme.success, isNot(scheme.success));
  });
}
