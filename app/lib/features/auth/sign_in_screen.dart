import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/auth/auth_providers.dart';
import '../../core/auth/auth_service.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

/// The only auth UI in the app: Keycloak's hosted pages handle sign-up,
/// password reset and social login.
class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  bool _busy = false;

  Future<void> _signIn() async {
    setState(() => _busy = true);
    try {
      await ref.read(authServiceProvider).signIn();
    } finally {
      // On web the page navigates away; on mobile we land back here or in
      // the app once the browser returns.
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authServiceProvider);
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.savings, size: 72, color: theme.colorScheme.primary),
                const SizedBox(height: 16),
                Text('Miser', style: theme.textTheme.displaySmall),
                const SizedBox(height: 8),
                Text(
                  'Your statements, budgets and goals in one place.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 32),
                ValueListenableBuilder<AuthState>(
                  valueListenable: auth.state,
                  builder: (context, state, _) => Column(
                    children: [
                      if (state.error != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text(
                            state.error!,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: theme.colorScheme.error),
                          ),
                        ),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          key: const Key('sign-in-button'),
                          onPressed: _busy ? null : _signIn,
                          icon: _busy
                              ? const SizedBox.square(
                                  dimension: 18,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.login),
                          label: const Text('Sign in'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  kIsWeb
                      ? 'You will be taken to the Miser sign-in page.'
                      : 'Sign-in opens in a secure browser window.',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
