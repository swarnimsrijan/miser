import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miser_api/miser_api.dart';

import '../../core/api/api_providers.dart';

final banksProvider = FutureProvider.autoDispose<List<Bank>>((ref) async {
  final res = await ref.watch(miserApiProvider).getBankControllerApi().getAll4();
  return [...?res.data]..sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));
});

final accountsProvider = FutureProvider.autoDispose<List<AccountResponse>>((ref) async {
  final res = await ref.watch(miserApiProvider).getAccountControllerApi().getAll1();
  return res.data ?? const [];
});

final creditCardsProvider = FutureProvider.autoDispose<List<CreditCardResponse>>((ref) async {
  final res = await ref.watch(miserApiProvider).getCreditCardControllerApi().getAll();
  return res.data ?? const [];
});

String accountLabel(AccountResponse a) {
  final name = a.nickname?.isNotEmpty == true ? a.nickname! : (a.bankName ?? 'Account');
  final masked = a.accountNumberMasked?.isNotEmpty == true ? ' · ${a.accountNumberMasked}' : '';
  return '$name$masked';
}

String cardLabel(CreditCardResponse c) {
  final masked = c.maskedNumber?.isNotEmpty == true ? ' · ${c.maskedNumber}' : '';
  return '${c.cardName ?? 'Card'}$masked';
}
