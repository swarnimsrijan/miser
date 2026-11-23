// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_account_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CreateAccountRequestCWProxy {
  CreateAccountRequest bankId(int bankId);

  CreateAccountRequest nickname(String? nickname);

  CreateAccountRequest accountNumberMasked(String? accountNumberMasked);

  CreateAccountRequest accountType(
    CreateAccountRequestAccountTypeEnum accountType,
  );

  CreateAccountRequest currency(String currency);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `CreateAccountRequest(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// CreateAccountRequest(...).copyWith(id: 12, name: "My name")
  /// ```
  CreateAccountRequest call({
    int bankId,
    String? nickname,
    String? accountNumberMasked,
    CreateAccountRequestAccountTypeEnum accountType,
    String currency,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfCreateAccountRequest.copyWith(...)` or call `instanceOfCreateAccountRequest.copyWith.fieldName(value)` for a single field.
class _$CreateAccountRequestCWProxyImpl
    implements _$CreateAccountRequestCWProxy {
  const _$CreateAccountRequestCWProxyImpl(this._value);

  final CreateAccountRequest _value;

  @override
  CreateAccountRequest bankId(int bankId) => call(bankId: bankId);

  @override
  CreateAccountRequest nickname(String? nickname) => call(nickname: nickname);

  @override
  CreateAccountRequest accountNumberMasked(String? accountNumberMasked) =>
      call(accountNumberMasked: accountNumberMasked);

  @override
  CreateAccountRequest accountType(
    CreateAccountRequestAccountTypeEnum accountType,
  ) => call(accountType: accountType);

  @override
  CreateAccountRequest currency(String currency) => call(currency: currency);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `CreateAccountRequest(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// CreateAccountRequest(...).copyWith(id: 12, name: "My name")
  /// ```
  CreateAccountRequest call({
    Object? bankId = const $CopyWithPlaceholder(),
    Object? nickname = const $CopyWithPlaceholder(),
    Object? accountNumberMasked = const $CopyWithPlaceholder(),
    Object? accountType = const $CopyWithPlaceholder(),
    Object? currency = const $CopyWithPlaceholder(),
  }) {
    return CreateAccountRequest(
      bankId: bankId == const $CopyWithPlaceholder() || bankId == null
          ? _value.bankId
          // ignore: cast_nullable_to_non_nullable
          : bankId as int,
      nickname: nickname == const $CopyWithPlaceholder()
          ? _value.nickname
          // ignore: cast_nullable_to_non_nullable
          : nickname as String?,
      accountNumberMasked: accountNumberMasked == const $CopyWithPlaceholder()
          ? _value.accountNumberMasked
          // ignore: cast_nullable_to_non_nullable
          : accountNumberMasked as String?,
      accountType:
          accountType == const $CopyWithPlaceholder() || accountType == null
          ? _value.accountType
          // ignore: cast_nullable_to_non_nullable
          : accountType as CreateAccountRequestAccountTypeEnum,
      currency: currency == const $CopyWithPlaceholder() || currency == null
          ? _value.currency
          // ignore: cast_nullable_to_non_nullable
          : currency as String,
    );
  }
}

extension $CreateAccountRequestCopyWith on CreateAccountRequest {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfCreateAccountRequest.copyWith(...)` or `instanceOfCreateAccountRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CreateAccountRequestCWProxy get copyWith =>
      _$CreateAccountRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateAccountRequest _$CreateAccountRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('CreateAccountRequest', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['bankId', 'accountType', 'currency']);
  final val = CreateAccountRequest(
    bankId: $checkedConvert('bankId', (v) => (v as num).toInt()),
    nickname: $checkedConvert('nickname', (v) => v as String?),
    accountNumberMasked: $checkedConvert(
      'accountNumberMasked',
      (v) => v as String?,
    ),
    accountType: $checkedConvert(
      'accountType',
      (v) => $enumDecode(_$CreateAccountRequestAccountTypeEnumEnumMap, v),
    ),
    currency: $checkedConvert('currency', (v) => v as String),
  );
  return val;
});

Map<String, dynamic> _$CreateAccountRequestToJson(
  CreateAccountRequest instance,
) => <String, dynamic>{
  'bankId': instance.bankId,
  'nickname': ?instance.nickname,
  'accountNumberMasked': ?instance.accountNumberMasked,
  'accountType':
      _$CreateAccountRequestAccountTypeEnumEnumMap[instance.accountType]!,
  'currency': instance.currency,
};

const _$CreateAccountRequestAccountTypeEnumEnumMap = {
  CreateAccountRequestAccountTypeEnum.SAVINGS: 'SAVINGS',
  CreateAccountRequestAccountTypeEnum.CURRENT: 'CURRENT',
  CreateAccountRequestAccountTypeEnum.SALARY: 'SALARY',
  CreateAccountRequestAccountTypeEnum.FD: 'FD',
  CreateAccountRequestAccountTypeEnum.RD: 'RD',
};
