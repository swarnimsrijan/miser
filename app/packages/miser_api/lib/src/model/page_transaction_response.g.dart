// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_transaction_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PageTransactionResponseCWProxy {
  PageTransactionResponse totalPages(int? totalPages);

  PageTransactionResponse totalElements(int? totalElements);

  PageTransactionResponse pageable(PageableObject? pageable);

  PageTransactionResponse first(bool? first);

  PageTransactionResponse last(bool? last);

  PageTransactionResponse numberOfElements(int? numberOfElements);

  PageTransactionResponse size(int? size);

  PageTransactionResponse content(List<TransactionResponse>? content);

  PageTransactionResponse number(int? number);

  PageTransactionResponse sort(SortObject? sort);

  PageTransactionResponse empty(bool? empty);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `PageTransactionResponse(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// PageTransactionResponse(...).copyWith(id: 12, name: "My name")
  /// ```
  PageTransactionResponse call({
    int? totalPages,
    int? totalElements,
    PageableObject? pageable,
    bool? first,
    bool? last,
    int? numberOfElements,
    int? size,
    List<TransactionResponse>? content,
    int? number,
    SortObject? sort,
    bool? empty,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfPageTransactionResponse.copyWith(...)` or call `instanceOfPageTransactionResponse.copyWith.fieldName(value)` for a single field.
class _$PageTransactionResponseCWProxyImpl
    implements _$PageTransactionResponseCWProxy {
  const _$PageTransactionResponseCWProxyImpl(this._value);

  final PageTransactionResponse _value;

  @override
  PageTransactionResponse totalPages(int? totalPages) =>
      call(totalPages: totalPages);

  @override
  PageTransactionResponse totalElements(int? totalElements) =>
      call(totalElements: totalElements);

  @override
  PageTransactionResponse pageable(PageableObject? pageable) =>
      call(pageable: pageable);

  @override
  PageTransactionResponse first(bool? first) => call(first: first);

  @override
  PageTransactionResponse last(bool? last) => call(last: last);

  @override
  PageTransactionResponse numberOfElements(int? numberOfElements) =>
      call(numberOfElements: numberOfElements);

  @override
  PageTransactionResponse size(int? size) => call(size: size);

  @override
  PageTransactionResponse content(List<TransactionResponse>? content) =>
      call(content: content);

  @override
  PageTransactionResponse number(int? number) => call(number: number);

  @override
  PageTransactionResponse sort(SortObject? sort) => call(sort: sort);

  @override
  PageTransactionResponse empty(bool? empty) => call(empty: empty);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `PageTransactionResponse(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// PageTransactionResponse(...).copyWith(id: 12, name: "My name")
  /// ```
  PageTransactionResponse call({
    Object? totalPages = const $CopyWithPlaceholder(),
    Object? totalElements = const $CopyWithPlaceholder(),
    Object? pageable = const $CopyWithPlaceholder(),
    Object? first = const $CopyWithPlaceholder(),
    Object? last = const $CopyWithPlaceholder(),
    Object? numberOfElements = const $CopyWithPlaceholder(),
    Object? size = const $CopyWithPlaceholder(),
    Object? content = const $CopyWithPlaceholder(),
    Object? number = const $CopyWithPlaceholder(),
    Object? sort = const $CopyWithPlaceholder(),
    Object? empty = const $CopyWithPlaceholder(),
  }) {
    return PageTransactionResponse(
      totalPages: totalPages == const $CopyWithPlaceholder()
          ? _value.totalPages
          // ignore: cast_nullable_to_non_nullable
          : totalPages as int?,
      totalElements: totalElements == const $CopyWithPlaceholder()
          ? _value.totalElements
          // ignore: cast_nullable_to_non_nullable
          : totalElements as int?,
      pageable: pageable == const $CopyWithPlaceholder()
          ? _value.pageable
          // ignore: cast_nullable_to_non_nullable
          : pageable as PageableObject?,
      first: first == const $CopyWithPlaceholder()
          ? _value.first
          // ignore: cast_nullable_to_non_nullable
          : first as bool?,
      last: last == const $CopyWithPlaceholder()
          ? _value.last
          // ignore: cast_nullable_to_non_nullable
          : last as bool?,
      numberOfElements: numberOfElements == const $CopyWithPlaceholder()
          ? _value.numberOfElements
          // ignore: cast_nullable_to_non_nullable
          : numberOfElements as int?,
      size: size == const $CopyWithPlaceholder()
          ? _value.size
          // ignore: cast_nullable_to_non_nullable
          : size as int?,
      content: content == const $CopyWithPlaceholder()
          ? _value.content
          // ignore: cast_nullable_to_non_nullable
          : content as List<TransactionResponse>?,
      number: number == const $CopyWithPlaceholder()
          ? _value.number
          // ignore: cast_nullable_to_non_nullable
          : number as int?,
      sort: sort == const $CopyWithPlaceholder()
          ? _value.sort
          // ignore: cast_nullable_to_non_nullable
          : sort as SortObject?,
      empty: empty == const $CopyWithPlaceholder()
          ? _value.empty
          // ignore: cast_nullable_to_non_nullable
          : empty as bool?,
    );
  }
}

extension $PageTransactionResponseCopyWith on PageTransactionResponse {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfPageTransactionResponse.copyWith(...)` or `instanceOfPageTransactionResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PageTransactionResponseCWProxy get copyWith =>
      _$PageTransactionResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PageTransactionResponse _$PageTransactionResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('PageTransactionResponse', json, ($checkedConvert) {
  final val = PageTransactionResponse(
    totalPages: $checkedConvert('totalPages', (v) => (v as num?)?.toInt()),
    totalElements: $checkedConvert(
      'totalElements',
      (v) => (v as num?)?.toInt(),
    ),
    pageable: $checkedConvert(
      'pageable',
      (v) =>
          v == null ? null : PageableObject.fromJson(v as Map<String, dynamic>),
    ),
    first: $checkedConvert('first', (v) => v as bool?),
    last: $checkedConvert('last', (v) => v as bool?),
    numberOfElements: $checkedConvert(
      'numberOfElements',
      (v) => (v as num?)?.toInt(),
    ),
    size: $checkedConvert('size', (v) => (v as num?)?.toInt()),
    content: $checkedConvert(
      'content',
      (v) => (v as List<dynamic>?)
          ?.map((e) => TransactionResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    number: $checkedConvert('number', (v) => (v as num?)?.toInt()),
    sort: $checkedConvert(
      'sort',
      (v) => v == null ? null : SortObject.fromJson(v as Map<String, dynamic>),
    ),
    empty: $checkedConvert('empty', (v) => v as bool?),
  );
  return val;
});

Map<String, dynamic> _$PageTransactionResponseToJson(
  PageTransactionResponse instance,
) => <String, dynamic>{
  'totalPages': ?instance.totalPages,
  'totalElements': ?instance.totalElements,
  'pageable': ?instance.pageable?.toJson(),
  'first': ?instance.first,
  'last': ?instance.last,
  'numberOfElements': ?instance.numberOfElements,
  'size': ?instance.size,
  'content': ?instance.content?.map((e) => e.toJson()).toList(),
  'number': ?instance.number,
  'sort': ?instance.sort?.toJson(),
  'empty': ?instance.empty,
};
