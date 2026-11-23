// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statement_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$StatementResponseCWProxy {
  StatementResponse id(int? id);

  StatementResponse statementType(
    StatementResponseStatementTypeEnum? statementType,
  );

  StatementResponse status(String? status);

  StatementResponse accountId(int? accountId);

  StatementResponse creditCardId(int? creditCardId);

  StatementResponse fromDate(DateTime? fromDate);

  StatementResponse toDate(DateTime? toDate);

  StatementResponse uploadedAt(DateTime? uploadedAt);

  StatementResponse issuer(String? issuer);

  StatementResponse parserLayout(String? parserLayout);

  StatementResponse transactionCount(int? transactionCount);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `StatementResponse(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// StatementResponse(...).copyWith(id: 12, name: "My name")
  /// ```
  StatementResponse call({
    int? id,
    StatementResponseStatementTypeEnum? statementType,
    String? status,
    int? accountId,
    int? creditCardId,
    DateTime? fromDate,
    DateTime? toDate,
    DateTime? uploadedAt,
    String? issuer,
    String? parserLayout,
    int? transactionCount,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfStatementResponse.copyWith(...)` or call `instanceOfStatementResponse.copyWith.fieldName(value)` for a single field.
class _$StatementResponseCWProxyImpl implements _$StatementResponseCWProxy {
  const _$StatementResponseCWProxyImpl(this._value);

  final StatementResponse _value;

  @override
  StatementResponse id(int? id) => call(id: id);

  @override
  StatementResponse statementType(
    StatementResponseStatementTypeEnum? statementType,
  ) => call(statementType: statementType);

  @override
  StatementResponse status(String? status) => call(status: status);

  @override
  StatementResponse accountId(int? accountId) => call(accountId: accountId);

  @override
  StatementResponse creditCardId(int? creditCardId) =>
      call(creditCardId: creditCardId);

  @override
  StatementResponse fromDate(DateTime? fromDate) => call(fromDate: fromDate);

  @override
  StatementResponse toDate(DateTime? toDate) => call(toDate: toDate);

  @override
  StatementResponse uploadedAt(DateTime? uploadedAt) =>
      call(uploadedAt: uploadedAt);

  @override
  StatementResponse issuer(String? issuer) => call(issuer: issuer);

  @override
  StatementResponse parserLayout(String? parserLayout) =>
      call(parserLayout: parserLayout);

  @override
  StatementResponse transactionCount(int? transactionCount) =>
      call(transactionCount: transactionCount);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `StatementResponse(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// StatementResponse(...).copyWith(id: 12, name: "My name")
  /// ```
  StatementResponse call({
    Object? id = const $CopyWithPlaceholder(),
    Object? statementType = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? accountId = const $CopyWithPlaceholder(),
    Object? creditCardId = const $CopyWithPlaceholder(),
    Object? fromDate = const $CopyWithPlaceholder(),
    Object? toDate = const $CopyWithPlaceholder(),
    Object? uploadedAt = const $CopyWithPlaceholder(),
    Object? issuer = const $CopyWithPlaceholder(),
    Object? parserLayout = const $CopyWithPlaceholder(),
    Object? transactionCount = const $CopyWithPlaceholder(),
  }) {
    return StatementResponse(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int?,
      statementType: statementType == const $CopyWithPlaceholder()
          ? _value.statementType
          // ignore: cast_nullable_to_non_nullable
          : statementType as StatementResponseStatementTypeEnum?,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as String?,
      accountId: accountId == const $CopyWithPlaceholder()
          ? _value.accountId
          // ignore: cast_nullable_to_non_nullable
          : accountId as int?,
      creditCardId: creditCardId == const $CopyWithPlaceholder()
          ? _value.creditCardId
          // ignore: cast_nullable_to_non_nullable
          : creditCardId as int?,
      fromDate: fromDate == const $CopyWithPlaceholder()
          ? _value.fromDate
          // ignore: cast_nullable_to_non_nullable
          : fromDate as DateTime?,
      toDate: toDate == const $CopyWithPlaceholder()
          ? _value.toDate
          // ignore: cast_nullable_to_non_nullable
          : toDate as DateTime?,
      uploadedAt: uploadedAt == const $CopyWithPlaceholder()
          ? _value.uploadedAt
          // ignore: cast_nullable_to_non_nullable
          : uploadedAt as DateTime?,
      issuer: issuer == const $CopyWithPlaceholder()
          ? _value.issuer
          // ignore: cast_nullable_to_non_nullable
          : issuer as String?,
      parserLayout: parserLayout == const $CopyWithPlaceholder()
          ? _value.parserLayout
          // ignore: cast_nullable_to_non_nullable
          : parserLayout as String?,
      transactionCount: transactionCount == const $CopyWithPlaceholder()
          ? _value.transactionCount
          // ignore: cast_nullable_to_non_nullable
          : transactionCount as int?,
    );
  }
}

extension $StatementResponseCopyWith on StatementResponse {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfStatementResponse.copyWith(...)` or `instanceOfStatementResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$StatementResponseCWProxy get copyWith =>
      _$StatementResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatementResponse _$StatementResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('StatementResponse', json, ($checkedConvert) {
  final val = StatementResponse(
    id: $checkedConvert('id', (v) => (v as num?)?.toInt()),
    statementType: $checkedConvert(
      'statementType',
      (v) =>
          $enumDecodeNullable(_$StatementResponseStatementTypeEnumEnumMap, v),
    ),
    status: $checkedConvert('status', (v) => v as String?),
    accountId: $checkedConvert('accountId', (v) => (v as num?)?.toInt()),
    creditCardId: $checkedConvert('creditCardId', (v) => (v as num?)?.toInt()),
    fromDate: $checkedConvert(
      'fromDate',
      (v) => v == null ? null : DateTime.parse(v as String),
    ),
    toDate: $checkedConvert(
      'toDate',
      (v) => v == null ? null : DateTime.parse(v as String),
    ),
    uploadedAt: $checkedConvert(
      'uploadedAt',
      (v) => v == null ? null : DateTime.parse(v as String),
    ),
    issuer: $checkedConvert('issuer', (v) => v as String?),
    parserLayout: $checkedConvert('parserLayout', (v) => v as String?),
    transactionCount: $checkedConvert(
      'transactionCount',
      (v) => (v as num?)?.toInt(),
    ),
  );
  return val;
});

Map<String, dynamic> _$StatementResponseToJson(StatementResponse instance) =>
    <String, dynamic>{
      'id': ?instance.id,
      'statementType':
          ?_$StatementResponseStatementTypeEnumEnumMap[instance.statementType],
      'status': ?instance.status,
      'accountId': ?instance.accountId,
      'creditCardId': ?instance.creditCardId,
      'fromDate': ?instance.fromDate?.toIso8601String(),
      'toDate': ?instance.toDate?.toIso8601String(),
      'uploadedAt': ?instance.uploadedAt?.toIso8601String(),
      'issuer': ?instance.issuer,
      'parserLayout': ?instance.parserLayout,
      'transactionCount': ?instance.transactionCount,
    };

const _$StatementResponseStatementTypeEnumEnumMap = {
  StatementResponseStatementTypeEnum.PDF: 'PDF',
  StatementResponseStatementTypeEnum.CSV: 'CSV',
  StatementResponseStatementTypeEnum.XLSX: 'XLSX',
};
