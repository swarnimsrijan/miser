import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:miser_app/core/auth/auth_service.dart';

/// In-memory [AuthService] for tests.
class FakeAuthService implements AuthService {
  FakeAuthService({AuthState initial = const AuthState.signedOut(), this.token = 'token-1'})
      : _state = ValueNotifier(initial);

  final ValueNotifier<AuthState> _state;
  String? token;
  String? refreshedToken = 'token-2';
  int refreshCalls = 0;
  int unauthorizedCalls = 0;
  int signInCalls = 0;

  @override
  ValueListenable<AuthState> get state => _state;

  set value(AuthState s) => _state.value = s;

  @override
  Future<void> init() async {}

  @override
  Future<void> signIn() async => signInCalls++;

  @override
  Future<void> signOut() async => _state.value = const AuthState.signedOut();

  @override
  Future<String?> accessToken({bool forceRefresh = false}) async {
    if (forceRefresh) {
      refreshCalls++;
      token = refreshedToken;
    }
    return token;
  }

  @override
  Future<void> handleUnauthorized() async {
    unauthorizedCalls++;
    token = null;
    _state.value = const AuthState.signedOut(error: 'expired');
  }
}

class RecordedRequest {
  RecordedRequest(this.options, this.body);

  final RequestOptions options;
  final String body;

  Uri get uri => options.uri;
}

typedef FakeHandler = Object? Function(RecordedRequest request);

/// Replaces dio's network layer. The handler returns a JSON-able body, or a
/// [FakeResponse] to control the status code.
class FakeAdapter implements HttpClientAdapter {
  FakeAdapter(this.handler);

  final FakeHandler handler;
  final List<RecordedRequest> requests = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final bytes = <int>[];
    if (requestStream != null) {
      await for (final chunk in requestStream) {
        bytes.addAll(chunk);
      }
    }
    final request = RecordedRequest(options, utf8.decode(bytes, allowMalformed: true));
    requests.add(request);
    final result = handler(request);
    final response = result is FakeResponse ? result : FakeResponse(200, result);
    return ResponseBody.fromString(
      response.body == null ? '' : jsonEncode(response.body),
      response.status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

class FakeResponse {
  const FakeResponse(this.status, [this.body]);

  final int status;
  final Object? body;
}

Dio fakeDio(FakeAdapter adapter) =>
    Dio(BaseOptions(baseUrl: 'http://localhost:8080'))..httpClientAdapter = adapter;
