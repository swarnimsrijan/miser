import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:miser_api/miser_api.dart';

import '../../core/api/api_error.dart';
import '../../core/api/api_providers.dart';
import '../../core/formatting/formatters.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/common.dart';

final goalsProvider = FutureProvider.autoDispose<List<GoalResponse>>((ref) async {
  final res = await ref.watch(miserApiProvider).getGoalControllerApi().list();
  return [...?res.data]..sort((a, b) => (a.priority ?? 3).compareTo(b.priority ?? 3));
});

class GoalsScreen extends ConsumerWidget {
  const GoalsScreen({super.key});

  Future<void> _edit(BuildContext context, WidgetRef ref, {GoalResponse? goal}) async {
    final saved = await showDialog<bool>(context: context, builder: (_) => _GoalDialog(goal: goal));
    if (saved == true) ref.invalidate(goalsProvider);
  }

  Future<void> _contribute(BuildContext context, WidgetRef ref, GoalResponse goal) async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => _ContributionDialog(goal: goal),
    );
    if (saved == true) ref.invalidate(goalsProvider);
  }

  Future<void> _delete(BuildContext context, WidgetRef ref, GoalResponse goal) async {
    final ok = await confirmDialog(
      context,
      title: 'Delete goal?',
      message: 'Delete "${goal.name}" and its contribution history?',
    );
    if (!ok) return;
    try {
      await ref.read(miserApiProvider).getGoalControllerApi().delete1(id: goal.id!);
      ref.invalidate(goalsProvider);
    } catch (e) {
      if (context.mounted) showSnack(context, describeError(e), error: true);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goals = ref.watch(goalsProvider);
    return PageScaffold(
      title: 'Goals',
      maxWidth: 1000,
      onRefresh: () async => ref.invalidate(goalsProvider),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _edit(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('New goal'),
      ),
      children: [
        AsyncValueView(
          value: goals,
          onRetry: () => ref.invalidate(goalsProvider),
          data: (list) => list.isEmpty
              ? const EmptyState(
                  icon: Icons.flag_outlined,
                  message: 'Create a savings goal (emergency fund, trip, gadget…) to track progress.',
                )
              : ResponsiveGrid(
                  minItemWidth: 380,
                  children: [
                    for (final g in list)
                      GoalCard(
                        goal: g,
                        onContribute: () => _contribute(context, ref, g),
                        onEdit: () => _edit(context, ref, goal: g),
                        onDelete: () => _delete(context, ref, g),
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}

class GoalCard extends StatelessWidget {
  const GoalCard({
    super.key,
    required this.goal,
    this.onContribute,
    this.onEdit,
    this.onDelete,
  });

  final GoalResponse goal;
  final VoidCallback? onContribute;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final g = goal;
    final pct = (g.percentComplete ?? 0).toDouble();
    final achieved = g.status == GoalResponseStatusEnum.ACHIEVED;
    final paused = g.status == GoalResponseStatusEnum.PAUSED;
    final (Color stateColor, String stateLabel) = achieved
        ? (scheme.success, 'Achieved')
        : paused
            ? (scheme.outline, 'Paused')
            : switch (g.onTrack) {
                true => (scheme.success, 'On track'),
                false => (scheme.warning, 'Behind'),
                null => (scheme.outline, 'No target date'),
              };
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 4, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(child: Text(g.name ?? 'Goal', style: theme.textTheme.titleMedium)),
                Chip(
                  label: Text(stateLabel),
                  labelStyle: TextStyle(color: stateColor),
                  side: BorderSide(color: stateColor.withValues(alpha: 0.4)),
                  visualDensity: VisualDensity.compact,
                ),
                PopupMenuButton<String>(
                  onSelected: (v) => v == 'edit' ? onEdit?.call() : onDelete?.call(),
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'edit', child: Text('Edit')),
                    PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (pct / 100).clamp(0.0, 1.0),
                      minHeight: 10,
                      color: achieved ? scheme.success : scheme.primary,
                      backgroundColor: scheme.surfaceContainerHighest,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${Inr.format(g.savedAmount, decimals: false)} of '
                    '${Inr.format(g.targetAmount, decimals: false)} · ${pct.toStringAsFixed(0)}%',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 16,
                    runSpacing: 4,
                    children: [
                      if (g.targetDate != null) _Fact('Target date', Dates.display(g.targetDate)),
                      if (g.requiredMonthly != null && !achieved)
                        _Fact('Needed / month', Inr.format(g.requiredMonthly, decimals: false)),
                      if (g.projectedCompletion != null && !achieved)
                        _Fact('Projected', Dates.monthLabel(g.projectedCompletion)),
                      _Fact('Priority', '${g.priority ?? '-'}'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton.tonalIcon(
                      onPressed: onContribute,
                      icon: const Icon(Icons.savings_outlined),
                      label: const Text('Add / withdraw'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        Text(value, style: theme.textTheme.bodyMedium),
      ],
    );
  }
}

class _GoalDialog extends ConsumerStatefulWidget {
  const _GoalDialog({this.goal});

  final GoalResponse? goal;

  @override
  ConsumerState<_GoalDialog> createState() => _GoalDialogState();
}

class _GoalDialogState extends ConsumerState<_GoalDialog> {
  final _form = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.goal?.name ?? '');
  late final _target = TextEditingController(text: widget.goal?.targetAmount?.toString() ?? '');
  final _saved = TextEditingController();
  late DateTime? _targetDate = widget.goal?.targetDate;
  late int _priority = widget.goal?.priority ?? 3;
  late GoalResponseStatusEnum _status = widget.goal?.status ?? GoalResponseStatusEnum.ACTIVE;
  bool _saving = false;
  String? _error;

  bool get _isNew => widget.goal == null;

  @override
  void dispose() {
    _name.dispose();
    _target.dispose();
    _saved.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 40),
      initialDate: _targetDate != null && _targetDate!.isAfter(now)
          ? _targetDate!
          : DateTime(now.year + 1, now.month, now.day),
    );
    if (d != null) setState(() => _targetDate = d);
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    final api = ref.read(miserApiProvider).getGoalControllerApi();
    try {
      if (_isNew) {
        await api.create(
          createGoalRequest: CreateGoalRequest(
            name: _name.text.trim(),
            targetAmount: num.parse(_target.text.trim()),
            targetDate: _targetDate,
            savedAmount: num.tryParse(_saved.text.trim()),
            priority: _priority,
          ),
        );
      } else {
        await api.update(
          id: widget.goal!.id!,
          updateGoalRequest: UpdateGoalRequest(
            name: _name.text.trim(),
            targetAmount: num.parse(_target.text.trim()),
            targetDate: _targetDate,
            priority: _priority,
            status: UpdateGoalRequestStatusEnum.values.byName(_status.name),
          ),
        );
      }
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
    String? amount(String? v, {bool required = true}) {
      final t = (v ?? '').trim();
      if (t.isEmpty) return required ? 'Required' : null;
      final n = num.tryParse(t);
      if (n == null) return 'Not a number';
      if (required && n <= 0) return 'Must be above zero';
      if (n < 0) return 'Cannot be negative';
      return null;
    }

    return AlertDialog(
      title: Text(_isNew ? 'New goal' : 'Edit goal'),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _name,
                  maxLength: 255,
                  decoration: const InputDecoration(labelText: 'Name', counterText: ''),
                  validator: (v) => (v ?? '').trim().isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _target,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Target amount', prefixText: '₹ '),
                  validator: amount,
                ),
                if (_isNew) ...[
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _saved,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration:
                        const InputDecoration(labelText: 'Already saved (optional)', prefixText: '₹ '),
                    validator: (v) => amount(v, required: false),
                  ),
                ],
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.event),
                  title: Text(_targetDate == null ? 'No target date' : Dates.display(_targetDate)),
                  subtitle: const Text('Target date'),
                  trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                    // The PATCH endpoint treats null as "unchanged", so a date
                    // can only be cleared while creating.
                    if (_targetDate != null && _isNew)
                      IconButton(
                        tooltip: 'Clear',
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() => _targetDate = null),
                      ),
                    TextButton(onPressed: _pickDate, child: const Text('Choose')),
                  ]),
                ),
                Row(
                  children: [
                    const Text('Priority'),
                    Expanded(
                      child: Slider(
                        value: _priority.toDouble(),
                        min: 1,
                        max: 5,
                        divisions: 4,
                        label: '$_priority',
                        onChanged: (v) => setState(() => _priority = v.round()),
                      ),
                    ),
                    Text('$_priority'),
                  ],
                ),
                if (!_isNew)
                  DropdownButtonFormField<GoalResponseStatusEnum>(
                    initialValue: _status,
                    decoration: const InputDecoration(labelText: 'Status'),
                    items: [
                      for (final s in GoalResponseStatusEnum.values)
                        DropdownMenuItem(value: s, child: Text(s.value)),
                    ],
                    onChanged: (v) => setState(() => _status = v ?? _status),
                  ),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                  ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
        FilledButton(onPressed: _saving ? null : _save, child: Text(_isNew ? 'Create' : 'Save')),
      ],
    );
  }
}

class _ContributionDialog extends ConsumerStatefulWidget {
  const _ContributionDialog({required this.goal});

  final GoalResponse goal;

  @override
  ConsumerState<_ContributionDialog> createState() => _ContributionDialogState();
}

class _ContributionDialogState extends ConsumerState<_ContributionDialog> {
  final _form = GlobalKey<FormState>();
  final _amount = TextEditingController();
  final _note = TextEditingController();
  bool _withdraw = false;
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    final amount = num.parse(_amount.text.trim());
    try {
      await ref.read(miserApiProvider).getGoalControllerApi().contribute(
            id: widget.goal.id!,
            contributionRequest: ContributionRequest(
              amount: _withdraw ? -amount : amount,
              note: _note.text.trim().isEmpty ? null : _note.text.trim(),
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
    return AlertDialog(
      title: Text(widget.goal.name ?? 'Goal'),
      content: SizedBox(
        width: 360,
        child: Form(
          key: _form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(value: false, label: Text('Add'), icon: Icon(Icons.add)),
                  ButtonSegment(value: true, label: Text('Withdraw'), icon: Icon(Icons.remove)),
                ],
                selected: {_withdraw},
                onSelectionChanged: (s) => setState(() => _withdraw = s.first),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _amount,
                autofocus: true,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Amount', prefixText: '₹ '),
                validator: (v) {
                  final n = num.tryParse((v ?? '').trim());
                  if (n == null || n <= 0) return 'Enter an amount above zero';
                  if (_withdraw && n > (widget.goal.savedAmount ?? 0)) {
                    return 'Only ${Inr.format(widget.goal.savedAmount)} saved';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _note,
                maxLength: 255,
                decoration: const InputDecoration(labelText: 'Note (optional)', counterText: ''),
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
