// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'one_off.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$OneOffCWProxy {
  OneOff month(String? month);

  OneOff amount(num? amount);

  OneOff label(String? label);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `OneOff(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// OneOff(...).copyWith(id: 12, name: "My name")
  /// ```
  OneOff call({String? month, num? amount, String? label});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfOneOff.copyWith(...)` or call `instanceOfOneOff.copyWith.fieldName(value)` for a single field.
class _$OneOffCWProxyImpl implements _$OneOffCWProxy {
  const _$OneOffCWProxyImpl(this._value);

  final OneOff _value;

  @override
  OneOff month(String? month) => call(month: month);

  @override
  OneOff amount(num? amount) => call(amount: amount);

  @override
  OneOff label(String? label) => call(label: label);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `OneOff(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// OneOff(...).copyWith(id: 12, name: "My name")
  /// ```
  OneOff call({
    Object? month = const $CopyWithPlaceholder(),
    Object? amount = const $CopyWithPlaceholder(),
    Object? label = const $CopyWithPlaceholder(),
  }) {
    return OneOff(
      month: month == const $CopyWithPlaceholder()
          ? _value.month
          // ignore: cast_nullable_to_non_nullable
          : month as String?,
      amount: amount == const $CopyWithPlaceholder()
          ? _value.amount
          // ignore: cast_nullable_to_non_nullable
          : amount as num?,
      label: label == const $CopyWithPlaceholder()
          ? _value.label
          // ignore: cast_nullable_to_non_nullable
          : label as String?,
    );
  }
}

extension $OneOffCopyWith on OneOff {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfOneOff.copyWith(...)` or `instanceOfOneOff.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$OneOffCWProxy get copyWith => _$OneOffCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OneOff _$OneOffFromJson(Map<String, dynamic> json) =>
    $checkedCreate('OneOff', json, ($checkedConvert) {
      final val = OneOff(
        month: $checkedConvert('month', (v) => v as String?),
        amount: $checkedConvert('amount', (v) => v as num?),
        label: $checkedConvert('label', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$OneOffToJson(OneOff instance) => <String, dynamic>{
  'month': ?instance.month,
  'amount': ?instance.amount,
  'label': ?instance.label,
};
