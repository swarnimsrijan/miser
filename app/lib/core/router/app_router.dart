import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../features/accounts/accounts_screen.dart';
import '../../features/auth/sign_in_screen.dart';
import '../../features/budgets/budgets_screen.dart';
import '../../features/goals/goals_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/planner/planner_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/recurring/recurring_screen.dart';
import '../../features/shell/app_shell.dart';
import '../../features/statements/upload_screen.dart';
import '../../features/transactions/transactions_screen.dart';
import '../auth/auth_providers.dart';
import 'auth_redirect.dart';

NoTransitionPage<void> _page(Widget child) => NoTransitionPage(child: child);

final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authServiceProvider);
  final router = GoRouter(
    initialLocation: '/',
    refreshListenable: auth.state,
    redirect: (context, state) => authRedirect(auth.state.value, state.uri),
    routes: [
      GoRoute(path: splashPath, builder: (_, _) => const SplashScreen()),
      GoRoute(path: signInPath, builder: (_, _) => const SignInScreen()),
      // Web OIDC callbacks normally go through web/redirect.html (see
      // web/index.html); these routes only show a spinner if the app itself
      // gets loaded on them.
      GoRoute(path: '/auth/callback', builder: (_, _) => const SplashScreen()),
      GoRoute(path: '/auth/logout', builder: (_, _) => const SplashScreen()),
      ShellRoute(
        builder: (context, state, child) =>
            AppShell(location: state.uri.path, child: child),
        routes: [
          GoRoute(path: '/', pageBuilder: (_, _) => _page(const HomeScreen())),
          GoRoute(path: '/accounts', pageBuilder: (_, _) => _page(const AccountsScreen())),
          GoRoute(path: '/upload', pageBuilder: (_, _) => _page(const UploadScreen())),
          GoRoute(
            path: '/transactions',
            pageBuilder: (_, _) => _page(const TransactionsScreen()),
          ),
          GoRoute(path: '/budgets', pageBuilder: (_, _) => _page(const BudgetsScreen())),
          GoRoute(path: '/goals', pageBuilder: (_, _) => _page(const GoalsScreen())),
          GoRoute(path: '/planner', pageBuilder: (_, _) => _page(const PlannerScreen())),
          GoRoute(path: '/recurring', pageBuilder: (_, _) => _page(const RecurringScreen())),
          GoRoute(path: '/profile', pageBuilder: (_, _) => _page(const ProfileScreen())),
          GoRoute(path: '/more', pageBuilder: (_, _) => _page(const MoreScreen())),
        ],
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
