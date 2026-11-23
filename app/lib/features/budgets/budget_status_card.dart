import 'package:material_ui/material_ui.dart';
import 'package:miser_api/miser_api.dart';

import '../../core/formatting/formatters.dart';
import '../../core/theme/app_theme.dart';

Color budgetStatusColor(ColorScheme scheme, BudgetStatusStatusEnum? status) => switch (status) {
      BudgetStatusStatusEnum.EXCEEDED => scheme.error,
      BudgetStatusStatusEnum.WARNING => scheme.warning,
      _ => scheme.success,
    };

String budgetStatusLabel(BudgetStatusStatusEnum? status) => switch (status) {
      BudgetStatusStatusEnum.EXCEEDED => 'Exceeded',
      BudgetStatusStatusEnum.WARNING => 'Warning',
      BudgetStatusStatusEnum.ON_TRACK => 'On track',
      null => 'Unknown',
    };

/// One category's budget for a month: spent vs cap, plus projected spend.
class BudgetStatusCard extends StatelessWidget {
  const BudgetStatusCard({super.key, required this.status, this.onEdit, this.onDelete});

  final BudgetStatus status;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final s = status;
    final color = budgetStatusColor(scheme, s.status);
    final percent = (s.percentUsed ?? 0).toDouble();
    final limit = (s.monthlyLimit ?? 0).toDouble();
    final projected = (s.projectedSpend ?? 0).toDouble();
    final remaining = s.remaining ?? 0;
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 8, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(s.category ?? 'Category', style: theme.textTheme.titleMedium),
                ),
                Container(
                  key: const Key('budget-status-chip'),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    budgetStatusLabel(s.status),
                    style: theme.textTheme.labelMedium?.copyWith(color: color),
                  ),
                ),
                if (onEdit != null)
                  IconButton(
                    tooltip: 'Edit budget',
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: onEdit,
                  ),
                if (onDelete != null)
                  IconButton(
                    tooltip: 'Remove budget',
                    icon: const Icon(Icons.delete_outline),
                    onPressed: onDelete,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  key: const Key('budget-progress'),
                  value: (percent / 100).clamp(0.0, 1.0),
                  minHeight: 10,
                  color: color,
                  backgroundColor: scheme.surfaceContainerHighest,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                spacing: 12,
                runSpacing: 4,
                children: [
                  Text('${Inr.format(s.spent, decimals: false)} of '
                      '${Inr.format(limit, decimals: false)} '
                      '(${percent.toStringAsFixed(0)}%)'),
                  Text(
                    remaining >= 0
                        ? '${Inr.format(remaining, decimals: false)} left'
                        : '${Inr.format(-remaining, decimals: false)} over',
                    style: TextStyle(color: remaining >= 0 ? null : scheme.error),
                  ),
                ],
              ),
            ),
            if (s.projectedSpend != null) ...[
              const SizedBox(height: 4),
              Text(
                'Projected: ${Inr.format(projected, decimals: false)}'
                '${projected > limit && limit > 0 ? ' — on pace to exceed' : ''}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: projected > limit && limit > 0 ? scheme.error : scheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
