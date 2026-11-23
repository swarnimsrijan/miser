import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:miser_api/miser_api.dart';

import '../../core/api/api_providers.dart';
import '../../core/formatting/formatters.dart';
import '../../core/widgets/common.dart';

final recurringProvider = FutureProvider.autoDispose<List<RecurringPayment>>((ref) async {
  final res = await ref.watch(miserApiProvider).getInsightControllerApi().recurring();
  return [...?res.data]
    ..sort((a, b) => (b.monthlyEquivalent ?? 0).compareTo(a.monthlyEquivalent ?? 0));
});

String _frequency(RecurringPaymentFrequencyEnum? f) => switch (f) {
      RecurringPaymentFrequencyEnum.WEEKLY => 'Weekly',
      RecurringPaymentFrequencyEnum.MONTHLY => 'Monthly',
      RecurringPaymentFrequencyEnum.QUARTERLY => 'Quarterly',
      RecurringPaymentFrequencyEnum.YEARLY => 'Yearly',
      null => 'Recurring',
    };

class RecurringScreen extends ConsumerWidget {
  const RecurringScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recurring = ref.watch(recurringProvider);
    final theme = Theme.of(context);
    return PageScaffold(
      title: 'Recurring payments',
      maxWidth: 900,
      onRefresh: () async => ref.invalidate(recurringProvider),
      children: [
        AsyncValueView(
          value: recurring,
          onRetry: () => ref.invalidate(recurringProvider),
          data: (list) {
            if (list.isEmpty) {
              return const EmptyState(
                icon: Icons.autorenew,
                message: 'No subscriptions or EMIs detected yet. These appear after a few months of statements.',
              );
            }
            final active = list.where((r) => r.active != false).toList();
            final total = active.fold<num>(0, (s, r) => s + (r.monthlyEquivalent ?? 0));
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Active commitments per month', style: theme.textTheme.labelLarge),
                        Text(Inr.format(total, decimals: false), style: theme.textTheme.headlineSmall),
                        Text('${active.length} active of ${list.length} detected',
                            style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: Column(
                    children: [
                      for (final r in list)
                        Opacity(
                          opacity: r.active == false ? 0.55 : 1,
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Icon(r.category?.toLowerCase().contains('emi') == true ||
                                      r.category?.toLowerCase().contains('loan') == true
                                  ? Icons.account_balance
                                  : Icons.subscriptions_outlined),
                            ),
                            title: Text(r.name ?? 'Payment'),
                            subtitle: Text([
                              _frequency(r.frequency),
                              if (r.category != null) r.category!,
                              if (r.typicalAmount != null) '${Inr.format(r.typicalAmount)} each',
                              '${r.occurrences ?? 0} seen',
                              if (r.active == false) 'inactive'
                              else if (r.nextExpectedDate != null) 'next ${Dates.display(r.nextExpectedDate)}',
                            ].join(' · ')),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(Inr.format(r.monthlyEquivalent, decimals: false),
                                    style: theme.textTheme.titleSmall),
                                Text('/ month', style: theme.textTheme.bodySmall),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
