import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:material_ui/material_ui.dart';

import 'app.dart';
import 'core/auth/auth_providers.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Path URLs (/transactions, not /#/transactions) so the OIDC redirect URI
  // http://localhost:5000/auth/callback maps onto a real path.
  usePathUrlStrategy();

  final container = ProviderContainer(
    // Errors are shown with a Retry button; don't silently re-hit the API.
    retry: (_, _) => null,
  );
  // Restore the session (or finish a web redirect) while the splash shows.
  unawaited(container.read(authServiceProvider).init());

  runApp(UncontrolledProviderScope(container: container, child: const MiserApp()));
}
