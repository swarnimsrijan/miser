import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miser_api/miser_api.dart';

import '../../core/api/api_error.dart';
import '../../core/api/api_providers.dart';

/// The statement is encrypted and the server needs (a different) password.
class StatementPasswordException implements Exception {
  const StatementPasswordException({required this.incorrect, required this.message});

  /// `true` for PASSWORD_INCORRECT, `false` for PASSWORD_REQUIRED.
  final bool incorrect;
  final String message;

  @override
  String toString() => message;
}

/// Uploads a statement as multipart/form-data. The password, when present,
/// travels as a form field (never in the URL: the backend rejects that and
/// query strings end up in access logs).
class StatementUploader {
  StatementUploader(this._api);

  final StatementControllerApi _api;

  Future<StatementResponse> upload({
    required List<int> bytes,
    required String filename,
    int? accountId,
    int? creditCardId,
    String? password,
    ProgressCallback? onSendProgress,
  }) async {
    assert((accountId == null) != (creditCardId == null),
        'Exactly one of accountId / creditCardId is required');
    try {
      final res = await _api.upload(
        file: MultipartFile.fromBytes(bytes, filename: filename),
        accountId: accountId,
        creditCardId: creditCardId,
        password: (password == null || password.isEmpty) ? null : password,
        onSendProgress: onSendProgress,
      );
      return res.data!;
    } catch (e) {
      final error = ApiException.from(e);
      switch (error.code) {
        case 'PASSWORD_REQUIRED':
          throw StatementPasswordException(incorrect: false, message: error.message);
        case 'PASSWORD_INCORRECT':
          throw StatementPasswordException(incorrect: true, message: error.message);
      }
      throw error;
    }
  }
}

final statementUploaderProvider = Provider<StatementUploader>(
  (ref) => StatementUploader(ref.watch(miserApiProvider).getStatementControllerApi()),
);

/// Asks the user for the statement password. Returns null if they cancel.
typedef PasswordPrompt = Future<String?> Function({required bool incorrect});

/// Uploads, and whenever the server answers PASSWORD_REQUIRED or
/// PASSWORD_INCORRECT, asks for the password and retries with it.
///
/// Returns null if the user cancels the password prompt. Other errors are
/// rethrown as [ApiException].
Future<StatementResponse?> uploadWithPasswordRetry({
  required StatementUploader uploader,
  required List<int> bytes,
  required String filename,
  int? accountId,
  int? creditCardId,
  required PasswordPrompt promptPassword,
  ProgressCallback? onSendProgress,
  int maxAttempts = 5,
}) async {
  String? password;
  for (var attempt = 0; ; attempt++) {
    try {
      return await uploader.upload(
        bytes: bytes,
        filename: filename,
        accountId: accountId,
        creditCardId: creditCardId,
        password: password,
        onSendProgress: onSendProgress,
      );
    } on StatementPasswordException catch (e) {
      if (attempt + 1 >= maxAttempts) {
        throw ApiException(status: 422, message: e.message, code: 'PASSWORD_INCORRECT');
      }
      // A "required" answer after we already sent one means it was wrong.
      password = await promptPassword(incorrect: e.incorrect || password != null);
      if (password == null) return null;
    }
  }
}
