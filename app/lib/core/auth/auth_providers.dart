import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_providers.dart';
import 'auth_service.dart';
import 'oidc_auth_service.dart';

/// Overridden in tests with a fake.
final authServiceProvider = Provider<AuthService>(
  (ref) => OidcAuthService(ref.watch(appConfigProvider)),
);
