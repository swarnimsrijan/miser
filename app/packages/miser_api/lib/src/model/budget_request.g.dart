// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$BudgetRequestCWProxy {
  BudgetRequest monthlyLimit(num? monthlyLimit);

  BudgetRequest alertThresholdPercent(int? alertThresholdPercent);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `BudgetRequest(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// BudgetRequest(...).copyWith(id: 12, name: "My name")
  /// ```
  BudgetRequest call({num? monthlyLimit, int? alertThresholdPercent});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfBudgetRequest.copyWith(...)` or call `instanceOfBudgetRequest.copyWith.fieldName(value)` for a single field.
class _$BudgetRequestCWProxyImpl implements _$BudgetRequestCWProxy {
  const _$BudgetRequestCWProxyImpl(this._value);

  final BudgetRequest _value;

  @override
  BudgetRequest monthlyLimit(num? monthlyLimit) =>
      call(monthlyLimit: monthlyLimit);

  @override
  BudgetRequest alertThresholdPercent(int? alertThresholdPercent) =>
      call(alertThresholdPercent: alertThresholdPercent);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `BudgetRequest(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// BudgetRequest(...).copyWith(id: 12, name: "My name")
  /// ```
  BudgetRequest call({
    Object? monthlyLimit = const $CopyWithPlaceholder(),
    Object? alertThresholdPercent = const $CopyWithPlaceholder(),
  }) {
    return BudgetRequest(
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

extension $BudgetRequestCopyWith on BudgetRequest {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfBudgetRequest.copyWith(...)` or `instanceOfBudgetRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$BudgetRequestCWProxy get copyWith => _$BudgetRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BudgetRequest _$BudgetRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('BudgetRequest', json, ($checkedConvert) {
      final val = BudgetRequest(
        monthlyLimit: $checkedConvert('monthlyLimit', (v) => v as num?),
        alertThresholdPercent: $checkedConvert(
          'alertThresholdPercent',
          (v) => (v as num?)?.toInt(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$BudgetRequestToJson(BudgetRequest instance) =>
    <String, dynamic>{
      'monthlyLimit': ?instance.monthlyLimit,
      'alertThresholdPercent': ?instance.alertThresholdPercent,
    };
