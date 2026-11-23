import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miser_api/miser_api.dart';

import '../../core/api/api_error.dart';
import '../../core/api/api_providers.dart';

@immutable
class TransactionFilter {
  const TransactionFilter({this.q, this.type, this.categoryId, this.from, this.to});

  final String? q;

  /// `CREDIT` or `DEBIT`.
  final String? type;
  final int? categoryId;
  final DateTime? from;
  final DateTime? to;

  bool get isEmpty =>
      (q == null || q!.isEmpty) && type == null && categoryId == null && from == null && to == null;

  TransactionFilter copyWith({
    ValueGetter<String?>? q,
    ValueGetter<String?>? type,
    ValueGetter<int?>? categoryId,
    ValueGetter<DateTime?>? from,
    ValueGetter<DateTime?>? to,
  }) =>
      TransactionFilter(
        q: q != null ? q() : this.q,
        type: type != null ? type() : this.type,
        categoryId: categoryId != null ? categoryId() : this.categoryId,
        from: from != null ? from() : this.from,
        to: to != null ? to() : this.to,
      );
}

@immutable
class TransactionsState {
  const TransactionsState({
    this.filter = const TransactionFilter(),
    this.items = const [],
    this.page = -1,
    this.totalPages = 1,
    this.totalElements = 0,
    this.loading = false,
    this.error,
  });

  final TransactionFilter filter;
  final List<TransactionResponse> items;

  /// Last loaded page (0-based), -1 before the first load.
  final int page;
  final int totalPages;
  final int totalElements;
  final bool loading;
  final String? error;

  bool get hasMore => page + 1 < totalPages;

  TransactionsState copyWith({
    TransactionFilter? filter,
    List<TransactionResponse>? items,
    int? page,
    int? totalPages,
    int? totalElements,
    bool? loading,
    ValueGetter<String?>? error,
  }) =>
      TransactionsState(
        filter: filter ?? this.filter,
        items: items ?? this.items,
        page: page ?? this.page,
        totalPages: totalPages ?? this.totalPages,
        totalElements: totalElements ?? this.totalElements,
        loading: loading ?? this.loading,
        error: error != null ? error() : this.error,
      );
}

/// Paged transaction search with infinite scrolling.
class TransactionsController extends Notifier<TransactionsState> {
  static const pageSize = 50;
  int _generation = 0;

  @override
  TransactionsState build() {
    Future.microtask(loadMore);
    return const TransactionsState(loading: true);
  }

  Future<void> setFilter(TransactionFilter filter) async {
    _generation++;
    state = TransactionsState(filter: filter, loading: true);
    await _load(0);
  }

  Future<void> refresh() => setFilter(state.filter);

  Future<void> loadMore() async {
    if (state.page >= 0 && (state.loading || !state.hasMore)) return;
    if (state.page < 0 && state.items.isNotEmpty) return;
    await _load(state.page + 1);
  }

  Future<void> _load(int page) async {
    final generation = _generation;
    state = state.copyWith(loading: true, error: () => null);
    final f = state.filter;
    try {
      final res = await ref.read(miserApiProvider).getTransactionControllerApi().search(
            q: (f.q == null || f.q!.isEmpty) ? null : f.q,
            type: f.type,
            categoryId: f.categoryId,
            from: f.from,
            to: f.to,
            page: page,
            size: pageSize,
          );
      if (generation != _generation) return; // filter changed meanwhile
      final data = res.data;
      state = state.copyWith(
        items: page == 0 ? [...?data?.content] : [...state.items, ...?data?.content],
        page: page,
        totalPages: data?.totalPages ?? 0,
        totalElements: data?.totalElements ?? 0,
        loading: false,
      );
    } catch (e) {
      if (generation != _generation) return;
      state = state.copyWith(loading: false, error: () => describeError(e));
    }
  }

  void replace(TransactionResponse updated) {
    state = state.copyWith(items: [
      for (final t in state.items) t.id == updated.id ? updated : t,
    ]);
  }
}

final transactionsControllerProvider =
    NotifierProvider.autoDispose<TransactionsController, TransactionsState>(
  TransactionsController.new,
);
