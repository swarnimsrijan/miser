import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:miser_api/miser_api.dart';

import '../../core/api/api_error.dart';
import '../../core/api/api_providers.dart';
import '../../core/formatting/formatters.dart';
import '../../core/widgets/common.dart';
import '../transactions/category_providers.dart';
import 'budget_status_card.dart';

final budgetsProvider = FutureProvider.autoDispose<List<BudgetResponse>>((ref) async {
  final res = await ref.watch(miserApiProvider).getBudgetControllerApi().list1();
  return res.data ?? const [];
});

/// Status for a month, keyed by `yyyy-MM`.
final budgetStatusProvider =
    FutureProvider.autoDispose.family<List<BudgetStatus>, String>((ref, month) async {
  final res = await ref.watch(miserApiProvider).getBudgetControllerApi().status(month: month);
  return res.data ?? const [];
});

class BudgetsScreen extends ConsumerStatefulWidget {
  const BudgetsScreen({super.key});

  @override
  ConsumerState<BudgetsScreen> createState() => _BudgetsScreenState();
}

class _BudgetsScreenState extends ConsumerState<BudgetsScreen> {
  DateTime _month = DateTime(DateTime.now().year, DateTime.now().month);

  String get _monthKey => Dates.yearMonth(_month);

  void _shiftMonth(int delta) =>
      setState(() => _month = DateTime(_month.year, _month.month + delta));

  void _reload() {
    ref
      ..invalidate(budgetsProvider)
      ..invalidate(budgetStatusProvider);
  }

  Future<void> _edit({BudgetResponse? existing}) async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => _BudgetDialog(existing: existing),
    );
    if (saved == true) _reload();
  }

  Future<void> _delete(int categoryId, String? name) async {
    final ok = await confirmDialog(
      context,
      title: 'Remove budget?',
      message: 'Stop tracking a monthly cap for ${name ?? 'this category'}?',
      confirmLabel: 'Remove',
    );
    if (!ok) return;
    try {
      await ref.read(miserApiProvider).getBudgetControllerApi().delete(categoryId: categoryId);
      _reload();
    } catch (e) {
      if (mounted) showSnack(context, describeError(e), error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final budgets = ref.watch(budgetsProvider);
    final status = ref.watch(budgetStatusProvider(_monthKey));
    final now = DateTime.now();
    final isCurrent = _month.year == now.year && _month.month == now.month;
    final byCategory = {for (final b in budgets.value ?? <BudgetResponse>[]) b.categoryId: b};

    return PageScaffold(
      title: 'Budgets',
      maxWidth: 1000,
      onRefresh: () async => _reload(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _edit(),
        icon: const Icon(Icons.add),
        label: const Text('Set budget'),
      ),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              tooltip: 'Previous month',
              onPressed: () => _shiftMonth(-1),
              icon: const Icon(Icons.chevron_left),
            ),
            Text(Dates.monthLabel(_monthKey), style: Theme.of(context).textTheme.titleMedium),
            IconButton(
              tooltip: 'Next month',
              onPressed: isCurrent ? null : () => _shiftMonth(1),
              icon: const Icon(Icons.chevron_right),
            ),
          ],
        ),
        AsyncValueView(
          value: status,
          onRetry: _reload,
          data: (list) {
            if (list.isEmpty) {
              return EmptyState(
                icon: Icons.pie_chart_outline,
                message: 'No budgets yet. Set a monthly cap for a category to track it here.',
                action: FilledButton.tonal(onPressed: () => _edit(), child: const Text('Set budget')),
              );
            }
            final sorted = [...list]
              ..sort((a, b) => (b.percentUsed ?? 0).compareTo(a.percentUsed ?? 0));
            return ResponsiveGrid(
              minItemWidth: 380,
              children: [
                for (final s in sorted)
                  BudgetStatusCard(
                    status: s,
                    onEdit: byCategory[s.categoryId] == null
                        ? null
                        : () => _edit(existing: byCategory[s.categoryId]),
                    onDelete:
                        s.categoryId == null ? null : () => _delete(s.categoryId!, s.category),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _BudgetDialog extends ConsumerStatefulWidget {
  const _BudgetDialog({this.existing});

  final BudgetResponse? existing;

  @override
  ConsumerState<_BudgetDialog> createState() => _BudgetDialogState();
}

class _BudgetDialogState extends ConsumerState<_BudgetDialog> {
  final _form = GlobalKey<FormState>();
  late final _limit = TextEditingController(
    text: widget.existing?.monthlyLimit?.toString() ?? '',
  );
  late int? _categoryId = widget.existing?.categoryId;
  late double _threshold = (widget.existing?.alertThresholdPercent ?? 80).toDouble();
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _limit.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref.read(miserApiProvider).getBudgetControllerApi().upsert(
            categoryId: _categoryId!,
            budgetRequest: BudgetRequest(
              monthlyLimit: num.parse(_limit.text.trim()),
              alertThresholdPercent: _threshold.round(),
            ),
          );
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      setState(() {
        _saving = false;
        _error = describeError(e);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider);
    return AlertDialog(
      title: Text(widget.existing == null ? 'Set budget' : 'Edit ${widget.existing!.category}'),
      content: SizedBox(
        width: 380,
        child: Form(
          key: _form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.existing == null)
                AsyncValueView(
                  value: categories,
                  compact: true,
                  data: (list) => DropdownButtonFormField<int>(
                    initialValue: _categoryId,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: 'Category'),
                    items: [
                      for (final c in list)
                        DropdownMenuItem(value: c.id, child: Text(c.name ?? '#${c.id}')),
                    ],
                    validator: (v) => v == null ? 'Choose a category' : null,
                    onChanged: (v) => setState(() => _categoryId = v),
                  ),
                ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _limit,
                autofocus: widget.existing != null,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Monthly limit', prefixText: '₹ '),
                validator: (v) {
                  final n = num.tryParse((v ?? '').trim());
                  return n == null || n <= 0 ? 'Enter an amount above zero' : null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Warn at'),
                  Expanded(
                    child: Slider(
                      value: _threshold,
                      min: 10,
                      max: 100,
                      divisions: 18,
                      label: '${_threshold.round()}%',
                      onChanged: (v) => setState(() => _threshold = v),
                    ),
                  ),
                  SizedBox(width: 44, child: Text('${_threshold.round()}%')),
                ],
              ),
              if (_error != null)
                Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
        FilledButton(onPressed: _saving ? null : _save, child: const Text('Save')),
      ],
    );
  }
}
