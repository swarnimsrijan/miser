import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:miser_app/core/auth/auth_service.dart';
import 'package:miser_app/core/router/auth_redirect.dart';

import '../helpers/fakes.dart';

const signedIn = AuthState(AuthStatus.signedIn, displayName: 'Asha');
const signedOut = AuthState.signedOut();
const initializing = AuthState.initializing();

String? redirect(AuthState s, String location) => authRedirect(s, Uri.parse(location));

void main() {
  group('authRedirect', () {
    test('signed out users are sent to sign-in, remembering the target', () {
      expect(redirect(signedOut, '/'), '/sign-in');
      expect(redirect(signedOut, '/budgets'), '/sign-in?from=%2Fbudgets');
      expect(
        Uri.parse(redirect(signedOut, '/transactions?q=swiggy')!).queryParameters['from'],
        '/transactions?q=swiggy',
      );
    });

    test('signed out users may stay on sign-in', () {
      expect(redirect(signedOut, '/sign-in'), isNull);
      expect(redirect(signedOut, '/sign-in?from=%2Fgoals'), isNull);
    });

    test('splash and callback routes go to sign-in once restore fails', () {
      expect(redirect(signedOut, '/splash'), '/sign-in');
      expect(redirect(signedOut, '/splash?from=%2Fgoals'), '/sign-in?from=%2Fgoals');
      expect(redirect(signedOut, '/auth/callback?code=x&state=y'), '/sign-in');
    });

    test('while initializing everything waits on the splash', () {
      expect(redirect(initializing, '/'), '/splash');
      expect(redirect(initializing, '/planner'), '/splash?from=%2Fplanner');
      expect(redirect(initializing, '/splash'), isNull);
      expect(redirect(initializing, '/auth/callback'), isNull);
    });

    test('signed in users pass through app routes', () {
      for (final path in ['/', '/accounts', '/upload', '/transactions', '/profile']) {
        expect(redirect(signedIn, path), isNull, reason: path);
      }
    });

    test('signed in users leave sign-in / splash for the remembered target', () {
      expect(redirect(signedIn, '/sign-in'), '/');
      expect(redirect(signedIn, '/sign-in?from=%2Fbudgets'), '/budgets');
      expect(redirect(signedIn, '/splash?from=%2Fgoals'), '/goals');
      expect(redirect(signedIn, '/auth/callback'), '/');
    });

    test('rejects open redirects in "from"', () {
      expect(redirect(signedIn, '/sign-in?from=https%3A%2F%2Fevil.example'), '/');
      expect(redirect(signedIn, '/sign-in?from=%2F%2Fevil.example'), '/');
      expect(redirect(signedIn, '/sign-in?from=%2Fsign-in'), '/');
    });
  });

  testWidgets('GoRouter guard reacts to auth state changes', (tester) async {
    final auth = FakeAuthService(initial: initializing);
    Widget page(String name) => Scaffold(body: Text(name));
    final router = GoRouter(
      initialLocation: '/budgets',
      refreshListenable: auth.state,
      redirect: (_, state) => authRedirect(auth.state.value, state.uri),
      routes: [
        GoRoute(path: '/splash', builder: (_, _) => page('splash')),
        GoRoute(path: '/sign-in', builder: (_, _) => page('sign-in')),
        GoRoute(path: '/', builder: (_, _) => page('home')),
        GoRoute(path: '/budgets', builder: (_, _) => page('budgets')),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();
    expect(find.text('splash'), findsOneWidget);

    auth.value = signedOut;
    await tester.pumpAndSettle();
    expect(find.text('sign-in'), findsOneWidget);
    expect(router.routeInformationProvider.value.uri.queryParameters['from'], '/budgets');

    auth.value = signedIn;
    await tester.pumpAndSettle();
    expect(find.text('budgets'), findsOneWidget);

    // A 401 that refresh can't fix drops the session -> back to sign-in.
    await auth.handleUnauthorized();
    await tester.pumpAndSettle();
    expect(find.text('sign-in'), findsOneWidget);
  });
}
