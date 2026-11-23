import 'package:dio/dio.dart';

import '../auth/auth_service.dart';
import '../formatting/formatters.dart';

/// Adds `Authorization: Bearer <token>` to every request, retries once with a
/// force-refreshed token on 401, and signs the user out if that fails too.
///
/// Also serialises [DateTime] query parameters as `yyyy-MM-dd` (what Spring's
/// `LocalDate` binding expects; the generated client passes DateTime as-is).
///
/// Deliberately never logs requests, headers or bodies: they carry tokens and
/// statement passwords.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._auth, this._dio);

  final AuthService _auth;
  final Dio _dio;

  static const _retriedKey = 'miser.authRetried';

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.queryParameters = {
      for (final e in options.queryParameters.entries)
        e.key: e.value is DateTime ? Dates.iso(e.value as DateTime) : e.value,
    };
    final token = await _auth.accessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final request = err.requestOptions;
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }
    if (request.extra[_retriedKey] == true) {
      await _auth.handleUnauthorized();
      return handler.next(err);
    }
    final fresh = await _auth.accessToken(forceRefresh: true);
    if (fresh == null) {
      await _auth.handleUnauthorized();
      return handler.next(err);
    }
    request.extra[_retriedKey] = true;
    final data = request.data;
    if (data is FormData) {
      // A multipart body can only be streamed once.
      request.data = data.clone();
    }
    try {
      final response = await _dio.fetch<dynamic>(request);
      handler.resolve(response);
    } on DioException catch (e) {
      handler.next(e);
    }
  }
}
