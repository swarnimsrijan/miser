import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:miser_api/miser_api.dart';

import '../../core/api/api_error.dart';
import '../../core/api/api_providers.dart';
import '../../core/formatting/formatters.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/common.dart';

const _horizonMonths = 12;

final forecastProvider = FutureProvider.autoDispose<WhatIfResponse>((ref) async {
  final res = await ref
      .watch(miserApiProvider)
      .getPlannerControllerApi()
      .forecast(months: _horizonMonths);
  return res.data!;
});

class _OneOffDraft {
  _OneOffDraft({required this.month, required this.amount, required this.label, required this.isExpense});

  final String month;
  final num amount;
  final String label;
  final bool isExpense;
}

class PlannerScreen extends ConsumerStatefulWidget {
  const PlannerScreen({super.key});

  @override
  ConsumerState<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends ConsumerState<PlannerScreen> {
  double _incomeChange = 0;
  final _extraIncome = TextEditingController();
  final Map<int?, double> _categoryChange = {};
  final List<_OneOffDraft> _oneOffs = [];
  WhatIfResponse? _result;
  bool _running = false;
  String? _error;

  @override
  void dispose() {
    _extraIncome.dispose();
    super.dispose();
  }

  bool get _hasChanges =>
      _incomeChange != 0 ||
      (num.tryParse(_extraIncome.text.trim()) ?? 0) != 0 ||
      _categoryChange.values.any((v) => v != 0) ||
      _oneOffs.isNotEmpty;

  void _reset() => setState(() {
        _incomeChange = 0;
        _extraIncome.clear();
        _categoryChange.clear();
        _oneOffs.clear();
        _result = null;
        _error = null;
      });

  Future<void> _run() async {
    setState(() {
      _running = true;
      _error = null;
    });
    try {
      final res = await ref.read(miserApiProvider).getPlannerControllerApi().whatIf(
            whatIfRequest: WhatIfRequest(
              months: _horizonMonths,
              incomeChangePercent: _incomeChange.round(),
              extraMonthlyIncome: num.tryParse(_extraIncome.text.trim()) ?? 0,
              categoryChanges: [
                for (final e in _categoryChange.entries)
                  if (e.value != 0) CategoryChange(categoryId: e.key, changePercent: e.value.round()),
              ],
              oneOffs: [
                for (final o in _oneOffs)
                  // Backend convention: positive = extra expense, negative = extra income.
                  OneOff(month: o.month, amount: o.isExpense ? o.amount : -o.amount, label: o.label),
              ],
            ),
          );
      setState(() {
        _result = res.data;
        _running = false;
      });
    } catch (e) {
      setState(() {
        _running = false;
        _error = describeError(e);
      });
    }
  }

  Future<void> _addOneOff() async {
    final draft = await showDialog<_OneOffDraft>(context: context, builder: (_) => const _OneOffDialog());
    if (draft != null) setState(() => _oneOffs.add(draft));
  }

  @override
  Widget build(BuildContext context) {
    final forecast = ref.watch(forecastProvider);
    final wide = MediaQuery.sizeOf(context).width >= 1100;
    return PageScaffold(
      title: 'Planner',
      onRefresh: () async => ref.invalidate(forecastProvider),
      actions: [
        if (_hasChanges || _result != null)
          TextButton.icon(onPressed: _reset, icon: const Icon(Icons.restart_alt), label: const Text('Reset')),
      ],
      children: [
        AsyncValueView(
          value: forecast,
          onRetry: () => ref.invalidate(forecastProvider),
          data: (baseline) {
            final editor = _ScenarioEditor(
              baseline: baseline,
              incomeChange: _incomeChange,
              onIncomeChange: (v) => setState(() => _incomeChange = v),
              extraIncome: _extraIncome,
              categoryChange: _categoryChange,
              onCategoryChange: (id, v) => setState(() => _categoryChange[id] = v),
              oneOffs: _oneOffs,
              onAddOneOff: _addOneOff,
              onRemoveOneOff: (i) => setState(() => _oneOffs.removeAt(i)),
              running: _running,
              error: _error,
              onRun: _run,
            );
            final results = _Results(baseline: baseline, result: _result);
            if (wide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 2, child: editor),
                  const SizedBox(width: 16),
                  Expanded(flex: 3, child: results),
                ],
              );
            }
            return Column(children: [results, const SizedBox(height: 16), editor]);
          },
        ),
      ],
    );
  }
}

class _ScenarioEditor extends StatelessWidget {
  const _ScenarioEditor({
    required this.baseline,
    required this.incomeChange,
    required this.onIncomeChange,
    required this.extraIncome,
    required this.categoryChange,
    required this.onCategoryChange,
    required this.oneOffs,
    required this.onAddOneOff,
    required this.onRemoveOneOff,
    required this.running,
    required this.error,
    required this.onRun,
  });

  final WhatIfResponse baseline;
  final double incomeChange;
  final ValueChanged<double> onIncomeChange;
  final TextEditingController extraIncome;
  final Map<int?, double> categoryChange;
  final void Function(int? id, double value) onCategoryChange;
  final List<_OneOffDraft> oneOffs;
  final VoidCallback onAddOneOff;
  final ValueChanged<int> onRemoveOneOff;
  final bool running;
  final String? error;
  final VoidCallback onRun;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categories = [...?baseline.categories]
      ..sort((a, b) => (b.baselineMonthly ?? 0).compareTo(a.baselineMonthly ?? 0));
    return SectionCard(
      title: 'What if…',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Income change: ${incomeChange >= 0 ? '+' : ''}${incomeChange.round()}%'),
          Slider(
            value: incomeChange,
            min: -50,
            max: 50,
            divisions: 20,
            label: '${incomeChange.round()}%',
            onChanged: onIncomeChange,
          ),
          TextField(
            controller: extraIncome,
            keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
            decoration: const InputDecoration(
              labelText: 'Extra monthly income',
              prefixText: '₹ ',
              helperText: 'e.g. a side gig or rent received',
            ),
          ),
          const SizedBox(height: 16),
          Text('Category spending', style: theme.textTheme.titleSmall),
          if (categories.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('No spending history yet.'),
            ),
          for (final c in categories)
            _CategorySlider(
              line: c,
              value: categoryChange[c.categoryId] ?? 0,
              onChanged: (v) => onCategoryChange(c.categoryId, v),
            ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: Text('One-off events', style: theme.textTheme.titleSmall)),
              TextButton.icon(onPressed: onAddOneOff, icon: const Icon(Icons.add), label: const Text('Add')),
            ],
          ),
          for (var i = 0; i < oneOffs.length; i++)
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: Icon(oneOffs[i].isExpense ? Icons.north_east : Icons.south_west),
              title: Text(oneOffs[i].label.isEmpty ? 'Event' : oneOffs[i].label),
              subtitle: Text('${Dates.monthLabel(oneOffs[i].month)} · '
                  '${oneOffs[i].isExpense ? 'Expense' : 'Income'} ${Inr.format(oneOffs[i].amount, decimals: false)}'),
              trailing: IconButton(
                tooltip: 'Remove',
                icon: const Icon(Icons.close),
                onPressed: () => onRemoveOneOff(i),
              ),
            ),
          if (error != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(error!, style: TextStyle(color: theme.colorScheme.error)),
            ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: running ? null : onRun,
            icon: running
                ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.play_arrow),
            label: const Text('Run scenario'),
          ),
        ],
      ),
    );
  }
}

class _CategorySlider extends StatelessWidget {
  const _CategorySlider({required this.line, required this.value, required this.onChanged});

  final CategoryLine line;
  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final base = (line.baselineMonthly ?? 0).toDouble();
    final adjusted = base * (1 + value / 100);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: Text(line.category ?? 'Uncategorized', overflow: TextOverflow.ellipsis)),
            Text(
              value == 0
                  ? '${Inr.format(base, decimals: false)}/mo'
                  : '${value > 0 ? '+' : ''}${value.round()}% → ${Inr.format(adjusted, decimals: false)}/mo',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        Slider(
          value: value,
          min: -100,
          max: 50,
          divisions: 30,
          label: '${value.round()}%',
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _Results extends StatelessWidget {
  const _Results({required this.baseline, required this.result});

  final WhatIfResponse baseline;
  final WhatIfResponse? result;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final base = result?.baseline ?? baseline.baseline;
    final scenario = result?.scenario;
    final delta = result?.monthlySavingsDelta;
    final goals = result?.goals ?? baseline.goals ?? const <GoalEta>[];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionCard(
          title: scenario == null ? 'Baseline forecast (12 months)' : 'Baseline vs scenario',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (baseline.basedOn?.isNotEmpty == true)
                Text(
                  'Based on ${baseline.basedOn!.map((m) => Dates.monthLabel(m, short: true)).join(', ')}',
                  style: theme.textTheme.bodySmall,
                ),
              const SizedBox(height: 12),
              ResponsiveGrid(
                minItemWidth: 160,
                children: [
                  _Metric('Monthly income', Inr.format(base?.monthlyIncome, decimals: false),
                      scenario == null ? null : Inr.format(scenario.monthlyIncome, decimals: false)),
                  _Metric('Monthly expense', Inr.format(base?.monthlyExpense, decimals: false),
                      scenario == null ? null : Inr.format(scenario.monthlyExpense, decimals: false)),
                  _Metric('Monthly savings', Inr.format(base?.monthlySavings, decimals: false),
                      scenario == null ? null : Inr.format(scenario.monthlySavings, decimals: false)),
                  _Metric('Saved in 12 months', Inr.format(base?.totalSavings, decimals: false),
                      scenario == null ? null : Inr.format(scenario.totalSavings, decimals: false)),
                ],
              ),
              if (delta != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (delta >= 0 ? scheme.income : scheme.expense).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Monthly savings change: ${Inr.signed(delta, decimals: false)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: delta >= 0 ? scheme.income : scheme.expense,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              SizedBox(
                height: 260,
                child: CumulativeSavingsChart(
                  baseline: base?.months ?? const [],
                  scenario: scenario?.months,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionCard(
          title: 'Goal ETAs',
          child: goals.isEmpty
              ? const Text('No active goals.')
              : Column(
                  children: [
                    for (final g in goals) _GoalEtaRow(goal: g, showScenario: result != null),
                  ],
                ),
        ),
      ],
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric(this.label, this.baseline, this.scenario);

  final String label;
  final String baseline;
  final String? scenario;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        Text(baseline, style: theme.textTheme.titleMedium),
        if (scenario != null)
          Text('→ $scenario', style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.tertiary)),
      ],
    );
  }
}

class _GoalEtaRow extends StatelessWidget {
  const _GoalEtaRow({required this.goal, required this.showScenario});

  final GoalEta goal;
  final bool showScenario;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final base = Dates.parseYearMonth(goal.baselineCompletion);
    final scen = Dates.parseYearMonth(goal.scenarioCompletion);
    String? change;
    Color? color;
    if (showScenario && base != null && scen != null) {
      final months = (scen.year - base.year) * 12 + scen.month - base.month;
      if (months < 0) {
        change = '${-months} mo sooner';
        color = scheme.income;
      } else if (months > 0) {
        change = '$months mo later';
        color = scheme.expense;
      } else {
        change = 'no change';
      }
    } else if (showScenario && base != null && scen == null) {
      change = 'out of reach';
      color = scheme.expense;
    }
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.flag_outlined),
      title: Text(goal.name ?? 'Goal'),
      subtitle: Text([
        'Baseline: ${goal.baselineCompletion == null ? 'not reachable' : Dates.monthLabel(goal.baselineCompletion)}',
        if (showScenario)
          'Scenario: ${goal.scenarioCompletion == null ? 'not reachable' : Dates.monthLabel(goal.scenarioCompletion)}',
        if (goal.targetDate != null) 'Target ${Dates.display(goal.targetDate)}',
      ].join(' · ')),
      trailing: change == null ? null : Text(change, style: TextStyle(color: color)),
    );
  }
}

class CumulativeSavingsChart extends StatelessWidget {
  const CumulativeSavingsChart({super.key, required this.baseline, this.scenario});

  final List<ProjectedMonth> baseline;
  final List<ProjectedMonth>? scenario;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    if (baseline.isEmpty) return const Center(child: Text('Not enough history to forecast yet.'));
    List<FlSpot> spots(List<ProjectedMonth> ms) => [
          for (var i = 0; i < ms.length; i++) FlSpot(i.toDouble(), (ms[i].cumulativeSavings ?? 0).toDouble()),
        ];
    final all = [...baseline, ...?scenario].map((m) => (m.cumulativeSavings ?? 0).toDouble());
    final minY = math.min(0.0, all.reduce(math.min));
    final maxY = math.max(1.0, all.reduce(math.max));
    final pad = (maxY - minY) * 0.1;
    return Column(
      children: [
        Expanded(
          child: LineChart(
            LineChartData(
              minY: minY - (minY < 0 ? pad : 0),
              maxY: maxY + pad,
              gridData: FlGridData(
                drawVerticalLine: false,
                getDrawingHorizontalLine: (_) => FlLine(color: scheme.outlineVariant, strokeWidth: 0.5),
              ),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(),
                rightTitles: const AxisTitles(),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 56,
                    getTitlesWidget: (v, meta) => SideTitleWidget(
                      meta: meta,
                      child: Text(Inr.compact(v), style: theme.textTheme.labelSmall),
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 2,
                    reservedSize: 28,
                    getTitlesWidget: (v, meta) {
                      final i = v.toInt();
                      if (i < 0 || i >= baseline.length || v != i.toDouble()) {
                        return const SizedBox.shrink();
                      }
                      return SideTitleWidget(
                        meta: meta,
                        child: Text(Dates.monthLabel(baseline[i].month, short: true),
                            style: theme.textTheme.labelSmall),
                      );
                    },
                  ),
                ),
              ),
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipColor: (_) => scheme.inverseSurface,
                  getTooltipItems: (spots) => [
                    for (final s in spots)
                      LineTooltipItem(
                        '${s.barIndex == 0 ? 'Baseline' : 'Scenario'}: ${Inr.compact(s.y)}',
                        TextStyle(color: scheme.onInverseSurface, fontSize: 12),
                      ),
                  ],
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: spots(baseline),
                  color: scheme.outline,
                  barWidth: 2,
                  dashArray: scenario == null ? null : [6, 4],
                  dotData: const FlDotData(show: false),
                ),
                if (scenario != null)
                  LineChartBarData(
                    spots: spots(scenario!),
                    color: scheme.primary,
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(show: true, color: scheme.primary.withValues(alpha: 0.08)),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(spacing: 16, children: [
          _LegendLine(color: scheme.outline, label: 'Baseline'),
          if (scenario != null) _LegendLine(color: scheme.primary, label: 'Scenario'),
        ]),
      ],
    );
  }
}

class _LegendLine extends StatelessWidget {
  const _LegendLine({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 16, height: 3, color: color),
          const SizedBox(width: 6),
          Text(label, style: Theme.of(context).textTheme.labelSmall),
        ],
      );
}

class _OneOffDialog extends StatefulWidget {
  const _OneOffDialog();

  @override
  State<_OneOffDialog> createState() => _OneOffDialogState();
}

class _OneOffDialogState extends State<_OneOffDialog> {
  final _form = GlobalKey<FormState>();
  final _amount = TextEditingController();
  final _label = TextEditingController();
  late final List<String> _months = [
    for (var i = 0; i < _horizonMonths; i++)
      Dates.yearMonth(DateTime(DateTime.now().year, DateTime.now().month + i)),
  ];
  late String _month = _months.first;
  bool _isExpense = true;

  @override
  void dispose() {
    _amount.dispose();
    _label.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('One-off event'),
      content: SizedBox(
        width: 360,
        child: Form(
          key: _form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(value: true, label: Text('Expense')),
                  ButtonSegment(value: false, label: Text('Income')),
                ],
                selected: {_isExpense},
                onSelectionChanged: (s) => setState(() => _isExpense = s.first),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _month,
                decoration: const InputDecoration(labelText: 'Month'),
                items: [for (final m in _months) DropdownMenuItem(value: m, child: Text(Dates.monthLabel(m)))],
                onChanged: (v) => setState(() => _month = v ?? _month),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _amount,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Amount', prefixText: '₹ '),
                validator: (v) {
                  final n = num.tryParse((v ?? '').trim());
                  return n == null || n <= 0 ? 'Enter an amount above zero' : null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _label,
                maxLength: 100,
                decoration: InputDecoration(
                  labelText: 'Label',
                  hintText: _isExpense ? 'e.g. Goa trip' : 'e.g. Annual bonus',
                  counterText: '',
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        FilledButton(
          onPressed: () {
            if (!_form.currentState!.validate()) return;
            Navigator.of(context).pop(_OneOffDraft(
              month: _month,
              amount: num.parse(_amount.text.trim()),
              label: _label.text.trim(),
              isExpense: _isExpense,
            ));
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
