import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:miser_api/miser_api.dart';

import '../../core/formatting/formatters.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/common.dart';
import 'dashboard_models.dart';
import 'home_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Future<void> _refresh(WidgetRef ref) async {
    ref
      ..invalidate(dashboardSummaryProvider)
      ..invalidate(netWorthProvider)
      ..invalidate(monthlyFlowProvider)
      ..invalidate(categorySpendProvider)
      ..invalidate(tipsProvider);
    await ref.read(dashboardSummaryProvider.future).catchError((_) => _emptySummary);
  }

  static const _emptySummary = DashboardSummary(
    from: null,
    to: null,
    totalIncome: 0,
    totalExpense: 0,
    net: 0,
    savingsRatePercent: 0,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wide = MediaQuery.sizeOf(context).width >= 1000;
    final charts = [
      const _MonthlyChartCard(),
      const _CategoryCard(),
    ];
    return PageScaffold(
      title: 'Home',
      onRefresh: () => _refresh(ref),
      actions: [
        IconButton(
          tooltip: 'Refresh',
          onPressed: () => _refresh(ref),
          icon: const Icon(Icons.refresh),
        ),
      ],
      children: [
        const _SummaryRow(),
        if (wide)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: charts[0]),
              const SizedBox(width: 16),
              Expanded(flex: 2, child: charts[1]),
            ],
          )
        else
          ...charts.expand((c) => [c, const SizedBox(height: 16)]).toList()..removeLast(),
        const _TipsCard(),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value, this.color, this.caption});

  final String label;
  final String value;
  final Color? color;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            )),
            const SizedBox(height: 6),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (caption != null) ...[
              const SizedBox(height: 4),
              Text(caption!, style: theme.textTheme.bodySmall, maxLines: 2,
                  overflow: TextOverflow.ellipsis),
            ],
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends ConsumerWidget {
  const _SummaryRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final summary = ref.watch(dashboardSummaryProvider);
    final networth = ref.watch(netWorthProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('This month', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        AsyncValueView(
          value: summary,
          compact: true,
          onRetry: () => ref.invalidate(dashboardSummaryProvider),
          data: (s) => ResponsiveGrid(
            minItemWidth: 200,
            children: [
              _StatTile(label: 'Income', value: Inr.format(s.totalIncome), color: scheme.income),
              _StatTile(label: 'Expense', value: Inr.format(s.totalExpense), color: scheme.expense),
              _StatTile(
                label: 'Net',
                value: Inr.signed(s.net),
                color: s.net >= 0 ? scheme.income : scheme.expense,
              ),
              _StatTile(
                label: 'Savings rate',
                value: '${s.savingsRatePercent.toStringAsFixed(1)}%',
                caption: s.from == null ? null : '${Dates.display(s.from)} – ${Dates.display(s.to)}',
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        AsyncValueView(
          value: networth,
          compact: true,
          onRetry: () => ref.invalidate(netWorthProvider),
          data: (n) => _StatTile(
            label: 'Net worth',
            value: Inr.format(n.networth),
            color: n.networth >= 0 ? null : scheme.expense,
            caption: 'Bank balances ${Inr.format(n.bankBalances)}  ·  '
                'Card outstanding ${Inr.format(n.creditCardOutstanding)}',
          ),
        ),
      ],
    );
  }
}

class _MonthlyChartCard extends ConsumerWidget {
  const _MonthlyChartCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final monthly = ref.watch(monthlyFlowProvider);
    return SectionCard(
      title: 'Income vs expense (12 months)',
      trailing: Wrap(spacing: 12, children: [
        _Legend(color: scheme.income, label: 'Income'),
        _Legend(color: scheme.expense, label: 'Expense'),
      ]),
      child: AsyncValueView(
        value: monthly,
        compact: true,
        onRetry: () => ref.invalidate(monthlyFlowProvider),
        data: (months) => months.isEmpty
            ? const EmptyState(
                icon: Icons.bar_chart,
                message: 'Upload a statement to see your monthly trend.',
              )
            : SizedBox(height: 260, child: MonthlyFlowChart(months: months)),
      ),
    );
  }
}

class MonthlyFlowChart extends StatelessWidget {
  const MonthlyFlowChart({super.key, required this.months});

  final List<MonthlyFlow> months;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final maxY = months.fold<double>(
      0,
      (m, e) => math.max(m, math.max(e.income.toDouble(), e.expense.toDouble())),
    );
    final top = maxY <= 0 ? 1000.0 : maxY * 1.15;
    return BarChart(
      BarChartData(
        maxY: top,
        alignment: BarChartAlignment.spaceAround,
        gridData: FlGridData(
          drawVerticalLine: false,
          horizontalInterval: top / 4,
          getDrawingHorizontalLine: (_) =>
              FlLine(color: scheme.outlineVariant, strokeWidth: 0.5),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(),
          rightTitles: const AxisTitles(),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 52,
              interval: top / 4,
              getTitlesWidget: (v, meta) => SideTitleWidget(
                meta: meta,
                child: Text(Inr.compact(v), style: theme.textTheme.labelSmall),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              getTitlesWidget: (v, meta) {
                final i = v.toInt();
                if (i < 0 || i >= months.length) return const SizedBox.shrink();
                return SideTitleWidget(
                  meta: meta,
                  child: Text(Dates.monthLabel(months[i].month, short: true),
                      style: theme.textTheme.labelSmall),
                );
              },
            ),
          ),
        ),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => scheme.inverseSurface,
            getTooltipItem: (group, _, rod, rodIndex) => BarTooltipItem(
              '${rodIndex == 0 ? 'Income' : 'Expense'}\n${Inr.format(rod.toY, decimals: false)}',
              TextStyle(color: scheme.onInverseSurface, fontSize: 12),
            ),
          ),
        ),
        barGroups: [
          for (var i = 0; i < months.length; i++)
            BarChartGroupData(
              x: i,
              barsSpace: 2,
              barRods: [
                BarChartRodData(
                  toY: months[i].income.toDouble(),
                  color: scheme.income,
                  width: 7,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(2)),
                ),
                BarChartRodData(
                  toY: months[i].expense.toDouble(),
                  color: scheme.expense,
                  width: 7,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(2)),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 10, height: 10, decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 4),
          Text(label, style: Theme.of(context).textTheme.labelSmall),
        ],
      );
}

/// Palette for category slices, derived from the theme so it works in dark mode.
List<Color> categoryPalette(ColorScheme scheme) => [
      scheme.primary,
      scheme.tertiary,
      scheme.secondary,
      const Color(0xFFE07A5F),
      const Color(0xFF3D85C6),
      const Color(0xFF8E7CC3),
      const Color(0xFFC9A227),
      scheme.outline,
    ];

class _CategoryCard extends ConsumerWidget {
  const _CategoryCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final spend = ref.watch(categorySpendProvider);
    final palette = categoryPalette(scheme);
    return SectionCard(
      title: 'Spend by category (this month)',
      child: AsyncValueView(
        value: spend,
        compact: true,
        onRetry: () => ref.invalidate(categorySpendProvider),
        data: (items) {
          if (items.isEmpty) {
            return const EmptyState(
              icon: Icons.donut_large,
              message: 'No spending recorded this month yet.',
            );
          }
          // Top 7 plus "Other" keeps the chart legible.
          final top = items.take(7).toList();
          final rest = items.skip(7).fold<num>(0, (s, e) => s + e.totalSpent);
          final slices = [
            ...top,
            if (rest > 0) CategorySpend(category: 'Other', totalSpent: rest, transactionCount: 0),
          ];
          final total = slices.fold<num>(0, (s, e) => s + e.totalSpent);
          return Column(
            children: [
              SizedBox(
                height: 180,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 48,
                    sections: [
                      for (var i = 0; i < slices.length; i++)
                        PieChartSectionData(
                          value: slices[i].totalSpent.toDouble(),
                          color: palette[i % palette.length],
                          radius: 36,
                          showTitle: false,
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              for (var i = 0; i < slices.length; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    children: [
                      Container(width: 10, height: 10, decoration: BoxDecoration(
                        color: palette[i % palette.length], shape: BoxShape.circle)),
                      const SizedBox(width: 8),
                      Expanded(child: Text(slices[i].category, overflow: TextOverflow.ellipsis)),
                      Text(
                        total > 0
                            ? '${(slices[i].totalSpent * 100 / total).toStringAsFixed(0)}%  '
                            : '',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(Inr.format(slices[i].totalSpent, decimals: false)),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

Color severityColor(ColorScheme scheme, TipSeverityEnum? severity) => switch (severity) {
      TipSeverityEnum.ALERT => scheme.error,
      TipSeverityEnum.WARNING => scheme.warning,
      _ => scheme.primary,
    };

IconData severityIcon(TipSeverityEnum? severity) => switch (severity) {
      TipSeverityEnum.ALERT => Icons.error_outline,
      TipSeverityEnum.WARNING => Icons.warning_amber,
      _ => Icons.lightbulb_outline,
    };

class _TipsCard extends ConsumerWidget {
  const _TipsCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final tips = ref.watch(tipsProvider);
    return SectionCard(
      title: 'Tips',
      child: AsyncValueView(
        value: tips,
        compact: true,
        onRetry: () => ref.invalidate(tipsProvider),
        data: (list) {
          if (list.isEmpty) {
            return const EmptyState(icon: Icons.thumb_up_outlined, message: 'Nothing to flag right now.');
          }
          const order = {TipSeverityEnum.ALERT: 0, TipSeverityEnum.WARNING: 1, TipSeverityEnum.INFO: 2};
          final sorted = [...list]..sort((a, b) =>
              (order[a.severity] ?? 3).compareTo(order[b.severity] ?? 3));
          return Column(
            children: [
              for (final tip in sorted.take(6))
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    border: Border(left: BorderSide(
                      color: severityColor(scheme, tip.severity), width: 4)),
                    color: severityColor(scheme, tip.severity).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    leading: Icon(severityIcon(tip.severity),
                        color: severityColor(scheme, tip.severity)),
                    title: Text(tip.title ?? tip.type ?? 'Tip'),
                    subtitle: tip.message == null ? null : Text(tip.message!),
                    trailing: tip.amount == null ? null : Text(Inr.format(tip.amount, decimals: false)),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
