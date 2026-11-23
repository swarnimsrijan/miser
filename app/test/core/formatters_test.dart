import 'package:flutter_test/flutter_test.dart';
import 'package:miser_app/core/formatting/formatters.dart';

void main() {
  group('Inr.format', () {
    test('uses Indian digit grouping (lakh / crore)', () {
      expect(Inr.format(1234567.5), '₹12,34,567.50');
      expect(Inr.format(123456789), '₹12,34,56,789.00');
      expect(Inr.format(1000), '₹1,000.00');
      expect(Inr.format(999), '₹999.00');
      expect(Inr.format(0), '₹0.00');
    });

    test('can drop decimals', () {
      expect(Inr.format(150000.4, decimals: false), '₹1,50,000');
    });

    test('negative amounts and null', () {
      expect(Inr.format(-250000), '-₹2,50,000.00');
      expect(Inr.format(null), '—');
    });

    test('signed adds an explicit plus sign', () {
      expect(Inr.signed(12000, decimals: false), '+₹12,000');
      expect(Inr.signed(-12000, decimals: false), '-₹12,000');
      expect(Inr.signed(0, decimals: false), '₹0');
    });
  });

  group('Inr.compact', () {
    test('uses K / L / Cr', () {
      expect(Inr.compact(950), '₹950');
      expect(Inr.compact(12500), '₹12.5K');
      expect(Inr.compact(120000), '₹1.2L');
      expect(Inr.compact(2500000), '₹25L');
      expect(Inr.compact(34000000), '₹3.4Cr');
      expect(Inr.compact(-150000), '-₹1.5L');
    });
  });

  test('Inr.number groups without a symbol', () {
    expect(Inr.number(1234567), '12,34,567');
  });

  group('Dates', () {
    test('parses Java YearMonth strings', () {
      expect(Dates.parseYearMonth('2026-03'), DateTime(2026, 3));
      expect(Dates.parseYearMonth('bad'), isNull);
      expect(Dates.monthLabel('2026-03'), 'Mar 2026');
      expect(Dates.monthLabel('2026-03', short: true), 'Mar 26');
    });

    test('formats ISO dates for query parameters', () {
      expect(Dates.iso(DateTime(2026, 1, 5)), '2026-01-05');
      expect(Dates.yearMonth(DateTime(2026, 11, 30)), '2026-11');
    });
  });
}
