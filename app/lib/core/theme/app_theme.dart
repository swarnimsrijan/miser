import 'package:material_ui/material_ui.dart';

class AppTheme {
  AppTheme._();

  static const _seed = Color(0xFF0F7B6C); // teal-green: money, calm

  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(seedColor: _seed, brightness: brightness);
    return ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      visualDensity: VisualDensity.standard,
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        isDense: true,
      ),
    );
  }
}

/// Semantic colours that stay readable in light and dark themes.
extension MiserColors on ColorScheme {
  bool get _isDark => brightness == Brightness.dark;

  Color get income => _isDark ? const Color(0xFF6DD58C) : const Color(0xFF1B7F3B);
  Color get expense => _isDark ? const Color(0xFFFF8A80) : const Color(0xFFC62828);
  Color get warning => _isDark ? const Color(0xFFFFCC80) : const Color(0xFFB26A00);
  Color get success => income;
}
