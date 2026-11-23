import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:miser_api/miser_api.dart';

import '../../core/api/api_providers.dart';
import '../../core/auth/auth_providers.dart';
import '../../core/theme/theme_mode_provider.dart';
import '../../core/widgets/common.dart';

final meProvider = FutureProvider.autoDispose<MeResponse>((ref) async {
  final res = await ref.watch(miserApiProvider).getMeControllerApi().me();
  return res.data!;
});

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final me = ref.watch(meProvider);
    final mode = ref.watch(themeModeProvider);
    final config = ref.watch(appConfigProvider);
    return PageScaffold(
      title: 'Profile',
      maxWidth: 640,
      onRefresh: () async => ref.invalidate(meProvider),
      children: [
        Card(
          child: AsyncValueView(
            value: me,
            compact: true,
            onRetry: () => ref.invalidate(meProvider),
            data: (m) => ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                radius: 24,
                child: Text(
                  (m.name?.isNotEmpty == true ? m.name! : (m.email ?? '?')).characters.first.toUpperCase(),
                ),
              ),
              title: Text(m.name ?? 'Miser user'),
              subtitle: Text(m.email ?? ''),
            ),
          ),
        ),
        SectionCard(
          title: 'Appearance',
          child: SegmentedButton<ThemeMode>(
            segments: const [
              ButtonSegment(value: ThemeMode.system, icon: Icon(Icons.brightness_auto), label: Text('System')),
              ButtonSegment(value: ThemeMode.light, icon: Icon(Icons.light_mode), label: Text('Light')),
              ButtonSegment(value: ThemeMode.dark, icon: Icon(Icons.dark_mode), label: Text('Dark')),
            ],
            selected: {mode},
            onSelectionChanged: (s) => ref.read(themeModeProvider.notifier).set(s.first),
          ),
        ),
        SectionCard(
          title: 'Connection',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('API: ${config.apiBaseUrl}'),
              Text('Identity provider: ${config.oidcIssuer}'),
            ],
          ),
        ),
        FilledButton.tonalIcon(
          key: const Key('sign-out-button'),
          onPressed: () async {
            final ok = await confirmDialog(
              context,
              title: 'Sign out?',
              message: 'You will need to sign in again to see your data.',
              confirmLabel: 'Sign out',
              destructive: false,
            );
            if (ok) await ref.read(authServiceProvider).signOut();
          },
          icon: const Icon(Icons.logout),
          label: const Text('Sign out'),
        ),
      ],
    );
  }
}
