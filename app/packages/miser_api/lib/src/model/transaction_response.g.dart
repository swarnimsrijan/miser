// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$TransactionResponseCWProxy {
  TransactionResponse id(int? id);

  TransactionResponse transactionDate(DateTime? transactionDate);

  TransactionResponse description(String? description);

  TransactionResponse merchant(String? merchant);

  TransactionResponse categoryId(int? categoryId);

  TransactionResponse category(String? category);

  TransactionResponse subCategoryId(int? subCategoryId);

  TransactionResponse subCategory(String? subCategory);

  TransactionResponse amount(num? amount);

  TransactionResponse transactionType(
    TransactionResponseTransactionTypeEnum? transactionType,
  );

  TransactionResponse balance(num? balance);

  TransactionResponse currency(String? currency);

  TransactionResponse reference(String? reference);

  TransactionResponse accountId(int? accountId);

  TransactionResponse creditCardId(int? creditCardId);

  TransactionResponse transfer(bool? transfer);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `TransactionResponse(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// TransactionResponse(...).copyWith(id: 12, name: "My name")
  /// ```
  TransactionResponse call({
    int? id,
    DateTime? transactionDate,
    String? description,
    String? merchant,
    int? categoryId,
    String? category,
    int? subCategoryId,
    String? subCategory,
    num? amount,
    TransactionResponseTransactionTypeEnum? transactionType,
    num? balance,
    String? currency,
    String? reference,
    int? accountId,
    int? creditCardId,
    bool? transfer,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfTransactionResponse.copyWith(...)` or call `instanceOfTransactionResponse.copyWith.fieldName(value)` for a single field.
class _$TransactionResponseCWProxyImpl implements _$TransactionResponseCWProxy {
  const _$TransactionResponseCWProxyImpl(this._value);

  final TransactionResponse _value;

  @override
  TransactionResponse id(int? id) => call(id: id);

  @override
  TransactionResponse transactionDate(DateTime? transactionDate) =>
      call(transactionDate: transactionDate);

  @override
  TransactionResponse description(String? description) =>
      call(description: description);

  @override
  TransactionResponse merchant(String? merchant) => call(merchant: merchant);

  @override
  TransactionResponse categoryId(int? categoryId) =>
      call(categoryId: categoryId);

  @override
  TransactionResponse category(String? category) => call(category: category);

  @override
  TransactionResponse subCategoryId(int? subCategoryId) =>
      call(subCategoryId: subCategoryId);

  @override
  TransactionResponse subCategory(String? subCategory) =>
      call(subCategory: subCategory);

  @override
  TransactionResponse amount(num? amount) => call(amount: amount);

  @override
  TransactionResponse transactionType(
    TransactionResponseTransactionTypeEnum? transactionType,
  ) => call(transactionType: transactionType);

  @override
  TransactionResponse balance(num? balance) => call(balance: balance);

  @override
  TransactionResponse currency(String? currency) => call(currency: currency);

  @override
  TransactionResponse reference(String? reference) =>
      call(reference: reference);

  @override
  TransactionResponse accountId(int? accountId) => call(accountId: accountId);

  @override
  TransactionResponse creditCardId(int? creditCardId) =>
      call(creditCardId: creditCardId);

  @override
  TransactionResponse transfer(bool? transfer) => call(transfer: transfer);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `TransactionResponse(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// TransactionResponse(...).copyWith(id: 12, name: "My name")
  /// ```
  TransactionResponse call({
    Object? id = const $CopyWithPlaceholder(),
    Object? transactionDate = const $CopyWithPlaceholder(),
    Object? description = const $CopyWithPlaceholder(),
    Object? merchant = const $CopyWithPlaceholder(),
    Object? categoryId = const $CopyWithPlaceholder(),
    Object? category = const $CopyWithPlaceholder(),
    Object? subCategoryId = const $CopyWithPlaceholder(),
    Object? subCategory = const $CopyWithPlaceholder(),
    Object? amount = const $CopyWithPlaceholder(),
    Object? transactionType = const $CopyWithPlaceholder(),
    Object? balance = const $CopyWithPlaceholder(),
    Object? currency = const $CopyWithPlaceholder(),
    Object? reference = const $CopyWithPlaceholder(),
    Object? accountId = const $CopyWithPlaceholder(),
    Object? creditCardId = const $CopyWithPlaceholder(),
    Object? transfer = const $CopyWithPlaceholder(),
  }) {
    return TransactionResponse(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int?,
      transactionDate: transactionDate == const $CopyWithPlaceholder()
          ? _value.transactionDate
          // ignore: cast_nullable_to_non_nullable
          : transactionDate as DateTime?,
      description: description == const $CopyWithPlaceholder()
          ? _value.description
          // ignore: cast_nullable_to_non_nullable
          : description as String?,
      merchant: merchant == const $CopyWithPlaceholder()
          ? _value.merchant
          // ignore: cast_nullable_to_non_nullable
          : merchant as String?,
      categoryId: categoryId == const $CopyWithPlaceholder()
          ? _value.categoryId
          // ignore: cast_nullable_to_non_nullable
          : categoryId as int?,
      category: category == const $CopyWithPlaceholder()
          ? _value.category
          // ignore: cast_nullable_to_non_nullable
          : category as String?,
      subCategoryId: subCategoryId == const $CopyWithPlaceholder()
          ? _value.subCategoryId
          // ignore: cast_nullable_to_non_nullable
          : subCategoryId as int?,
      subCategory: subCategory == const $CopyWithPlaceholder()
          ? _value.subCategory
          // ignore: cast_nullable_to_non_nullable
          : subCategory as String?,
      amount: amount == const $CopyWithPlaceholder()
          ? _value.amount
          // ignore: cast_nullable_to_non_nullable
          : amount as num?,
      transactionType: transactionType == const $CopyWithPlaceholder()
          ? _value.transactionType
          // ignore: cast_nullable_to_non_nullable
          : transactionType as TransactionResponseTransactionTypeEnum?,
      balance: balance == const $CopyWithPlaceholder()
          ? _value.balance
          // ignore: cast_nullable_to_non_nullable
          : balance as num?,
      currency: currency == const $CopyWithPlaceholder()
          ? _value.currency
          // ignore: cast_nullable_to_non_nullable
          : currency as String?,
      reference: reference == const $CopyWithPlaceholder()
          ? _value.reference
          // ignore: cast_nullable_to_non_nullable
          : reference as String?,
      accountId: accountId == const $CopyWithPlaceholder()
          ? _value.accountId
          // ignore: cast_nullable_to_non_nullable
          : accountId as int?,
      creditCardId: creditCardId == const $CopyWithPlaceholder()
          ? _value.creditCardId
          // ignore: cast_nullable_to_non_nullable
          : creditCardId as int?,
      transfer: transfer == const $CopyWithPlaceholder()
          ? _value.transfer
          // ignore: cast_nullable_to_non_nullable
          : transfer as bool?,
    );
  }
}

extension $TransactionResponseCopyWith on TransactionResponse {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfTransactionResponse.copyWith(...)` or `instanceOfTransactionResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$TransactionResponseCWProxy get copyWith =>
      _$TransactionResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionResponse _$TransactionResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('TransactionResponse', json, ($checkedConvert) {
      final val = TransactionResponse(
        id: $checkedConvert('id', (v) => (v as num?)?.toInt()),
        transactionDate: $checkedConvert(
          'transactionDate',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        description: $checkedConvert('description', (v) => v as String?),
        merchant: $checkedConvert('merchant', (v) => v as String?),
        categoryId: $checkedConvert('categoryId', (v) => (v as num?)?.toInt()),
        category: $checkedConvert('category', (v) => v as String?),
        subCategoryId: $checkedConvert(
          'subCategoryId',
          (v) => (v as num?)?.toInt(),
        ),
        subCategory: $checkedConvert('subCategory', (v) => v as String?),
        amount: $checkedConvert('amount', (v) => v as num?),
        transactionType: $checkedConvert(
          'transactionType',
          (v) => $enumDecodeNullable(
            _$TransactionResponseTransactionTypeEnumEnumMap,
            v,
          ),
        ),
        balance: $checkedConvert('balance', (v) => v as num?),
        currency: $checkedConvert('currency', (v) => v as String?),
        reference: $checkedConvert('reference', (v) => v as String?),
        accountId: $checkedConvert('accountId', (v) => (v as num?)?.toInt()),
        creditCardId: $checkedConvert(
          'creditCardId',
          (v) => (v as num?)?.toInt(),
        ),
        transfer: $checkedConvert('transfer', (v) => v as bool?),
      );
      return val;
    });

Map<String, dynamic> _$TransactionResponseToJson(
  TransactionResponse instance,
) => <String, dynamic>{
  'id': ?instance.id,
  'transactionDate': ?instance.transactionDate?.toIso8601String(),
  'description': ?instance.description,
  'merchant': ?instance.merchant,
  'categoryId': ?instance.categoryId,
  'category': ?instance.category,
  'subCategoryId': ?instance.subCategoryId,
  'subCategory': ?instance.subCategory,
  'amount': ?instance.amount,
  'transactionType':
      ?_$TransactionResponseTransactionTypeEnumEnumMap[instance
          .transactionType],
  'balance': ?instance.balance,
  'currency': ?instance.currency,
  'reference': ?instance.reference,
  'accountId': ?instance.accountId,
  'creditCardId': ?instance.creditCardId,
  'transfer': ?instance.transfer,
};

const _$TransactionResponseTransactionTypeEnumEnumMap = {
  TransactionResponseTransactionTypeEnum.CREDIT: 'CREDIT',
  TransactionResponseTransactionTypeEnum.DEBIT: 'DEBIT',
};
