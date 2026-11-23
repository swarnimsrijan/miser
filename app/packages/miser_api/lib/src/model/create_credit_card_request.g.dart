// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_credit_card_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CreateCreditCardRequestCWProxy {
  CreateCreditCardRequest bankId(int bankId);

  CreateCreditCardRequest cardName(String cardName);

  CreateCreditCardRequest maskedNumber(String? maskedNumber);

  CreateCreditCardRequest creditLimit(num? creditLimit);

  CreateCreditCardRequest billingDate(int? billingDate);

  CreateCreditCardRequest dueDate(int? dueDate);

  CreateCreditCardRequest currency(String currency);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `CreateCreditCardRequest(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// CreateCreditCardRequest(...).copyWith(id: 12, name: "My name")
  /// ```
  CreateCreditCardRequest call({
    int bankId,
    String cardName,
    String? maskedNumber,
    num? creditLimit,
    int? billingDate,
    int? dueDate,
    String currency,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfCreateCreditCardRequest.copyWith(...)` or call `instanceOfCreateCreditCardRequest.copyWith.fieldName(value)` for a single field.
class _$CreateCreditCardRequestCWProxyImpl
    implements _$CreateCreditCardRequestCWProxy {
  const _$CreateCreditCardRequestCWProxyImpl(this._value);

  final CreateCreditCardRequest _value;

  @override
  CreateCreditCardRequest bankId(int bankId) => call(bankId: bankId);

  @override
  CreateCreditCardRequest cardName(String cardName) => call(cardName: cardName);

  @override
  CreateCreditCardRequest maskedNumber(String? maskedNumber) =>
      call(maskedNumber: maskedNumber);

  @override
  CreateCreditCardRequest creditLimit(num? creditLimit) =>
      call(creditLimit: creditLimit);

  @override
  CreateCreditCardRequest billingDate(int? billingDate) =>
      call(billingDate: billingDate);

  @override
  CreateCreditCardRequest dueDate(int? dueDate) => call(dueDate: dueDate);

  @override
  CreateCreditCardRequest currency(String currency) => call(currency: currency);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `CreateCreditCardRequest(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// CreateCreditCardRequest(...).copyWith(id: 12, name: "My name")
  /// ```
  CreateCreditCardRequest call({
    Object? bankId = const $CopyWithPlaceholder(),
    Object? cardName = const $CopyWithPlaceholder(),
    Object? maskedNumber = const $CopyWithPlaceholder(),
    Object? creditLimit = const $CopyWithPlaceholder(),
    Object? billingDate = const $CopyWithPlaceholder(),
    Object? dueDate = const $CopyWithPlaceholder(),
    Object? currency = const $CopyWithPlaceholder(),
  }) {
    return CreateCreditCardRequest(
      bankId: bankId == const $CopyWithPlaceholder() || bankId == null
          ? _value.bankId
          // ignore: cast_nullable_to_non_nullable
          : bankId as int,
      cardName: cardName == const $CopyWithPlaceholder() || cardName == null
          ? _value.cardName
          // ignore: cast_nullable_to_non_nullable
          : cardName as String,
      maskedNumber: maskedNumber == const $CopyWithPlaceholder()
          ? _value.maskedNumber
          // ignore: cast_nullable_to_non_nullable
          : maskedNumber as String?,
      creditLimit: creditLimit == const $CopyWithPlaceholder()
          ? _value.creditLimit
          // ignore: cast_nullable_to_non_nullable
          : creditLimit as num?,
      billingDate: billingDate == const $CopyWithPlaceholder()
          ? _value.billingDate
          // ignore: cast_nullable_to_non_nullable
          : billingDate as int?,
      dueDate: dueDate == const $CopyWithPlaceholder()
          ? _value.dueDate
          // ignore: cast_nullable_to_non_nullable
          : dueDate as int?,
      currency: currency == const $CopyWithPlaceholder() || currency == null
          ? _value.currency
          // ignore: cast_nullable_to_non_nullable
          : currency as String,
    );
  }
}

extension $CreateCreditCardRequestCopyWith on CreateCreditCardRequest {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfCreateCreditCardRequest.copyWith(...)` or `instanceOfCreateCreditCardRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CreateCreditCardRequestCWProxy get copyWith =>
      _$CreateCreditCardRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateCreditCardRequest _$CreateCreditCardRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('CreateCreditCardRequest', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['bankId', 'cardName', 'currency']);
  final val = CreateCreditCardRequest(
    bankId: $checkedConvert('bankId', (v) => (v as num).toInt()),
    cardName: $checkedConvert('cardName', (v) => v as String),
    maskedNumber: $checkedConvert('maskedNumber', (v) => v as String?),
    creditLimit: $checkedConvert('creditLimit', (v) => v as num?),
    billingDate: $checkedConvert('billingDate', (v) => (v as num?)?.toInt()),
    dueDate: $checkedConvert('dueDate', (v) => (v as num?)?.toInt()),
    currency: $checkedConvert('currency', (v) => v as String),
  );
  return val;
});

Map<String, dynamic> _$CreateCreditCardRequestToJson(
  CreateCreditCardRequest instance,
) => <String, dynamic>{
  'bankId': instance.bankId,
  'cardName': instance.cardName,
  'maskedNumber': ?instance.maskedNumber,
  'creditLimit': ?instance.creditLimit,
  'billingDate': ?instance.billingDate,
  'dueDate': ?instance.dueDate,
  'currency': instance.currency,
};
