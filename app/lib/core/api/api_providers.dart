import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miser_api/miser_api.dart';

import '../auth/auth_providers.dart';
import '../config/app_config.dart';
import 'auth_interceptor.dart';

final appConfigProvider = Provider<AppConfig>((_) => AppConfig.fromEnvironment());

/// The single [Dio] instance used by the generated client.
final dioProvider = Provider<Dio>((ref) {
  final config = ref.watch(appConfigProvider);
  final dio = Dio(
    BaseOptions(
      baseUrl: config.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 60),
      sendTimeout: const Duration(minutes: 2),
    ),
  );
  dio.interceptors.add(AuthInterceptor(ref.watch(authServiceProvider), dio));
  ref.onDispose(dio.close);
  return dio;
});

/// Generated OpenAPI client (packages/miser_api). Passing an explicit
/// interceptor list stops it from installing its own (unused) auth ones.
final miserApiProvider = Provider<MiserApi>(
  (ref) => MiserApi(dio: ref.watch(dioProvider), interceptors: const []),
);
