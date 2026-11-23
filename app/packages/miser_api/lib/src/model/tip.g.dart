// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tip.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$TipCWProxy {
  Tip type(String? type);

  Tip severity(TipSeverityEnum? severity);

  Tip title(String? title);

  Tip message(String? message);

  Tip amount(num? amount);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `Tip(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// Tip(...).copyWith(id: 12, name: "My name")
  /// ```
  Tip call({
    String? type,
    TipSeverityEnum? severity,
    String? title,
    String? message,
    num? amount,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfTip.copyWith(...)` or call `instanceOfTip.copyWith.fieldName(value)` for a single field.
class _$TipCWProxyImpl implements _$TipCWProxy {
  const _$TipCWProxyImpl(this._value);

  final Tip _value;

  @override
  Tip type(String? type) => call(type: type);

  @override
  Tip severity(TipSeverityEnum? severity) => call(severity: severity);

  @override
  Tip title(String? title) => call(title: title);

  @override
  Tip message(String? message) => call(message: message);

  @override
  Tip amount(num? amount) => call(amount: amount);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `Tip(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// Tip(...).copyWith(id: 12, name: "My name")
  /// ```
  Tip call({
    Object? type = const $CopyWithPlaceholder(),
    Object? severity = const $CopyWithPlaceholder(),
    Object? title = const $CopyWithPlaceholder(),
    Object? message = const $CopyWithPlaceholder(),
    Object? amount = const $CopyWithPlaceholder(),
  }) {
    return Tip(
      type: type == const $CopyWithPlaceholder()
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as String?,
      severity: severity == const $CopyWithPlaceholder()
          ? _value.severity
          // ignore: cast_nullable_to_non_nullable
          : severity as TipSeverityEnum?,
      title: title == const $CopyWithPlaceholder()
          ? _value.title
          // ignore: cast_nullable_to_non_nullable
          : title as String?,
      message: message == const $CopyWithPlaceholder()
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String?,
      amount: amount == const $CopyWithPlaceholder()
          ? _value.amount
          // ignore: cast_nullable_to_non_nullable
          : amount as num?,
    );
  }
}

extension $TipCopyWith on Tip {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfTip.copyWith(...)` or `instanceOfTip.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$TipCWProxy get copyWith => _$TipCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tip _$TipFromJson(Map<String, dynamic> json) =>
    $checkedCreate('Tip', json, ($checkedConvert) {
      final val = Tip(
        type: $checkedConvert('type', (v) => v as String?),
        severity: $checkedConvert(
          'severity',
          (v) => $enumDecodeNullable(_$TipSeverityEnumEnumMap, v),
        ),
        title: $checkedConvert('title', (v) => v as String?),
        message: $checkedConvert('message', (v) => v as String?),
        amount: $checkedConvert('amount', (v) => v as num?),
      );
      return val;
    });

Map<String, dynamic> _$TipToJson(Tip instance) => <String, dynamic>{
  'type': ?instance.type,
  'severity': ?_$TipSeverityEnumEnumMap[instance.severity],
  'title': ?instance.title,
  'message': ?instance.message,
  'amount': ?instance.amount,
};

const _$TipSeverityEnumEnumMap = {
  TipSeverityEnum.INFO: 'INFO',
  TipSeverityEnum.WARNING: 'WARNING',
  TipSeverityEnum.ALERT: 'ALERT',
};
