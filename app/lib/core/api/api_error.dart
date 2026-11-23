import 'package:dio/dio.dart';

/// The backend's error body: `{status, message}` plus an optional `code`
/// (e.g. `PASSWORD_REQUIRED`, `PASSWORD_INCORRECT` for locked statements).
class ApiException implements Exception {
  const ApiException({this.status, required this.message, this.code});

  /// Normalises any error thrown by the API layer.
  factory ApiException.from(Object error) {
    if (error is ApiException) return error;
    if (error is DioException) {
      final status = error.response?.statusCode;
      final data = error.response?.data;
      if (data is Map) {
        final message = data['message'];
        final code = data['code'];
        return ApiException(
          status: status,
          message: message is String && message.isNotEmpty
              ? message
              : _fallback(status),
          code: code is String ? code : null,
        );
      }
      switch (error.type) {
        case DioExceptionType.connectionError:
        case DioExceptionType.connectionTimeout:
          return const ApiException(
            message: 'Cannot reach the Miser server. Is it running?',
          );
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
          return const ApiException(message: 'The server took too long to respond.');
        default:
          return ApiException(status: status, message: _fallback(status));
      }
    }
    return ApiException(message: 'Something went wrong ($error)');
  }

  final int? status;
  final String message;
  final String? code;

  bool get isUnauthorized => status == 401;

  static String _fallback(int? status) => switch (status) {
        400 => 'The request was invalid.',
        401 => 'Please sign in again.',
        403 => 'You do not have access to this.',
        404 => 'Not found.',
        409 => 'That already exists.',
        422 => 'The file could not be processed.',
        null => 'Request failed.',
        _ => 'Request failed (HTTP $status).',
      };

  @override
  String toString() => message;
}

/// Short user-facing text for any error.
String describeError(Object error) => ApiException.from(error).message;
