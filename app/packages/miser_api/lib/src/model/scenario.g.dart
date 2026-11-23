// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scenario.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ScenarioCWProxy {
  Scenario monthlyIncome(num? monthlyIncome);

  Scenario monthlyExpense(num? monthlyExpense);

  Scenario monthlySavings(num? monthlySavings);

  Scenario totalSavings(num? totalSavings);

  Scenario months(List<ProjectedMonth>? months);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `Scenario(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// Scenario(...).copyWith(id: 12, name: "My name")
  /// ```
  Scenario call({
    num? monthlyIncome,
    num? monthlyExpense,
    num? monthlySavings,
    num? totalSavings,
    List<ProjectedMonth>? months,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfScenario.copyWith(...)` or call `instanceOfScenario.copyWith.fieldName(value)` for a single field.
class _$ScenarioCWProxyImpl implements _$ScenarioCWProxy {
  const _$ScenarioCWProxyImpl(this._value);

  final Scenario _value;

  @override
  Scenario monthlyIncome(num? monthlyIncome) =>
      call(monthlyIncome: monthlyIncome);

  @override
  Scenario monthlyExpense(num? monthlyExpense) =>
      call(monthlyExpense: monthlyExpense);

  @override
  Scenario monthlySavings(num? monthlySavings) =>
      call(monthlySavings: monthlySavings);

  @override
  Scenario totalSavings(num? totalSavings) => call(totalSavings: totalSavings);

  @override
  Scenario months(List<ProjectedMonth>? months) => call(months: months);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `Scenario(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// Scenario(...).copyWith(id: 12, name: "My name")
  /// ```
  Scenario call({
    Object? monthlyIncome = const $CopyWithPlaceholder(),
    Object? monthlyExpense = const $CopyWithPlaceholder(),
    Object? monthlySavings = const $CopyWithPlaceholder(),
    Object? totalSavings = const $CopyWithPlaceholder(),
    Object? months = const $CopyWithPlaceholder(),
  }) {
    return Scenario(
      monthlyIncome: monthlyIncome == const $CopyWithPlaceholder()
          ? _value.monthlyIncome
          // ignore: cast_nullable_to_non_nullable
          : monthlyIncome as num?,
      monthlyExpense: monthlyExpense == const $CopyWithPlaceholder()
          ? _value.monthlyExpense
          // ignore: cast_nullable_to_non_nullable
          : monthlyExpense as num?,
      monthlySavings: monthlySavings == const $CopyWithPlaceholder()
          ? _value.monthlySavings
          // ignore: cast_nullable_to_non_nullable
          : monthlySavings as num?,
      totalSavings: totalSavings == const $CopyWithPlaceholder()
          ? _value.totalSavings
          // ignore: cast_nullable_to_non_nullable
          : totalSavings as num?,
      months: months == const $CopyWithPlaceholder()
          ? _value.months
          // ignore: cast_nullable_to_non_nullable
          : months as List<ProjectedMonth>?,
    );
  }
}

extension $ScenarioCopyWith on Scenario {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfScenario.copyWith(...)` or `instanceOfScenario.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ScenarioCWProxy get copyWith => _$ScenarioCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Scenario _$ScenarioFromJson(Map<String, dynamic> json) =>
    $checkedCreate('Scenario', json, ($checkedConvert) {
      final val = Scenario(
        monthlyIncome: $checkedConvert('monthlyIncome', (v) => v as num?),
        monthlyExpense: $checkedConvert('monthlyExpense', (v) => v as num?),
        monthlySavings: $checkedConvert('monthlySavings', (v) => v as num?),
        totalSavings: $checkedConvert('totalSavings', (v) => v as num?),
        months: $checkedConvert(
          'months',
          (v) => (v as List<dynamic>?)
              ?.map((e) => ProjectedMonth.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$ScenarioToJson(Scenario instance) => <String, dynamic>{
  'monthlyIncome': ?instance.monthlyIncome,
  'monthlyExpense': ?instance.monthlyExpense,
  'monthlySavings': ?instance.monthlySavings,
  'totalSavings': ?instance.totalSavings,
  'months': ?instance.months?.map((e) => e.toJson()).toList(),
};
