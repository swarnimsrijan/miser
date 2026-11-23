import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:oidc/oidc.dart';
import 'package:oidc_default_store/oidc_default_store.dart';

import '../config/app_config.dart';
import 'auth_service.dart';

/// [AuthService] backed by `package:oidc` (Keycloak, authorization code + PKCE,
/// public client). Tokens are persisted by [OidcDefaultStore]: platform secure
/// storage (Keychain / Android Keystore) on mobile, browser storage on web.
///
/// Nothing in here logs tokens; we never attach a listener to the `logging`
/// package that `oidc` uses internally.
class OidcAuthService implements AuthService {
  OidcAuthService(this._config);

  final AppConfig _config;
  final ValueNotifier<AuthState> _state =
      ValueNotifier(const AuthState.initializing());
  OidcUserManager? _manager;
  StreamSubscription<OidcUser?>? _userSub;
  bool _initDone = false;

  @override
  ValueListenable<AuthState> get state => _state;

  OidcUserManager _createManager() => OidcUserManager.lazy(
        discoveryDocumentUri: OidcUtils.getOpenIdConfigWellKnownUri(
          Uri.parse(_config.oidcIssuer),
        ),
        clientCredentials:
            OidcClientAuthentication.none(clientId: _config.oidcClientId),
        store: OidcDefaultStore(),
        settings: OidcUserManagerSettings(
          redirectUri: _config.redirectUri(),
          postLogoutRedirectUri: _config.postLogoutRedirectUri(),
          scope: _config.scopes,
          // Refresh a minute before expiry; the manager does this in the
          // background, and getAccessToken() refreshes on demand as well.
          refreshBefore: (_) => const Duration(minutes: 1),
          options: const OidcPlatformSpecificOptions(
            // Full-page redirect on web: no popup blockers, and the callback
            // page (web/redirect.html, reached via /auth/callback) hands the
            // response back to the app on reload.
            web: OidcPlatformSpecificOptions_Web(
              navigationMode:
                  OidcPlatformSpecificOptions_Web_NavigationMode.samePage,
            ),
          ),
        ),
      );

  @override
  Future<void> init() async {
    _state.value = const AuthState.initializing();
    await _userSub?.cancel();
    // init() is memoized per manager, so a failed init needs a new instance.
    final manager = _manager = _createManager();
    _userSub = manager.userChanges().listen(_onUser);
    _initDone = false;
    try {
      await manager.init();
      _initDone = true;
      _onUser(manager.currentUser);
    } catch (e) {
      _initDone = true;
      _state.value = AuthState.signedOut(
        error: 'Could not reach the sign-in server. Check your connection '
            'and try again.',
      );
      if (kDebugMode) debugPrint('OIDC init failed: ${e.runtimeType}');
    }
  }

  void _onUser(OidcUser? user) {
    // The stream starts with null before the stored session is restored;
    // stay on the splash until init() has finished.
    if (user == null && _state.value.status == AuthStatus.initializing && !_initDone) {
      return;
    }
    if (user == null) {
      if (_state.value.status != AuthStatus.signedOut ||
          _state.value.error != null) {
        _state.value = const AuthState.signedOut();
      }
      return;
    }
    final claims = user.aggregatedClaims;
    _state.value = AuthState(
      AuthStatus.signedIn,
      displayName: (claims['name'] ?? claims['preferred_username']) as String?,
      email: claims['email'] as String?,
    );
  }

  @override
  Future<void> signIn() async {
    final manager = _manager;
    if (manager == null || !manager.didInit) {
      await init();
      if (_manager?.didInit != true) return;
    }
    try {
      await _manager!.loginAuthorizationCodeFlow(
        // On web (samePage) the browser navigates away; redirect.html sends
        // it back to the app root, where init() completes the code exchange.
        originalUri: kIsWeb ? _webAppRoot() : null,
      );
    } on OidcException catch (e) {
      _state.value = AuthState.signedOut(
        error: 'Sign-in did not complete (${e.message}).',
      );
    }
  }

  @override
  Future<void> signOut() async {
    final manager = _manager;
    if (manager == null || !manager.didInit) {
      _state.value = const AuthState.signedOut();
      return;
    }
    try {
      await manager.logout(
        originalUri: kIsWeb ? _webAppRoot() : null,
      );
    } catch (_) {
      // Even if the end-session call fails, drop the local session.
      await manager.forgetUser();
    }
    _state.value = const AuthState.signedOut();
  }

  @override
  Future<String?> accessToken({bool forceRefresh = false}) async {
    final manager = _manager;
    if (manager == null || !manager.didInit) return null;
    try {
      return await manager.getAccessToken(forceRefresh: forceRefresh);
    } on OidcException {
      return null;
    }
  }

  static Uri _webAppRoot() => Uri(
        scheme: Uri.base.scheme,
        host: Uri.base.host,
        port: Uri.base.port,
        path: '/',
      );

  @override
  Future<void> handleUnauthorized() async {
    await _manager?.forgetUser();
    _state.value = const AuthState.signedOut(
      error: 'Your session has expired. Please sign in again.',
    );
  }
}
