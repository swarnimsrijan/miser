import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The user's light/dark/system choice, persisted in shared preferences.
class ThemeModeController extends Notifier<ThemeMode> {
  static const _key = 'miser.themeMode';

  @override
  ThemeMode build() {
    _load();
    return ThemeMode.system;
  }

  Future<void> _load() async {
    try {
      final stored = await SharedPreferencesAsync().getString(_key);
      final mode = ThemeMode.values.where((m) => m.name == stored).firstOrNull;
      if (mode != null) state = mode;
    } catch (_) {
      // Preferences unavailable (e.g. in tests): keep the default.
    }
  }

  Future<void> set(ThemeMode mode) async {
    state = mode;
    try {
      await SharedPreferencesAsync().setString(_key, mode.name);
    } catch (_) {}
  }
}

final themeModeProvider =
    NotifierProvider<ThemeModeController, ThemeMode>(ThemeModeController.new);
