// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'what_if_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$WhatIfRequestCWProxy {
  WhatIfRequest months(int? months);

  WhatIfRequest incomeChangePercent(num? incomeChangePercent);

  WhatIfRequest extraMonthlyIncome(num? extraMonthlyIncome);

  WhatIfRequest categoryChanges(List<CategoryChange>? categoryChanges);

  WhatIfRequest oneOffs(List<OneOff>? oneOffs);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `WhatIfRequest(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// WhatIfRequest(...).copyWith(id: 12, name: "My name")
  /// ```
  WhatIfRequest call({
    int? months,
    num? incomeChangePercent,
    num? extraMonthlyIncome,
    List<CategoryChange>? categoryChanges,
    List<OneOff>? oneOffs,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfWhatIfRequest.copyWith(...)` or call `instanceOfWhatIfRequest.copyWith.fieldName(value)` for a single field.
class _$WhatIfRequestCWProxyImpl implements _$WhatIfRequestCWProxy {
  const _$WhatIfRequestCWProxyImpl(this._value);

  final WhatIfRequest _value;

  @override
  WhatIfRequest months(int? months) => call(months: months);

  @override
  WhatIfRequest incomeChangePercent(num? incomeChangePercent) =>
      call(incomeChangePercent: incomeChangePercent);

  @override
  WhatIfRequest extraMonthlyIncome(num? extraMonthlyIncome) =>
      call(extraMonthlyIncome: extraMonthlyIncome);

  @override
  WhatIfRequest categoryChanges(List<CategoryChange>? categoryChanges) =>
      call(categoryChanges: categoryChanges);

  @override
  WhatIfRequest oneOffs(List<OneOff>? oneOffs) => call(oneOffs: oneOffs);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `WhatIfRequest(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// WhatIfRequest(...).copyWith(id: 12, name: "My name")
  /// ```
  WhatIfRequest call({
    Object? months = const $CopyWithPlaceholder(),
    Object? incomeChangePercent = const $CopyWithPlaceholder(),
    Object? extraMonthlyIncome = const $CopyWithPlaceholder(),
    Object? categoryChanges = const $CopyWithPlaceholder(),
    Object? oneOffs = const $CopyWithPlaceholder(),
  }) {
    return WhatIfRequest(
      months: months == const $CopyWithPlaceholder()
          ? _value.months
          // ignore: cast_nullable_to_non_nullable
          : months as int?,
      incomeChangePercent: incomeChangePercent == const $CopyWithPlaceholder()
          ? _value.incomeChangePercent
          // ignore: cast_nullable_to_non_nullable
          : incomeChangePercent as num?,
      extraMonthlyIncome: extraMonthlyIncome == const $CopyWithPlaceholder()
          ? _value.extraMonthlyIncome
          // ignore: cast_nullable_to_non_nullable
          : extraMonthlyIncome as num?,
      categoryChanges: categoryChanges == const $CopyWithPlaceholder()
          ? _value.categoryChanges
          // ignore: cast_nullable_to_non_nullable
          : categoryChanges as List<CategoryChange>?,
      oneOffs: oneOffs == const $CopyWithPlaceholder()
          ? _value.oneOffs
          // ignore: cast_nullable_to_non_nullable
          : oneOffs as List<OneOff>?,
    );
  }
}

extension $WhatIfRequestCopyWith on WhatIfRequest {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfWhatIfRequest.copyWith(...)` or `instanceOfWhatIfRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$WhatIfRequestCWProxy get copyWith => _$WhatIfRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WhatIfRequest _$WhatIfRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('WhatIfRequest', json, ($checkedConvert) {
      final val = WhatIfRequest(
        months: $checkedConvert('months', (v) => (v as num?)?.toInt()),
        incomeChangePercent: $checkedConvert(
          'incomeChangePercent',
          (v) => v as num?,
        ),
        extraMonthlyIncome: $checkedConvert(
          'extraMonthlyIncome',
          (v) => v as num?,
        ),
        categoryChanges: $checkedConvert(
          'categoryChanges',
          (v) => (v as List<dynamic>?)
              ?.map((e) => CategoryChange.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        oneOffs: $checkedConvert(
          'oneOffs',
          (v) => (v as List<dynamic>?)
              ?.map((e) => OneOff.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$WhatIfRequestToJson(
  WhatIfRequest instance,
) => <String, dynamic>{
  'months': ?instance.months,
  'incomeChangePercent': ?instance.incomeChangePercent,
  'extraMonthlyIncome': ?instance.extraMonthlyIncome,
  'categoryChanges': ?instance.categoryChanges?.map((e) => e.toJson()).toList(),
  'oneOffs': ?instance.oneOffs?.map((e) => e.toJson()).toList(),
};
