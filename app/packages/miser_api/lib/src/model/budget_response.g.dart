// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$BudgetResponseCWProxy {
  BudgetResponse categoryId(int? categoryId);

  BudgetResponse category(String? category);

  BudgetResponse monthlyLimit(num? monthlyLimit);

  BudgetResponse alertThresholdPercent(int? alertThresholdPercent);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `BudgetResponse(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// BudgetResponse(...).copyWith(id: 12, name: "My name")
  /// ```
  BudgetResponse call({
    int? categoryId,
    String? category,
    num? monthlyLimit,
    int? alertThresholdPercent,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfBudgetResponse.copyWith(...)` or call `instanceOfBudgetResponse.copyWith.fieldName(value)` for a single field.
class _$BudgetResponseCWProxyImpl implements _$BudgetResponseCWProxy {
  const _$BudgetResponseCWProxyImpl(this._value);

  final BudgetResponse _value;

  @override
  BudgetResponse categoryId(int? categoryId) => call(categoryId: categoryId);

  @override
  BudgetResponse category(String? category) => call(category: category);

  @override
  BudgetResponse monthlyLimit(num? monthlyLimit) =>
      call(monthlyLimit: monthlyLimit);

  @override
  BudgetResponse alertThresholdPercent(int? alertThresholdPercent) =>
      call(alertThresholdPercent: alertThresholdPercent);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `BudgetResponse(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// BudgetResponse(...).copyWith(id: 12, name: "My name")
  /// ```
  BudgetResponse call({
    Object? categoryId = const $CopyWithPlaceholder(),
    Object? category = const $CopyWithPlaceholder(),
    Object? monthlyLimit = const $CopyWithPlaceholder(),
    Object? alertThresholdPercent = const $CopyWithPlaceholder(),
  }) {
    return BudgetResponse(
      categoryId: categoryId == const $CopyWithPlaceholder()
          ? _value.categoryId
          // ignore: cast_nullable_to_non_nullable
          : categoryId as int?,
      category: category == const $CopyWithPlaceholder()
          ? _value.category
          // ignore: cast_nullable_to_non_nullable
          : category as String?,
      monthlyLimit: monthlyLimit == const $CopyWithPlaceholder()
          ? _value.monthlyLimit
          // ignore: cast_nullable_to_non_nullable
          : monthlyLimit as num?,
      alertThresholdPercent:
          alertThresholdPercent == const $CopyWithPlaceholder()
          ? _value.alertThresholdPercent
          // ignore: cast_nullable_to_non_nullable
          : alertThresholdPercent as int?,
    );
  }
}

extension $BudgetResponseCopyWith on BudgetResponse {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfBudgetResponse.copyWith(...)` or `instanceOfBudgetResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$BudgetResponseCWProxy get copyWith => _$BudgetResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BudgetResponse _$BudgetResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('BudgetResponse', json, ($checkedConvert) {
      final val = BudgetResponse(
        categoryId: $checkedConvert('categoryId', (v) => (v as num?)?.toInt()),
        category: $checkedConvert('category', (v) => v as String?),
        monthlyLimit: $checkedConvert('monthlyLimit', (v) => v as num?),
        alertThresholdPercent: $checkedConvert(
          'alertThresholdPercent',
          (v) => (v as num?)?.toInt(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$BudgetResponseToJson(BudgetResponse instance) =>
    <String, dynamic>{
      'categoryId': ?instance.categoryId,
      'category': ?instance.category,
      'monthlyLimit': ?instance.monthlyLimit,
      'alertThresholdPercent': ?instance.alertThresholdPercent,
    };
