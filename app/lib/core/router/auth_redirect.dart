import '../auth/auth_service.dart';

/// Paths reachable without a session.
const signInPath = '/sign-in';
const splashPath = '/splash';

bool _isAuthPath(String path) =>
    path == signInPath || path == splashPath || path.startsWith('/auth/');

/// Only allow same-app, path-absolute targets (no `//host` or `scheme:`).
String? _safeTarget(String? from) {
  if (from == null || from.isEmpty) return null;
  if (!from.startsWith('/') || from.startsWith('//')) return null;
  final uri = Uri.tryParse(from);
  if (uri == null || uri.hasScheme || uri.hasAuthority) return null;
  if (_isAuthPath(uri.path)) return null;
  return from;
}

String _withFrom(String target, Uri location) {
  final from = _safeTarget(location.toString());
  if (from == null || from == '/') return target;
  return Uri(path: target, queryParameters: {'from': from}).toString();
}

/// The go_router redirect guard, as a pure function so it can be unit tested.
///
/// * While the session is being restored, everything waits on the splash.
/// * Signed out: every app route goes to sign-in (remembering where to return).
/// * Signed in: sign-in / splash / callback routes forward to the app.
String? authRedirect(AuthState auth, Uri location) {
  final path = location.path;
  switch (auth.status) {
    case AuthStatus.initializing:
      return _isAuthPath(path) ? null : _withFrom(splashPath, location);
    case AuthStatus.signedOut:
      if (path == signInPath) return null;
      if (_isAuthPath(path)) {
        final from = _safeTarget(location.queryParameters['from']);
        return from == null
            ? signInPath
            : Uri(path: signInPath, queryParameters: {'from': from}).toString();
      }
      return _withFrom(signInPath, location);
    case AuthStatus.signedIn:
      if (!_isAuthPath(path)) return null;
      return _safeTarget(location.queryParameters['from']) ?? '/';
  }
}
