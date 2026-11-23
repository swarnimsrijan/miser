// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurring_payment.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$RecurringPaymentCWProxy {
  RecurringPayment name(String? name);

  RecurringPayment category(String? category);

  RecurringPayment frequency(RecurringPaymentFrequencyEnum? frequency);

  RecurringPayment typicalAmount(num? typicalAmount);

  RecurringPayment monthlyEquivalent(num? monthlyEquivalent);

  RecurringPayment occurrences(int? occurrences);

  RecurringPayment lastDate(DateTime? lastDate);

  RecurringPayment nextExpectedDate(DateTime? nextExpectedDate);

  RecurringPayment active(bool? active);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `RecurringPayment(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// RecurringPayment(...).copyWith(id: 12, name: "My name")
  /// ```
  RecurringPayment call({
    String? name,
    String? category,
    RecurringPaymentFrequencyEnum? frequency,
    num? typicalAmount,
    num? monthlyEquivalent,
    int? occurrences,
    DateTime? lastDate,
    DateTime? nextExpectedDate,
    bool? active,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfRecurringPayment.copyWith(...)` or call `instanceOfRecurringPayment.copyWith.fieldName(value)` for a single field.
class _$RecurringPaymentCWProxyImpl implements _$RecurringPaymentCWProxy {
  const _$RecurringPaymentCWProxyImpl(this._value);

  final RecurringPayment _value;

  @override
  RecurringPayment name(String? name) => call(name: name);

  @override
  RecurringPayment category(String? category) => call(category: category);

  @override
  RecurringPayment frequency(RecurringPaymentFrequencyEnum? frequency) =>
      call(frequency: frequency);

  @override
  RecurringPayment typicalAmount(num? typicalAmount) =>
      call(typicalAmount: typicalAmount);

  @override
  RecurringPayment monthlyEquivalent(num? monthlyEquivalent) =>
      call(monthlyEquivalent: monthlyEquivalent);

  @override
  RecurringPayment occurrences(int? occurrences) =>
      call(occurrences: occurrences);

  @override
  RecurringPayment lastDate(DateTime? lastDate) => call(lastDate: lastDate);

  @override
  RecurringPayment nextExpectedDate(DateTime? nextExpectedDate) =>
      call(nextExpectedDate: nextExpectedDate);

  @override
  RecurringPayment active(bool? active) => call(active: active);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `RecurringPayment(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// RecurringPayment(...).copyWith(id: 12, name: "My name")
  /// ```
  RecurringPayment call({
    Object? name = const $CopyWithPlaceholder(),
    Object? category = const $CopyWithPlaceholder(),
    Object? frequency = const $CopyWithPlaceholder(),
    Object? typicalAmount = const $CopyWithPlaceholder(),
    Object? monthlyEquivalent = const $CopyWithPlaceholder(),
    Object? occurrences = const $CopyWithPlaceholder(),
    Object? lastDate = const $CopyWithPlaceholder(),
    Object? nextExpectedDate = const $CopyWithPlaceholder(),
    Object? active = const $CopyWithPlaceholder(),
  }) {
    return RecurringPayment(
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String?,
      category: category == const $CopyWithPlaceholder()
          ? _value.category
          // ignore: cast_nullable_to_non_nullable
          : category as String?,
      frequency: frequency == const $CopyWithPlaceholder()
          ? _value.frequency
          // ignore: cast_nullable_to_non_nullable
          : frequency as RecurringPaymentFrequencyEnum?,
      typicalAmount: typicalAmount == const $CopyWithPlaceholder()
          ? _value.typicalAmount
          // ignore: cast_nullable_to_non_nullable
          : typicalAmount as num?,
      monthlyEquivalent: monthlyEquivalent == const $CopyWithPlaceholder()
          ? _value.monthlyEquivalent
          // ignore: cast_nullable_to_non_nullable
          : monthlyEquivalent as num?,
      occurrences: occurrences == const $CopyWithPlaceholder()
          ? _value.occurrences
          // ignore: cast_nullable_to_non_nullable
          : occurrences as int?,
      lastDate: lastDate == const $CopyWithPlaceholder()
          ? _value.lastDate
          // ignore: cast_nullable_to_non_nullable
          : lastDate as DateTime?,
      nextExpectedDate: nextExpectedDate == const $CopyWithPlaceholder()
          ? _value.nextExpectedDate
          // ignore: cast_nullable_to_non_nullable
          : nextExpectedDate as DateTime?,
      active: active == const $CopyWithPlaceholder()
          ? _value.active
          // ignore: cast_nullable_to_non_nullable
          : active as bool?,
    );
  }
}

extension $RecurringPaymentCopyWith on RecurringPayment {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfRecurringPayment.copyWith(...)` or `instanceOfRecurringPayment.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$RecurringPaymentCWProxy get copyWith => _$RecurringPaymentCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecurringPayment _$RecurringPaymentFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('RecurringPayment', json, ($checkedConvert) {
  final val = RecurringPayment(
    name: $checkedConvert('name', (v) => v as String?),
    category: $checkedConvert('category', (v) => v as String?),
    frequency: $checkedConvert(
      'frequency',
      (v) => $enumDecodeNullable(_$RecurringPaymentFrequencyEnumEnumMap, v),
    ),
    typicalAmount: $checkedConvert('typicalAmount', (v) => v as num?),
    monthlyEquivalent: $checkedConvert('monthlyEquivalent', (v) => v as num?),
    occurrences: $checkedConvert('occurrences', (v) => (v as num?)?.toInt()),
    lastDate: $checkedConvert(
      'lastDate',
      (v) => v == null ? null : DateTime.parse(v as String),
    ),
    nextExpectedDate: $checkedConvert(
      'nextExpectedDate',
      (v) => v == null ? null : DateTime.parse(v as String),
    ),
    active: $checkedConvert('active', (v) => v as bool?),
  );
  return val;
});

Map<String, dynamic> _$RecurringPaymentToJson(RecurringPayment instance) =>
    <String, dynamic>{
      'name': ?instance.name,
      'category': ?instance.category,
      'frequency': ?_$RecurringPaymentFrequencyEnumEnumMap[instance.frequency],
      'typicalAmount': ?instance.typicalAmount,
      'monthlyEquivalent': ?instance.monthlyEquivalent,
      'occurrences': ?instance.occurrences,
      'lastDate': ?instance.lastDate?.toIso8601String(),
      'nextExpectedDate': ?instance.nextExpectedDate?.toIso8601String(),
      'active': ?instance.active,
    };

const _$RecurringPaymentFrequencyEnumEnumMap = {
  RecurringPaymentFrequencyEnum.WEEKLY: 'WEEKLY',
  RecurringPaymentFrequencyEnum.MONTHLY: 'MONTHLY',
  RecurringPaymentFrequencyEnum.QUARTERLY: 'QUARTERLY',
  RecurringPaymentFrequencyEnum.YEARLY: 'YEARLY',
};
