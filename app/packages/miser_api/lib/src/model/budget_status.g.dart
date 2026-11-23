// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_status.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$BudgetStatusCWProxy {
  BudgetStatus categoryId(int? categoryId);

  BudgetStatus category(String? category);

  BudgetStatus month(String? month);

  BudgetStatus monthlyLimit(num? monthlyLimit);

  BudgetStatus spent(num? spent);

  BudgetStatus remaining(num? remaining);

  BudgetStatus percentUsed(num? percentUsed);

  BudgetStatus projectedSpend(num? projectedSpend);

  BudgetStatus status(BudgetStatusStatusEnum? status);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `BudgetStatus(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// BudgetStatus(...).copyWith(id: 12, name: "My name")
  /// ```
  BudgetStatus call({
    int? categoryId,
    String? category,
    String? month,
    num? monthlyLimit,
    num? spent,
    num? remaining,
    num? percentUsed,
    num? projectedSpend,
    BudgetStatusStatusEnum? status,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfBudgetStatus.copyWith(...)` or call `instanceOfBudgetStatus.copyWith.fieldName(value)` for a single field.
class _$BudgetStatusCWProxyImpl implements _$BudgetStatusCWProxy {
  const _$BudgetStatusCWProxyImpl(this._value);

  final BudgetStatus _value;

  @override
  BudgetStatus categoryId(int? categoryId) => call(categoryId: categoryId);

  @override
  BudgetStatus category(String? category) => call(category: category);

  @override
  BudgetStatus month(String? month) => call(month: month);

  @override
  BudgetStatus monthlyLimit(num? monthlyLimit) =>
      call(monthlyLimit: monthlyLimit);

  @override
  BudgetStatus spent(num? spent) => call(spent: spent);

  @override
  BudgetStatus remaining(num? remaining) => call(remaining: remaining);

  @override
  BudgetStatus percentUsed(num? percentUsed) => call(percentUsed: percentUsed);

  @override
  BudgetStatus projectedSpend(num? projectedSpend) =>
      call(projectedSpend: projectedSpend);

  @override
  BudgetStatus status(BudgetStatusStatusEnum? status) => call(status: status);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `BudgetStatus(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// BudgetStatus(...).copyWith(id: 12, name: "My name")
  /// ```
  BudgetStatus call({
    Object? categoryId = const $CopyWithPlaceholder(),
    Object? category = const $CopyWithPlaceholder(),
    Object? month = const $CopyWithPlaceholder(),
    Object? monthlyLimit = const $CopyWithPlaceholder(),
    Object? spent = const $CopyWithPlaceholder(),
    Object? remaining = const $CopyWithPlaceholder(),
    Object? percentUsed = const $CopyWithPlaceholder(),
    Object? projectedSpend = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
  }) {
    return BudgetStatus(
      categoryId: categoryId == const $CopyWithPlaceholder()
          ? _value.categoryId
          // ignore: cast_nullable_to_non_nullable
          : categoryId as int?,
      category: category == const $CopyWithPlaceholder()
          ? _value.category
          // ignore: cast_nullable_to_non_nullable
          : category as String?,
      month: month == const $CopyWithPlaceholder()
          ? _value.month
          // ignore: cast_nullable_to_non_nullable
          : month as String?,
      monthlyLimit: monthlyLimit == const $CopyWithPlaceholder()
          ? _value.monthlyLimit
          // ignore: cast_nullable_to_non_nullable
          : monthlyLimit as num?,
      spent: spent == const $CopyWithPlaceholder()
          ? _value.spent
          // ignore: cast_nullable_to_non_nullable
          : spent as num?,
      remaining: remaining == const $CopyWithPlaceholder()
          ? _value.remaining
          // ignore: cast_nullable_to_non_nullable
          : remaining as num?,
      percentUsed: percentUsed == const $CopyWithPlaceholder()
          ? _value.percentUsed
          // ignore: cast_nullable_to_non_nullable
          : percentUsed as num?,
      projectedSpend: projectedSpend == const $CopyWithPlaceholder()
          ? _value.projectedSpend
          // ignore: cast_nullable_to_non_nullable
          : projectedSpend as num?,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as BudgetStatusStatusEnum?,
    );
  }
}

extension $BudgetStatusCopyWith on BudgetStatus {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfBudgetStatus.copyWith(...)` or `instanceOfBudgetStatus.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$BudgetStatusCWProxy get copyWith => _$BudgetStatusCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BudgetStatus _$BudgetStatusFromJson(Map<String, dynamic> json) =>
    $checkedCreate('BudgetStatus', json, ($checkedConvert) {
      final val = BudgetStatus(
        categoryId: $checkedConvert('categoryId', (v) => (v as num?)?.toInt()),
        category: $checkedConvert('category', (v) => v as String?),
        month: $checkedConvert('month', (v) => v as String?),
        monthlyLimit: $checkedConvert('monthlyLimit', (v) => v as num?),
        spent: $checkedConvert('spent', (v) => v as num?),
        remaining: $checkedConvert('remaining', (v) => v as num?),
        percentUsed: $checkedConvert('percentUsed', (v) => v as num?),
        projectedSpend: $checkedConvert('projectedSpend', (v) => v as num?),
        status: $checkedConvert(
          'status',
          (v) => $enumDecodeNullable(_$BudgetStatusStatusEnumEnumMap, v),
        ),
      );
      return val;
    });

Map<String, dynamic> _$BudgetStatusToJson(BudgetStatus instance) =>
    <String, dynamic>{
      'categoryId': ?instance.categoryId,
      'category': ?instance.category,
      'month': ?instance.month,
      'monthlyLimit': ?instance.monthlyLimit,
      'spent': ?instance.spent,
      'remaining': ?instance.remaining,
      'percentUsed': ?instance.percentUsed,
      'projectedSpend': ?instance.projectedSpend,
      'status': ?_$BudgetStatusStatusEnumEnumMap[instance.status],
    };

const _$BudgetStatusStatusEnumEnumMap = {
  BudgetStatusStatusEnum.ON_TRACK: 'ON_TRACK',
  BudgetStatusStatusEnum.WARNING: 'WARNING',
  BudgetStatusStatusEnum.EXCEEDED: 'EXCEEDED',
};
