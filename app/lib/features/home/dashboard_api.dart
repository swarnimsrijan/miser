import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api/api_providers.dart';
import 'dashboard_models.dart';

/// Hand-written client for /api/dashboard/*. The spec types these responses as
/// untyped maps, and the generated dart-dio client cannot deserialize
/// `Map<String, Object?>` (its type-string parser chokes on the space), so we
/// call them on the shared [Dio] (same auth interceptor) and map to
/// [DashboardSummary] & co. ourselves.
class DashboardApi {
  DashboardApi(this._dio);

  final Dio _dio;

  Map<String, Object?> _map(Object? data) =>
      data is Map ? data.cast<String, Object?>() : const <String, Object?>{};

  List<Map<String, Object?>> _list(Object? data) => data is List
      ? [for (final e in data) if (e is Map) e.cast<String, Object?>()]
      : const [];

  Map<String, Object?> _range(DateTime? from, DateTime? to) => {
        'from': ?from,
        'to': ?to,
      };

  Future<DashboardSummary> summary({DateTime? from, DateTime? to}) async {
    final res = await _dio.get<Object?>('/api/dashboard/summary', queryParameters: _range(from, to));
    return DashboardSummary.fromJson(_map(res.data));
  }

  Future<NetWorth> networth() async {
    final res = await _dio.get<Object?>('/api/dashboard/networth');
    return NetWorth.fromJson(_map(res.data));
  }

  Future<List<MonthlyFlow>> monthly({DateTime? from, DateTime? to}) async {
    final res = await _dio.get<Object?>('/api/dashboard/monthly', queryParameters: _range(from, to));
    return _list(res.data).map(MonthlyFlow.fromJson).toList();
  }

  Future<List<CategorySpend>> byCategory({DateTime? from, DateTime? to}) async {
    final res = await _dio.get<Object?>('/api/dashboard/category', queryParameters: _range(from, to));
    return _list(res.data).map(CategorySpend.fromJson).toList();
  }
}

final dashboardApiProvider = Provider<DashboardApi>((ref) => DashboardApi(ref.watch(dioProvider)));
