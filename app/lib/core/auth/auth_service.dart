import 'package:flutter/foundation.dart';

enum AuthStatus { initializing, signedOut, signedIn }

/// Snapshot of the session that the UI and router care about. Never contains
/// tokens, so it is safe to print or put in widget state.
@immutable
class AuthState {
  const AuthState(this.status, {this.displayName, this.email, this.error});

  const AuthState.initializing() : this(AuthStatus.initializing);
  const AuthState.signedOut({String? error})
      : this(AuthStatus.signedOut, error: error);

  final AuthStatus status;
  final String? displayName;
  final String? email;

  /// A user-facing message for the last failed sign-in / init attempt.
  final String? error;

  bool get isSignedIn => status == AuthStatus.signedIn;

  @override
  String toString() => 'AuthState($status)';
}

/// Abstraction over the OIDC client so the router, API layer and widgets can
/// be tested without a real identity provider.
abstract class AuthService {
  /// Current state; the router listens to this for its redirect guard.
  ValueListenable<AuthState> get state;

  /// Restores a stored session (and on web, completes a pending redirect).
  Future<void> init();

  /// Starts the authorization-code + PKCE flow in the browser.
  Future<void> signIn();

  /// Ends the Keycloak session and clears local tokens.
  Future<void> signOut();

  /// A fresh access token (refreshing if it is about to expire), or null when
  /// there is no session. [forceRefresh] refreshes unconditionally.
  Future<String?> accessToken({bool forceRefresh = false});

  /// Called when the API rejected our token and refreshing did not help:
  /// drops the local session so the router sends the user to sign-in.
  Future<void> handleUnauthorized();
}
