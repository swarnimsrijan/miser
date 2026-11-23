import 'package:intl/intl.dart';

/// Indian-rupee formatting with Indian digit grouping (1,23,45,678.90).
class Inr {
  Inr._();

  static final NumberFormat _full =
      NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);
  static final NumberFormat _whole =
      NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);
  static final NumberFormat _plain = NumberFormat.decimalPattern('en_IN');

  /// ₹1,23,456.78 (null renders as an em dash).
  static String format(num? value, {bool decimals = true}) {
    if (value == null) return '—';
    return (decimals ? _full : _whole).format(value);
  }

  /// Signed variant for deltas: +₹1,200.00 / -₹1,200.00.
  static String signed(num? value, {bool decimals = true}) {
    if (value == null) return '—';
    final s = format(value.abs(), decimals: decimals);
    if (value > 0) return '+$s';
    if (value < 0) return '-$s';
    return s;
  }

  /// Short form for chart axes: ₹950, ₹12.5K, ₹1.2L, ₹3.4Cr.
  static String compact(num? value) {
    if (value == null) return '—';
    final v = value.abs();
    final sign = value < 0 ? '-' : '';
    String trim(double d) =>
        d.toStringAsFixed(d >= 100 ? 0 : 1).replaceAll(RegExp(r'\.0$'), '');
    if (v >= 1e7) return '$sign₹${trim(v / 1e7)}Cr';
    if (v >= 1e5) return '$sign₹${trim(v / 1e5)}L';
    if (v >= 1e3) return '$sign₹${trim(v / 1e3)}K';
    return '$sign₹${v.round()}';
  }

  /// Number without the currency symbol, Indian grouping: 1,23,456.
  static String number(num? value) => value == null ? '—' : _plain.format(value);
}

/// Date helpers shared by screens and API calls.
class Dates {
  Dates._();

  static final DateFormat _display = DateFormat('d MMM yyyy');
  static final DateFormat _monthDisplay = DateFormat('MMM yyyy');
  static final DateFormat _monthShort = DateFormat('MMM yy');
  static final DateFormat _iso = DateFormat('yyyy-MM-dd');
  static final DateFormat _yearMonth = DateFormat('yyyy-MM');

  static String display(DateTime? d) => d == null ? '—' : _display.format(d);
  static String iso(DateTime d) => _iso.format(d);
  static String yearMonth(DateTime d) => _yearMonth.format(d);

  /// Parses `yyyy-MM` (Java YearMonth) into the first day of that month.
  static DateTime? parseYearMonth(String? s) {
    if (s == null || s.isEmpty) return null;
    final m = RegExp(r'^(\d{4})-(\d{2})').firstMatch(s);
    if (m == null) return null;
    return DateTime(int.parse(m.group(1)!), int.parse(m.group(2)!));
  }

  /// `2026-11` -> `Nov 2026`.
  static String monthLabel(String? yearMonth, {bool short = false}) {
    final d = parseYearMonth(yearMonth);
    if (d == null) return yearMonth ?? '—';
    return (short ? _monthShort : _monthDisplay).format(d);
  }
}
