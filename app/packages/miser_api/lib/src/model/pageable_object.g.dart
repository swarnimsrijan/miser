// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pageable_object.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PageableObjectCWProxy {
  PageableObject paged(bool? paged);

  PageableObject pageNumber(int? pageNumber);

  PageableObject pageSize(int? pageSize);

  PageableObject unpaged(bool? unpaged);

  PageableObject offset(int? offset);

  PageableObject sort(SortObject? sort);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `PageableObject(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// PageableObject(...).copyWith(id: 12, name: "My name")
  /// ```
  PageableObject call({
    bool? paged,
    int? pageNumber,
    int? pageSize,
    bool? unpaged,
    int? offset,
    SortObject? sort,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfPageableObject.copyWith(...)` or call `instanceOfPageableObject.copyWith.fieldName(value)` for a single field.
class _$PageableObjectCWProxyImpl implements _$PageableObjectCWProxy {
  const _$PageableObjectCWProxyImpl(this._value);

  final PageableObject _value;

  @override
  PageableObject paged(bool? paged) => call(paged: paged);

  @override
  PageableObject pageNumber(int? pageNumber) => call(pageNumber: pageNumber);

  @override
  PageableObject pageSize(int? pageSize) => call(pageSize: pageSize);

  @override
  PageableObject unpaged(bool? unpaged) => call(unpaged: unpaged);

  @override
  PageableObject offset(int? offset) => call(offset: offset);

  @override
  PageableObject sort(SortObject? sort) => call(sort: sort);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `PageableObject(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// PageableObject(...).copyWith(id: 12, name: "My name")
  /// ```
  PageableObject call({
    Object? paged = const $CopyWithPlaceholder(),
    Object? pageNumber = const $CopyWithPlaceholder(),
    Object? pageSize = const $CopyWithPlaceholder(),
    Object? unpaged = const $CopyWithPlaceholder(),
    Object? offset = const $CopyWithPlaceholder(),
    Object? sort = const $CopyWithPlaceholder(),
  }) {
    return PageableObject(
      paged: paged == const $CopyWithPlaceholder()
          ? _value.paged
          // ignore: cast_nullable_to_non_nullable
          : paged as bool?,
      pageNumber: pageNumber == const $CopyWithPlaceholder()
          ? _value.pageNumber
          // ignore: cast_nullable_to_non_nullable
          : pageNumber as int?,
      pageSize: pageSize == const $CopyWithPlaceholder()
          ? _value.pageSize
          // ignore: cast_nullable_to_non_nullable
          : pageSize as int?,
      unpaged: unpaged == const $CopyWithPlaceholder()
          ? _value.unpaged
          // ignore: cast_nullable_to_non_nullable
          : unpaged as bool?,
      offset: offset == const $CopyWithPlaceholder()
          ? _value.offset
          // ignore: cast_nullable_to_non_nullable
          : offset as int?,
      sort: sort == const $CopyWithPlaceholder()
          ? _value.sort
          // ignore: cast_nullable_to_non_nullable
          : sort as SortObject?,
    );
  }
}

extension $PageableObjectCopyWith on PageableObject {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfPageableObject.copyWith(...)` or `instanceOfPageableObject.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PageableObjectCWProxy get copyWith => _$PageableObjectCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PageableObject _$PageableObjectFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PageableObject', json, ($checkedConvert) {
      final val = PageableObject(
        paged: $checkedConvert('paged', (v) => v as bool?),
        pageNumber: $checkedConvert('pageNumber', (v) => (v as num?)?.toInt()),
        pageSize: $checkedConvert('pageSize', (v) => (v as num?)?.toInt()),
        unpaged: $checkedConvert('unpaged', (v) => v as bool?),
        offset: $checkedConvert('offset', (v) => (v as num?)?.toInt()),
        sort: $checkedConvert(
          'sort',
          (v) =>
              v == null ? null : SortObject.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$PageableObjectToJson(PageableObject instance) =>
    <String, dynamic>{
      'paged': ?instance.paged,
      'pageNumber': ?instance.pageNumber,
      'pageSize': ?instance.pageSize,
      'unpaged': ?instance.unpaged,
      'offset': ?instance.offset,
      'sort': ?instance.sort?.toJson(),
    };
