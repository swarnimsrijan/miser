import 'package:flutter/foundation.dart';

/// Build-time configuration, supplied with `--dart-define`.
///
/// ```sh
/// flutter run --dart-define=API_BASE_URL=http://localhost:8080 \
///   --dart-define=OIDC_ISSUER=http://localhost:8180/realms/miser \
///   --dart-define=OIDC_CLIENT_ID=miser-app
/// ```
class AppConfig {
  const AppConfig({
    required this.apiBaseUrl,
    required this.oidcIssuer,
    required this.oidcClientId,
    this.webRedirectPath = '/auth/callback',
    this.webPostLogoutPath = '/auth/logout',
    this.mobileRedirectUri = 'com.miser.app:/oauthredirect',
    this.mobilePostLogoutUri = 'com.miser.app:/logout',
    this.scopes = const ['openid', 'profile', 'email', 'offline_access'],
  });

  factory AppConfig.fromEnvironment() => const AppConfig(
        apiBaseUrl: String.fromEnvironment(
          'API_BASE_URL',
          defaultValue: 'http://localhost:8080',
        ),
        oidcIssuer: String.fromEnvironment(
          'OIDC_ISSUER',
          defaultValue: 'http://localhost:8180/realms/miser',
        ),
        oidcClientId: String.fromEnvironment(
          'OIDC_CLIENT_ID',
          defaultValue: 'miser-app',
        ),
      );

  final String apiBaseUrl;
  final String oidcIssuer;
  final String oidcClientId;
  final String webRedirectPath;
  final String webPostLogoutPath;
  final String mobileRedirectUri;
  final String mobilePostLogoutUri;
  final List<String> scopes;

  /// The redirect URI registered in Keycloak for the current platform.
  /// On web it is derived from the page origin (http://localhost:5000 in dev).
  Uri redirectUri({Uri? webOrigin}) => kIsWeb
      ? _webUri(webOrigin ?? Uri.base, webRedirectPath)
      : Uri.parse(mobileRedirectUri);

  Uri postLogoutRedirectUri({Uri? webOrigin}) => kIsWeb
      ? _webUri(webOrigin ?? Uri.base, webPostLogoutPath)
      : Uri.parse(mobilePostLogoutUri);

  static Uri _webUri(Uri origin, String path) =>
      Uri(scheme: origin.scheme, host: origin.host, port: origin.port, path: path);
}
