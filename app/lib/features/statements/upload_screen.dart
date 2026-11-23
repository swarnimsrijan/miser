import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:miser_api/miser_api.dart';

import '../../core/api/api_error.dart';
import '../../core/api/api_providers.dart';
import '../../core/formatting/formatters.dart';
import '../../core/widgets/common.dart';
import '../accounts/accounts_providers.dart';
import '../home/home_providers.dart';
import 'statement_password_dialog.dart';
import 'statement_uploader.dart';

final statementsProvider = FutureProvider.autoDispose<List<StatementResponse>>((ref) async {
  final res = await ref.watch(miserApiProvider).getStatementControllerApi().getAll2();
  return [...?res.data]..sort((a, b) =>
      (b.uploadedAt ?? DateTime(0)).compareTo(a.uploadedAt ?? DateTime(0)));
});

enum _Target { account, card }

class _PickedFile {
  const _PickedFile(this.name, this.bytes);

  final String name;
  final List<int> bytes;
}

class UploadScreen extends ConsumerStatefulWidget {
  const UploadScreen({super.key});

  @override
  ConsumerState<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends ConsumerState<UploadScreen> {
  _Target _target = _Target.account;
  int? _accountId;
  int? _cardId;
  _PickedFile? _file;
  bool _uploading = false;
  double? _progress;

  Future<void> _pick() async {
    try {
      final picked = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: const ['pdf', 'csv', 'xlsx'],
      );
      if (picked == null) return;
      // Read into memory: works the same on web (no file paths there).
      final bytes = await picked.readAsBytes();
      setState(() => _file = _PickedFile(picked.name, bytes));
    } catch (e) {
      if (mounted) showSnack(context, 'Could not open the file.', error: true);
    }
  }

  bool get _canUpload =>
      !_uploading &&
      _file != null &&
      (_target == _Target.account ? _accountId != null : _cardId != null);

  Future<void> _upload() async {
    final file = _file!;
    setState(() {
      _uploading = true;
      _progress = null;
    });
    try {
      final result = await uploadWithPasswordRetry(
        uploader: ref.read(statementUploaderProvider),
        bytes: file.bytes,
        filename: file.name,
        accountId: _target == _Target.account ? _accountId : null,
        creditCardId: _target == _Target.card ? _cardId : null,
        onSendProgress: (sent, total) {
          if (total > 0 && mounted) setState(() => _progress = sent / total);
        },
        promptPassword: ({required incorrect}) async {
          if (!mounted) return null;
          setState(() => _progress = null);
          return showStatementPasswordDialog(context, incorrect: incorrect, filename: file.name);
        },
      );
      if (!mounted) return;
      if (result == null) {
        showSnack(context, 'Upload cancelled.');
      } else {
        showSnack(
          context,
          'Imported ${result.transactionCount ?? 0} transactions'
          '${result.issuer != null ? ' from ${result.issuer}' : ''}.',
        );
        setState(() => _file = null);
        ref
          ..invalidate(statementsProvider)
          ..invalidate(dashboardSummaryProvider)
          ..invalidate(monthlyFlowProvider)
          ..invalidate(categorySpendProvider)
          ..invalidate(netWorthProvider)
          ..invalidate(tipsProvider);
      }
    } catch (e) {
      if (mounted) showSnack(context, describeError(e), error: true);
    } finally {
      if (mounted) {
        setState(() {
          _uploading = false;
          _progress = null;
        });
      }
    }
  }

  Future<void> _delete(StatementResponse s) async {
    final ok = await confirmDialog(
      context,
      title: 'Delete statement?',
      message: 'This removes the statement and its ${s.transactionCount ?? 0} '
          'imported transactions. This cannot be undone.',
    );
    if (!ok || !mounted) return;
    try {
      await ref.read(miserApiProvider).getStatementControllerApi().delete2(id: s.id!);
      ref.invalidate(statementsProvider);
      if (mounted) showSnack(context, 'Statement deleted.');
    } catch (e) {
      if (mounted) showSnack(context, describeError(e), error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final accounts = ref.watch(accountsProvider);
    final cards = ref.watch(creditCardsProvider);
    final statements = ref.watch(statementsProvider);
    final accountNames = {for (final a in accounts.value ?? <AccountResponse>[]) a.id: accountLabel(a)};
    final cardNames = {for (final c in cards.value ?? <CreditCardResponse>[]) c.id: cardLabel(c)};

    return PageScaffold(
      title: 'Upload statement',
      maxWidth: 900,
      onRefresh: () async => ref.invalidate(statementsProvider),
      children: [
        SectionCard(
          title: 'New upload',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SegmentedButton<_Target>(
                segments: const [
                  ButtonSegment(
                    value: _Target.account,
                    icon: Icon(Icons.account_balance),
                    label: Text('Bank account'),
                  ),
                  ButtonSegment(
                    value: _Target.card,
                    icon: Icon(Icons.credit_card),
                    label: Text('Credit card'),
                  ),
                ],
                selected: {_target},
                onSelectionChanged: _uploading ? null : (s) => setState(() => _target = s.first),
              ),
              const SizedBox(height: 12),
              if (_target == _Target.account)
                AsyncValueView(
                  value: accounts,
                  compact: true,
                  onRetry: () => ref.invalidate(accountsProvider),
                  data: (list) => list.isEmpty
                      ? const Text('No bank accounts yet. Add one under Accounts.')
                      : DropdownButtonFormField<int>(
                          initialValue: _accountId,
                          isExpanded: true,
                          decoration: const InputDecoration(labelText: 'Account'),
                          items: [
                            for (final a in list)
                              DropdownMenuItem(value: a.id, child: Text(accountLabel(a))),
                          ],
                          onChanged: _uploading ? null : (v) => setState(() => _accountId = v),
                        ),
                )
              else
                AsyncValueView(
                  value: cards,
                  compact: true,
                  onRetry: () => ref.invalidate(creditCardsProvider),
                  data: (list) => list.isEmpty
                      ? const Text('No credit cards yet. Add one under Accounts.')
                      : DropdownButtonFormField<int>(
                          initialValue: _cardId,
                          isExpanded: true,
                          decoration: const InputDecoration(labelText: 'Card'),
                          items: [
                            for (final c in list)
                              DropdownMenuItem(value: c.id, child: Text(cardLabel(c))),
                          ],
                          onChanged: _uploading ? null : (v) => setState(() => _cardId = v),
                        ),
                ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _uploading ? null : _pick,
                icon: const Icon(Icons.attach_file),
                label: Text(
                  _file == null
                      ? 'Choose PDF, CSV or XLSX'
                      : '${_file!.name} (${(_file!.bytes.length / 1024).toStringAsFixed(0)} KB)',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 12),
              if (_uploading) ...[
                LinearProgressIndicator(value: _progress),
                const SizedBox(height: 12),
              ],
              FilledButton.icon(
                key: const Key('upload-button'),
                onPressed: _canUpload ? _upload : null,
                icon: const Icon(Icons.cloud_upload),
                label: Text(_uploading ? 'Uploading…' : 'Upload'),
              ),
            ],
          ),
        ),
        SectionCard(
          title: 'Past statements',
          child: AsyncValueView(
            value: statements,
            compact: true,
            onRetry: () => ref.invalidate(statementsProvider),
            data: (list) => list.isEmpty
                ? const EmptyState(icon: Icons.description_outlined, message: 'No statements uploaded yet.')
                : Column(children: [
                    for (final s in list)
                      _StatementTile(
                        statement: s,
                        target: s.accountId != null
                            ? accountNames[s.accountId] ?? 'Account #${s.accountId}'
                            : cardNames[s.creditCardId] ?? 'Card #${s.creditCardId}',
                        onDelete: () => _delete(s),
                      ),
                  ]),
          ),
        ),
      ],
    );
  }
}

class _StatementTile extends StatelessWidget {
  const _StatementTile({required this.statement, required this.target, required this.onDelete});

  final StatementResponse statement;
  final String target;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final s = statement;
    final theme = Theme.of(context);
    final failed = (s.status ?? '').toUpperCase().contains('FAIL');
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        child: Text(s.statementType?.value ?? '?', style: theme.textTheme.labelSmall),
      ),
      title: Text('${s.issuer ?? 'Unknown issuer'} · $target'),
      subtitle: Text([
        if (s.fromDate != null) '${Dates.display(s.fromDate)} – ${Dates.display(s.toDate)}',
        '${s.transactionCount ?? 0} transactions',
        if (s.parserLayout != null) 'Layout: ${s.parserLayout}',
        if (s.uploadedAt != null) 'Uploaded ${Dates.display(s.uploadedAt)}',
      ].join(' · ')),
      isThreeLine: true,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (s.status != null)
            Chip(
              label: Text(s.status!),
              backgroundColor: failed ? theme.colorScheme.errorContainer : null,
            ),
          IconButton(
            tooltip: 'Delete',
            icon: const Icon(Icons.delete_outline),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
