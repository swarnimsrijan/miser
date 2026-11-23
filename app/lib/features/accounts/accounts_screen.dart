import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:miser_api/miser_api.dart';

import '../../core/api/api_error.dart';
import '../../core/api/api_providers.dart';
import '../../core/formatting/formatters.dart';
import '../../core/widgets/common.dart';
import 'accounts_providers.dart';

class AccountsScreen extends ConsumerWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(accountsProvider);
    final cards = ref.watch(creditCardsProvider);
    return PageScaffold(
      title: 'Accounts & cards',
      onRefresh: () async {
        ref
          ..invalidate(accountsProvider)
          ..invalidate(creditCardsProvider)
          ..invalidate(banksProvider);
      },
      children: [
        SectionCard(
          title: 'Bank accounts',
          trailing: FilledButton.tonalIcon(
            onPressed: () => _addAccount(context, ref),
            icon: const Icon(Icons.add),
            label: const Text('Add'),
          ),
          child: AsyncValueView(
            value: accounts,
            compact: true,
            onRetry: () => ref.invalidate(accountsProvider),
            data: (list) => list.isEmpty
                ? const EmptyState(
                    icon: Icons.account_balance_outlined,
                    message: 'Add a bank account to upload its statements.',
                  )
                : Column(children: [
                    for (final a in list)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const CircleAvatar(child: Icon(Icons.account_balance)),
                        title: Text(accountLabel(a)),
                        subtitle: Text([
                          a.bankName,
                          a.accountType?.value,
                          a.currency,
                        ].whereType<String>().join(' · ')),
                        trailing: a.status == null ? null : Chip(label: Text(a.status!)),
                      ),
                  ]),
          ),
        ),
        SectionCard(
          title: 'Credit cards',
          trailing: FilledButton.tonalIcon(
            onPressed: () => _addCard(context, ref),
            icon: const Icon(Icons.add),
            label: const Text('Add'),
          ),
          child: AsyncValueView(
            value: cards,
            compact: true,
            onRetry: () => ref.invalidate(creditCardsProvider),
            data: (list) => list.isEmpty
                ? const EmptyState(
                    icon: Icons.credit_card,
                    message: 'Add a credit card to upload its statements.',
                  )
                : Column(children: [
                    for (final c in list)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const CircleAvatar(child: Icon(Icons.credit_card)),
                        title: Text(cardLabel(c)),
                        subtitle: Text([
                          c.bankName,
                          if (c.creditLimit != null) 'Limit ${Inr.format(c.creditLimit, decimals: false)}',
                          if (c.billingDate != null) 'Bills on ${c.billingDate}',
                          if (c.dueDate != null) 'Due ${c.dueDate}',
                        ].whereType<String>().join(' · ')),
                        trailing: c.status == null ? null : Chip(label: Text(c.status!)),
                      ),
                  ]),
          ),
        ),
      ],
    );
  }

  Future<void> _addAccount(BuildContext context, WidgetRef ref) async {
    final created = await showDialog<bool>(
      context: context,
      builder: (_) => const _AccountDialog(),
    );
    if (created == true) ref.invalidate(accountsProvider);
  }

  Future<void> _addCard(BuildContext context, WidgetRef ref) async {
    final created = await showDialog<bool>(
      context: context,
      builder: (_) => const _CardDialog(),
    );
    if (created == true) ref.invalidate(creditCardsProvider);
  }
}

class _BankField extends ConsumerWidget {
  const _BankField({required this.value, required this.onChanged});

  final int? value;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final banks = ref.watch(banksProvider);
    return banks.when(
      loading: () => const LinearProgressIndicator(),
      error: (e, _) => Text(describeError(e), style: TextStyle(color: Theme.of(context).colorScheme.error)),
      data: (list) => DropdownButtonFormField<int>(
        initialValue: value,
        isExpanded: true,
        decoration: const InputDecoration(labelText: 'Bank'),
        items: [
          for (final b in list) DropdownMenuItem(value: b.id, child: Text(b.name ?? '#${b.id}')),
        ],
        validator: (v) => v == null ? 'Choose a bank' : null,
        onChanged: onChanged,
      ),
    );
  }
}

class _AccountDialog extends ConsumerStatefulWidget {
  const _AccountDialog();

  @override
  ConsumerState<_AccountDialog> createState() => _AccountDialogState();
}

class _AccountDialogState extends ConsumerState<_AccountDialog> {
  final _form = GlobalKey<FormState>();
  final _nickname = TextEditingController();
  final _masked = TextEditingController();
  final _currency = TextEditingController(text: 'INR');
  int? _bankId;
  CreateAccountRequestAccountTypeEnum _type = CreateAccountRequestAccountTypeEnum.SAVINGS;
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _nickname.dispose();
    _masked.dispose();
    _currency.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref.read(miserApiProvider).getAccountControllerApi().create2(
            createAccountRequest: CreateAccountRequest(
              bankId: _bankId!,
              nickname: _nickname.text.trim().isEmpty ? null : _nickname.text.trim(),
              accountNumberMasked: _masked.text.trim().isEmpty ? null : _masked.text.trim(),
              accountType: _type,
              currency: _currency.text.trim().toUpperCase(),
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
      title: const Text('Add bank account'),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _BankField(value: _bankId, onChanged: (v) => setState(() => _bankId = v)),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _nickname,
                  decoration: const InputDecoration(labelText: 'Nickname (optional)'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _masked,
                  decoration: const InputDecoration(
                    labelText: 'Last 4 digits (optional)',
                    hintText: 'XXXX1234',
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<CreateAccountRequestAccountTypeEnum>(
                  initialValue: _type,
                  decoration: const InputDecoration(labelText: 'Type'),
                  items: [
                    for (final t in CreateAccountRequestAccountTypeEnum.values)
                      DropdownMenuItem(value: t, child: Text(t.value)),
                  ],
                  onChanged: (v) => setState(() => _type = v ?? _type),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _currency,
                  decoration: const InputDecoration(labelText: 'Currency'),
                  validator: (v) => (v ?? '').trim().isEmpty ? 'Required' : null,
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
        FilledButton(onPressed: _saving ? null : _save, child: const Text('Add')),
      ],
    );
  }
}

class _CardDialog extends ConsumerStatefulWidget {
  const _CardDialog();

  @override
  ConsumerState<_CardDialog> createState() => _CardDialogState();
}

class _CardDialogState extends ConsumerState<_CardDialog> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _masked = TextEditingController();
  final _limit = TextEditingController();
  final _billing = TextEditingController();
  final _due = TextEditingController();
  final _currency = TextEditingController(text: 'INR');
  int? _bankId;
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    for (final c in [_name, _masked, _limit, _billing, _due, _currency]) {
      c.dispose();
    }
    super.dispose();
  }

  String? _dayValidator(String? v) {
    if (v == null || v.trim().isEmpty) return null;
    final d = int.tryParse(v.trim());
    return d == null || d < 1 || d > 31 ? '1–31' : null;
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref.read(miserApiProvider).getCreditCardControllerApi().create1(
            createCreditCardRequest: CreateCreditCardRequest(
              bankId: _bankId!,
              cardName: _name.text.trim(),
              maskedNumber: _masked.text.trim().isEmpty ? null : _masked.text.trim(),
              creditLimit: num.tryParse(_limit.text.trim()),
              billingDate: int.tryParse(_billing.text.trim()),
              dueDate: int.tryParse(_due.text.trim()),
              currency: _currency.text.trim().toUpperCase(),
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
    final digits = [FilteringTextInputFormatter.digitsOnly];
    return AlertDialog(
      title: const Text('Add credit card'),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _BankField(value: _bankId, onChanged: (v) => setState(() => _bankId = v)),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _name,
                  decoration: const InputDecoration(labelText: 'Card name'),
                  validator: (v) => (v ?? '').trim().isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _masked,
                  decoration: const InputDecoration(labelText: 'Last 4 digits (optional)'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _limit,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Credit limit (optional)', prefixText: '₹ '),
                  validator: (v) =>
                      (v ?? '').trim().isEmpty || num.tryParse(v!.trim()) != null ? null : 'Not a number',
                ),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(
                    child: TextFormField(
                      controller: _billing,
                      inputFormatters: digits,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Billing day'),
                      validator: _dayValidator,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _due,
                      inputFormatters: digits,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Due day'),
                      validator: _dayValidator,
                    ),
                  ),
                ]),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _currency,
                  decoration: const InputDecoration(labelText: 'Currency'),
                  validator: (v) => (v ?? '').trim().isEmpty ? 'Required' : null,
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
        FilledButton(onPressed: _saving ? null : _save, child: const Text('Add')),
      ],
    );
  }
}
