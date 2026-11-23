import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_mode_provider.dart';

class MiserApp extends ConsumerWidget {
  const MiserApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Miser',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ref.watch(themeModeProvider),
      routerConfig: ref.watch(routerProvider),
    );
  }
}
