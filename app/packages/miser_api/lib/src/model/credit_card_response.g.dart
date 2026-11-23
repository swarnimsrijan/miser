// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_card_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CreditCardResponseCWProxy {
  CreditCardResponse id(int? id);

  CreditCardResponse bankId(int? bankId);

  CreditCardResponse bankName(String? bankName);

  CreditCardResponse cardName(String? cardName);

  CreditCardResponse maskedNumber(String? maskedNumber);

  CreditCardResponse creditLimit(num? creditLimit);

  CreditCardResponse billingDate(int? billingDate);

  CreditCardResponse dueDate(int? dueDate);

  CreditCardResponse currency(String? currency);

  CreditCardResponse status(String? status);

  CreditCardResponse createdAt(DateTime? createdAt);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `CreditCardResponse(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// CreditCardResponse(...).copyWith(id: 12, name: "My name")
  /// ```
  CreditCardResponse call({
    int? id,
    int? bankId,
    String? bankName,
    String? cardName,
    String? maskedNumber,
    num? creditLimit,
    int? billingDate,
    int? dueDate,
    String? currency,
    String? status,
    DateTime? createdAt,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfCreditCardResponse.copyWith(...)` or call `instanceOfCreditCardResponse.copyWith.fieldName(value)` for a single field.
class _$CreditCardResponseCWProxyImpl implements _$CreditCardResponseCWProxy {
  const _$CreditCardResponseCWProxyImpl(this._value);

  final CreditCardResponse _value;

  @override
  CreditCardResponse id(int? id) => call(id: id);

  @override
  CreditCardResponse bankId(int? bankId) => call(bankId: bankId);

  @override
  CreditCardResponse bankName(String? bankName) => call(bankName: bankName);

  @override
  CreditCardResponse cardName(String? cardName) => call(cardName: cardName);

  @override
  CreditCardResponse maskedNumber(String? maskedNumber) =>
      call(maskedNumber: maskedNumber);

  @override
  CreditCardResponse creditLimit(num? creditLimit) =>
      call(creditLimit: creditLimit);

  @override
  CreditCardResponse billingDate(int? billingDate) =>
      call(billingDate: billingDate);

  @override
  CreditCardResponse dueDate(int? dueDate) => call(dueDate: dueDate);

  @override
  CreditCardResponse currency(String? currency) => call(currency: currency);

  @override
  CreditCardResponse status(String? status) => call(status: status);

  @override
  CreditCardResponse createdAt(DateTime? createdAt) =>
      call(createdAt: createdAt);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `CreditCardResponse(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// CreditCardResponse(...).copyWith(id: 12, name: "My name")
  /// ```
  CreditCardResponse call({
    Object? id = const $CopyWithPlaceholder(),
    Object? bankId = const $CopyWithPlaceholder(),
    Object? bankName = const $CopyWithPlaceholder(),
    Object? cardName = const $CopyWithPlaceholder(),
    Object? maskedNumber = const $CopyWithPlaceholder(),
    Object? creditLimit = const $CopyWithPlaceholder(),
    Object? billingDate = const $CopyWithPlaceholder(),
    Object? dueDate = const $CopyWithPlaceholder(),
    Object? currency = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
  }) {
    return CreditCardResponse(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int?,
      bankId: bankId == const $CopyWithPlaceholder()
          ? _value.bankId
          // ignore: cast_nullable_to_non_nullable
          : bankId as int?,
      bankName: bankName == const $CopyWithPlaceholder()
          ? _value.bankName
          // ignore: cast_nullable_to_non_nullable
          : bankName as String?,
      cardName: cardName == const $CopyWithPlaceholder()
          ? _value.cardName
          // ignore: cast_nullable_to_non_nullable
          : cardName as String?,
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
      currency: currency == const $CopyWithPlaceholder()
          ? _value.currency
          // ignore: cast_nullable_to_non_nullable
          : currency as String?,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as String?,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime?,
    );
  }
}

extension $CreditCardResponseCopyWith on CreditCardResponse {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfCreditCardResponse.copyWith(...)` or `instanceOfCreditCardResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CreditCardResponseCWProxy get copyWith =>
      _$CreditCardResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreditCardResponse _$CreditCardResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('CreditCardResponse', json, ($checkedConvert) {
      final val = CreditCardResponse(
        id: $checkedConvert('id', (v) => (v as num?)?.toInt()),
        bankId: $checkedConvert('bankId', (v) => (v as num?)?.toInt()),
        bankName: $checkedConvert('bankName', (v) => v as String?),
        cardName: $checkedConvert('cardName', (v) => v as String?),
        maskedNumber: $checkedConvert('maskedNumber', (v) => v as String?),
        creditLimit: $checkedConvert('creditLimit', (v) => v as num?),
        billingDate: $checkedConvert(
          'billingDate',
          (v) => (v as num?)?.toInt(),
        ),
        dueDate: $checkedConvert('dueDate', (v) => (v as num?)?.toInt()),
        currency: $checkedConvert('currency', (v) => v as String?),
        status: $checkedConvert('status', (v) => v as String?),
        createdAt: $checkedConvert(
          'createdAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
      );
      return val;
    });

Map<String, dynamic> _$CreditCardResponseToJson(CreditCardResponse instance) =>
    <String, dynamic>{
      'id': ?instance.id,
      'bankId': ?instance.bankId,
      'bankName': ?instance.bankName,
      'cardName': ?instance.cardName,
      'maskedNumber': ?instance.maskedNumber,
      'creditLimit': ?instance.creditLimit,
      'billingDate': ?instance.billingDate,
      'dueDate': ?instance.dueDate,
      'currency': ?instance.currency,
      'status': ?instance.status,
      'createdAt': ?instance.createdAt?.toIso8601String(),
    };
