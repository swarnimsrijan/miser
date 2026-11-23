import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miser_app/core/api/auth_interceptor.dart';
import 'package:miser_app/core/auth/auth_service.dart';

import '../helpers/fakes.dart';

void main() {
  late FakeAuthService auth;

  Dio build(FakeAdapter adapter) {
    final dio = fakeDio(adapter);
    dio.interceptors.add(AuthInterceptor(auth, dio));
    return dio;
  }

  setUp(() => auth = FakeAuthService(initial: const AuthState(AuthStatus.signedIn)));

  test('sends the bearer token and formats DateTime query params', () async {
    final adapter = FakeAdapter((_) => {'ok': true});
    await build(adapter).get<dynamic>('/api/transactions', queryParameters: {
      'from': DateTime(2026, 4, 1),
      'page': 0,
    });
    final req = adapter.requests.single;
    expect(req.options.headers['Authorization'], 'Bearer token-1');
    expect(req.uri.queryParameters['from'], '2026-04-01');
  });

  test('on 401 refreshes the token once and retries', () async {
    final adapter = FakeAdapter((r) =>
        r.options.headers['Authorization'] == 'Bearer token-2' ? {'ok': true} : const FakeResponse(401));
    final res = await build(adapter).get<dynamic>('/api/me');
    expect(res.statusCode, 200);
    expect(auth.refreshCalls, 1);
    expect(adapter.requests, hasLength(2));
    expect(auth.unauthorizedCalls, 0);
  });

  test('signs out when the retried request is still 401', () async {
    final adapter = FakeAdapter((_) => const FakeResponse(401));
    await expectLater(
      build(adapter).get<dynamic>('/api/me'),
      throwsA(isA<DioException>().having((e) => e.response?.statusCode, 'status', 401)),
    );
    expect(auth.unauthorizedCalls, 1);
    expect(auth.state.value.status, AuthStatus.signedOut);
  });

  test('signs out when the token cannot be refreshed', () async {
    auth.refreshedToken = null;
    final adapter = FakeAdapter((_) => const FakeResponse(401));
    await expectLater(build(adapter).get<dynamic>('/api/me'), throwsA(isA<DioException>()));
    expect(adapter.requests, hasLength(1));
    expect(auth.unauthorizedCalls, 1);
  });

  test('non-401 errors pass through untouched', () async {
    final adapter = FakeAdapter((_) => const FakeResponse(500, {'status': 500, 'message': 'boom'}));
    await expectLater(build(adapter).get<dynamic>('/api/me'), throwsA(isA<DioException>()));
    expect(auth.refreshCalls, 0);
    expect(auth.unauthorizedCalls, 0);
  });
}
