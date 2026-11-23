// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AccountResponseCWProxy {
  AccountResponse id(int? id);

  AccountResponse bankId(int? bankId);

  AccountResponse bankName(String? bankName);

  AccountResponse nickname(String? nickname);

  AccountResponse accountNumberMasked(String? accountNumberMasked);

  AccountResponse accountType(AccountResponseAccountTypeEnum? accountType);

  AccountResponse currency(String? currency);

  AccountResponse status(String? status);

  AccountResponse createdAt(DateTime? createdAt);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `AccountResponse(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// AccountResponse(...).copyWith(id: 12, name: "My name")
  /// ```
  AccountResponse call({
    int? id,
    int? bankId,
    String? bankName,
    String? nickname,
    String? accountNumberMasked,
    AccountResponseAccountTypeEnum? accountType,
    String? currency,
    String? status,
    DateTime? createdAt,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfAccountResponse.copyWith(...)` or call `instanceOfAccountResponse.copyWith.fieldName(value)` for a single field.
class _$AccountResponseCWProxyImpl implements _$AccountResponseCWProxy {
  const _$AccountResponseCWProxyImpl(this._value);

  final AccountResponse _value;

  @override
  AccountResponse id(int? id) => call(id: id);

  @override
  AccountResponse bankId(int? bankId) => call(bankId: bankId);

  @override
  AccountResponse bankName(String? bankName) => call(bankName: bankName);

  @override
  AccountResponse nickname(String? nickname) => call(nickname: nickname);

  @override
  AccountResponse accountNumberMasked(String? accountNumberMasked) =>
      call(accountNumberMasked: accountNumberMasked);

  @override
  AccountResponse accountType(AccountResponseAccountTypeEnum? accountType) =>
      call(accountType: accountType);

  @override
  AccountResponse currency(String? currency) => call(currency: currency);

  @override
  AccountResponse status(String? status) => call(status: status);

  @override
  AccountResponse createdAt(DateTime? createdAt) => call(createdAt: createdAt);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `AccountResponse(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// AccountResponse(...).copyWith(id: 12, name: "My name")
  /// ```
  AccountResponse call({
    Object? id = const $CopyWithPlaceholder(),
    Object? bankId = const $CopyWithPlaceholder(),
    Object? bankName = const $CopyWithPlaceholder(),
    Object? nickname = const $CopyWithPlaceholder(),
    Object? accountNumberMasked = const $CopyWithPlaceholder(),
    Object? accountType = const $CopyWithPlaceholder(),
    Object? currency = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
  }) {
    return AccountResponse(
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
      nickname: nickname == const $CopyWithPlaceholder()
          ? _value.nickname
          // ignore: cast_nullable_to_non_nullable
          : nickname as String?,
      accountNumberMasked: accountNumberMasked == const $CopyWithPlaceholder()
          ? _value.accountNumberMasked
          // ignore: cast_nullable_to_non_nullable
          : accountNumberMasked as String?,
      accountType: accountType == const $CopyWithPlaceholder()
          ? _value.accountType
          // ignore: cast_nullable_to_non_nullable
          : accountType as AccountResponseAccountTypeEnum?,
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

extension $AccountResponseCopyWith on AccountResponse {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfAccountResponse.copyWith(...)` or `instanceOfAccountResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AccountResponseCWProxy get copyWith => _$AccountResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountResponse _$AccountResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AccountResponse', json, ($checkedConvert) {
      final val = AccountResponse(
        id: $checkedConvert('id', (v) => (v as num?)?.toInt()),
        bankId: $checkedConvert('bankId', (v) => (v as num?)?.toInt()),
        bankName: $checkedConvert('bankName', (v) => v as String?),
        nickname: $checkedConvert('nickname', (v) => v as String?),
        accountNumberMasked: $checkedConvert(
          'accountNumberMasked',
          (v) => v as String?,
        ),
        accountType: $checkedConvert(
          'accountType',
          (v) =>
              $enumDecodeNullable(_$AccountResponseAccountTypeEnumEnumMap, v),
        ),
        currency: $checkedConvert('currency', (v) => v as String?),
        status: $checkedConvert('status', (v) => v as String?),
        createdAt: $checkedConvert(
          'createdAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
      );
      return val;
    });

Map<String, dynamic> _$AccountResponseToJson(
  AccountResponse instance,
) => <String, dynamic>{
  'id': ?instance.id,
  'bankId': ?instance.bankId,
  'bankName': ?instance.bankName,
  'nickname': ?instance.nickname,
  'accountNumberMasked': ?instance.accountNumberMasked,
  'accountType': ?_$AccountResponseAccountTypeEnumEnumMap[instance.accountType],
  'currency': ?instance.currency,
  'status': ?instance.status,
  'createdAt': ?instance.createdAt?.toIso8601String(),
};

const _$AccountResponseAccountTypeEnumEnumMap = {
  AccountResponseAccountTypeEnum.SAVINGS: 'SAVINGS',
  AccountResponseAccountTypeEnum.CURRENT: 'CURRENT',
  AccountResponseAccountTypeEnum.SALARY: 'SALARY',
  AccountResponseAccountTypeEnum.FD: 'FD',
  AccountResponseAccountTypeEnum.RD: 'RD',
};
