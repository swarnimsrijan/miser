// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'projected_month.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ProjectedMonthCWProxy {
  ProjectedMonth month(String? month);

  ProjectedMonth income(num? income);

  ProjectedMonth expense(num? expense);

  ProjectedMonth savings(num? savings);

  ProjectedMonth cumulativeSavings(num? cumulativeSavings);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `ProjectedMonth(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// ProjectedMonth(...).copyWith(id: 12, name: "My name")
  /// ```
  ProjectedMonth call({
    String? month,
    num? income,
    num? expense,
    num? savings,
    num? cumulativeSavings,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfProjectedMonth.copyWith(...)` or call `instanceOfProjectedMonth.copyWith.fieldName(value)` for a single field.
class _$ProjectedMonthCWProxyImpl implements _$ProjectedMonthCWProxy {
  const _$ProjectedMonthCWProxyImpl(this._value);

  final ProjectedMonth _value;

  @override
  ProjectedMonth month(String? month) => call(month: month);

  @override
  ProjectedMonth income(num? income) => call(income: income);

  @override
  ProjectedMonth expense(num? expense) => call(expense: expense);

  @override
  ProjectedMonth savings(num? savings) => call(savings: savings);

  @override
  ProjectedMonth cumulativeSavings(num? cumulativeSavings) =>
      call(cumulativeSavings: cumulativeSavings);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `ProjectedMonth(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// ProjectedMonth(...).copyWith(id: 12, name: "My name")
  /// ```
  ProjectedMonth call({
    Object? month = const $CopyWithPlaceholder(),
    Object? income = const $CopyWithPlaceholder(),
    Object? expense = const $CopyWithPlaceholder(),
    Object? savings = const $CopyWithPlaceholder(),
    Object? cumulativeSavings = const $CopyWithPlaceholder(),
  }) {
    return ProjectedMonth(
      month: month == const $CopyWithPlaceholder()
          ? _value.month
          // ignore: cast_nullable_to_non_nullable
          : month as String?,
      income: income == const $CopyWithPlaceholder()
          ? _value.income
          // ignore: cast_nullable_to_non_nullable
          : income as num?,
      expense: expense == const $CopyWithPlaceholder()
          ? _value.expense
          // ignore: cast_nullable_to_non_nullable
          : expense as num?,
      savings: savings == const $CopyWithPlaceholder()
          ? _value.savings
          // ignore: cast_nullable_to_non_nullable
          : savings as num?,
      cumulativeSavings: cumulativeSavings == const $CopyWithPlaceholder()
          ? _value.cumulativeSavings
          // ignore: cast_nullable_to_non_nullable
          : cumulativeSavings as num?,
    );
  }
}

extension $ProjectedMonthCopyWith on ProjectedMonth {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfProjectedMonth.copyWith(...)` or `instanceOfProjectedMonth.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ProjectedMonthCWProxy get copyWith => _$ProjectedMonthCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProjectedMonth _$ProjectedMonthFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ProjectedMonth', json, ($checkedConvert) {
      final val = ProjectedMonth(
        month: $checkedConvert('month', (v) => v as String?),
        income: $checkedConvert('income', (v) => v as num?),
        expense: $checkedConvert('expense', (v) => v as num?),
        savings: $checkedConvert('savings', (v) => v as num?),
        cumulativeSavings: $checkedConvert(
          'cumulativeSavings',
          (v) => v as num?,
        ),
      );
      return val;
    });

Map<String, dynamic> _$ProjectedMonthToJson(ProjectedMonth instance) =>
    <String, dynamic>{
      'month': ?instance.month,
      'income': ?instance.income,
      'expense': ?instance.expense,
      'savings': ?instance.savings,
      'cumulativeSavings': ?instance.cumulativeSavings,
    };
