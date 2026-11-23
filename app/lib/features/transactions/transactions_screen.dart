import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:miser_api/miser_api.dart';

import '../../core/api/api_error.dart';
import '../../core/api/api_providers.dart';
import '../../core/formatting/formatters.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/common.dart';
import 'category_providers.dart';
import 'transactions_controller.dart';

class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  final _search = TextEditingController();
  final _scroll = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      if (_scroll.position.pixels > _scroll.position.maxScrollExtent - 400) {
        ref.read(transactionsControllerProvider.notifier).loadMore();
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    _scroll.dispose();
    super.dispose();
  }

  TransactionsController get _controller => ref.read(transactionsControllerProvider.notifier);

  void _onSearch(String q) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      final f = ref.read(transactionsControllerProvider).filter;
      _controller.setFilter(f.copyWith(q: () => q.trim()));
    });
  }

  Future<void> _pickRange() async {
    final f = ref.read(transactionsControllerProvider).filter;
    final now = DateTime.now();
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 10),
      lastDate: DateTime(now.year, now.month, now.day),
      initialDateRange:
          f.from != null && f.to != null ? DateTimeRange(start: f.from!, end: f.to!) : null,
    );
    if (range == null) return;
    await _controller.setFilter(f.copyWith(from: () => range.start, to: () => range.end));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transactionsControllerProvider);
    final categories = ref.watch(categoriesProvider).value ?? const <MiserCategory>[];
    final f = state.filter;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: TextField(
                  controller: _search,
                  onChanged: _onSearch,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Search description or merchant',
                    suffixIcon: _search.text.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _search.clear();
                              _onSearch('');
                            },
                          ),
                  ),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Row(
                  children: [
                    for (final t in const ['DEBIT', 'CREDIT'])
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(t == 'DEBIT' ? 'Money out' : 'Money in'),
                          selected: f.type == t,
                          onSelected: (sel) =>
                              _controller.setFilter(f.copyWith(type: () => sel ? t : null)),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: InputChip(
                        avatar: const Icon(Icons.category_outlined, size: 18),
                        label: Text(f.categoryId == null
                            ? 'Category'
                            : categories.where((c) => c.id == f.categoryId).firstOrNull?.name ??
                                'Category'),
                        selected: f.categoryId != null,
                        onPressed: () async {
                          final id = await _chooseCategory(context, categories, f.categoryId);
                          if (id != null) {
                            await _controller.setFilter(
                                f.copyWith(categoryId: () => id < 0 ? null : id));
                          }
                        },
                        onDeleted: f.categoryId == null
                            ? null
                            : () => _controller.setFilter(f.copyWith(categoryId: () => null)),
                      ),
                    ),
                    InputChip(
                      avatar: const Icon(Icons.date_range, size: 18),
                      label: Text(f.from == null
                          ? 'Dates'
                          : '${Dates.display(f.from)} – ${Dates.display(f.to)}'),
                      selected: f.from != null,
                      onPressed: _pickRange,
                      onDeleted: f.from == null
                          ? null
                          : () => _controller.setFilter(
                              f.copyWith(from: () => null, to: () => null)),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    state.page < 0 ? '' : '${Inr.number(state.totalElements)} transactions',
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _controller.refresh,
                  child: _buildList(state),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildList(TransactionsState state) {
    if (state.items.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          if (state.loading)
            const Padding(padding: EdgeInsets.all(48), child: Center(child: CircularProgressIndicator()))
          else if (state.error != null)
            ErrorView(message: state.error!, onRetry: _controller.refresh)
          else
            EmptyState(
              icon: Icons.receipt_long_outlined,
              message: state.filter.isEmpty
                  ? 'No transactions yet. Upload a statement to get started.'
                  : 'No transactions match these filters.',
            ),
        ],
      );
    }
    return ListView.separated(
      controller: _scroll,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 96),
      itemCount: state.items.length + 1,
      separatorBuilder: (_, _) => const Divider(height: 1, indent: 16, endIndent: 16),
      itemBuilder: (context, i) {
        if (i == state.items.length) {
          if (state.error != null) {
            return ErrorView(message: state.error!, onRetry: _controller.loadMore);
          }
          return state.hasMore || state.loading
              ? const Padding(padding: EdgeInsets.all(16), child: Center(child: CircularProgressIndicator()))
              : const SizedBox(height: 16);
        }
        final t = state.items[i];
        return TransactionTile(transaction: t, onTap: () => _edit(t));
      },
    );
  }

  Future<int?> _chooseCategory(
      BuildContext context, List<MiserCategory> categories, int? current) {
    return showModalBottomSheet<int>(
      context: context,
      showDragHandle: true,
      builder: (context) => ListView(
        shrinkWrap: true,
        children: [
          ListTile(title: const Text('All categories'), onTap: () => Navigator.pop(context, -1)),
          for (final c in categories)
            ListTile(
              title: Text(c.name ?? '#${c.id}'),
              selected: c.id == current,
              onTap: () => Navigator.pop(context, c.id),
            ),
        ],
      ),
    );
  }

  Future<void> _edit(TransactionResponse t) async {
    final updated = await showModalBottomSheet<TransactionResponse>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _EditTransactionSheet(transaction: t),
    );
    if (updated != null) _controller.replace(updated);
  }
}

class TransactionTile extends StatelessWidget {
  const TransactionTile({super.key, required this.transaction, this.onTap});

  final TransactionResponse transaction;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final t = transaction;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final credit = t.transactionType == TransactionResponseTransactionTypeEnum.CREDIT;
    final transfer = t.transfer == true;
    final amountColor = transfer ? scheme.onSurfaceVariant : (credit ? scheme.income : scheme.expense);
    final tile = ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: transfer
            ? scheme.surfaceContainerHighest
            : (credit ? scheme.income : scheme.expense).withValues(alpha: 0.12),
        child: Icon(
          transfer ? Icons.swap_horiz : (credit ? Icons.south_west : Icons.north_east),
          color: amountColor,
          size: 20,
        ),
      ),
      title: Text(
        t.merchant?.isNotEmpty == true ? t.merchant! : (t.description ?? ''),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Wrap(
        spacing: 6,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(Dates.display(t.transactionDate)),
          Text([t.category, t.subCategory].whereType<String>().join(' › ')),
          if (transfer)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text('Transfer', style: theme.textTheme.labelSmall),
            ),
        ],
      ),
      trailing: Text(
        '${credit ? '+' : '-'}${Inr.format(t.amount)}',
        style: theme.textTheme.titleSmall?.copyWith(
          color: amountColor,
          decoration: transfer ? TextDecoration.lineThrough : null,
        ),
      ),
    );
    // Transfers between own accounts don't count as income/spend: mute them.
    return transfer ? Opacity(opacity: 0.6, child: tile) : tile;
  }
}

class _EditTransactionSheet extends ConsumerStatefulWidget {
  const _EditTransactionSheet({required this.transaction});

  final TransactionResponse transaction;

  @override
  ConsumerState<_EditTransactionSheet> createState() => _EditTransactionSheetState();
}

class _EditTransactionSheetState extends ConsumerState<_EditTransactionSheet> {
  late int? _categoryId = widget.transaction.categoryId;
  late int? _subCategoryId = widget.transaction.subCategoryId;
  late bool _transfer = widget.transaction.transfer ?? false;
  bool _saving = false;
  String? _error;

  Future<void> _save() async {
    final t = widget.transaction;
    final api = ref.read(miserApiProvider).getTransactionControllerApi();
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      var updated = t;
      if (_categoryId != null &&
          (_categoryId != t.categoryId || _subCategoryId != t.subCategoryId)) {
        updated = (await api.updateCategory(
          id: t.id!,
          updateTransactionCategoryRequest: UpdateTransactionCategoryRequest(
            categoryId: _categoryId!,
            subCategoryId: _subCategoryId,
          ),
        ))
            .data!;
      }
      if (_transfer != (t.transfer ?? false)) {
        updated = (await api.updateTransfer(id: t.id!, requestBody: {'transfer': _transfer})).data!;
      }
      if (mounted) Navigator.of(context).pop(updated);
    } catch (e) {
      setState(() {
        _saving = false;
        _error = describeError(e);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.transaction;
    final categories = ref.watch(categoriesProvider);
    final subs = _categoryId == null ? null : ref.watch(subCategoriesProvider(_categoryId!));
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 0, 24, 24 + MediaQuery.viewInsetsOf(context).bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(t.merchant ?? t.description ?? 'Transaction', style: theme.textTheme.titleLarge),
          const SizedBox(height: 4),
          Text('${Dates.display(t.transactionDate)} · ${Inr.format(t.amount)}'),
          if (t.description != null && t.description != t.merchant)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(t.description!, style: theme.textTheme.bodySmall),
            ),
          const SizedBox(height: 16),
          AsyncValueView(
            value: categories,
            compact: true,
            data: (list) => DropdownButtonFormField<int>(
              initialValue: list.any((c) => c.id == _categoryId) ? _categoryId : null,
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'Category'),
              items: [
                for (final c in list) DropdownMenuItem(value: c.id, child: Text(c.name ?? '#${c.id}')),
              ],
              onChanged: (v) => setState(() {
                _categoryId = v;
                _subCategoryId = null;
              }),
            ),
          ),
          const SizedBox(height: 12),
          if (subs != null)
            AsyncValueView(
              value: subs,
              compact: true,
              data: (list) => list.isEmpty
                  ? const SizedBox.shrink()
                  : DropdownButtonFormField<int?>(
                      key: ValueKey(_categoryId),
                      initialValue: list.any((s) => s.id == _subCategoryId) ? _subCategoryId : null,
                      isExpanded: true,
                      decoration: const InputDecoration(labelText: 'Subcategory (optional)'),
                      items: [
                        const DropdownMenuItem<int?>(value: null, child: Text('None')),
                        for (final s in list)
                          DropdownMenuItem<int?>(value: s.id, child: Text(s.name ?? '#${s.id}')),
                      ],
                      onChanged: (v) => setState(() => _subCategoryId = v),
                    ),
            ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Transfer between my accounts'),
            subtitle: const Text('Excluded from income and spending totals'),
            value: _transfer,
            onChanged: (v) => setState(() => _transfer = v),
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
            ),
          FilledButton(onPressed: _saving ? null : _save, child: const Text('Save')),
        ],
      ),
    );
  }
}
