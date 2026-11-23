// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sort_object.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SortObjectCWProxy {
  SortObject sorted(bool? sorted);

  SortObject unsorted(bool? unsorted);

  SortObject empty(bool? empty);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `SortObject(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// SortObject(...).copyWith(id: 12, name: "My name")
  /// ```
  SortObject call({bool? sorted, bool? unsorted, bool? empty});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfSortObject.copyWith(...)` or call `instanceOfSortObject.copyWith.fieldName(value)` for a single field.
class _$SortObjectCWProxyImpl implements _$SortObjectCWProxy {
  const _$SortObjectCWProxyImpl(this._value);

  final SortObject _value;

  @override
  SortObject sorted(bool? sorted) => call(sorted: sorted);

  @override
  SortObject unsorted(bool? unsorted) => call(unsorted: unsorted);

  @override
  SortObject empty(bool? empty) => call(empty: empty);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `SortObject(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// SortObject(...).copyWith(id: 12, name: "My name")
  /// ```
  SortObject call({
    Object? sorted = const $CopyWithPlaceholder(),
    Object? unsorted = const $CopyWithPlaceholder(),
    Object? empty = const $CopyWithPlaceholder(),
  }) {
    return SortObject(
      sorted: sorted == const $CopyWithPlaceholder()
          ? _value.sorted
          // ignore: cast_nullable_to_non_nullable
          : sorted as bool?,
      unsorted: unsorted == const $CopyWithPlaceholder()
          ? _value.unsorted
          // ignore: cast_nullable_to_non_nullable
          : unsorted as bool?,
      empty: empty == const $CopyWithPlaceholder()
          ? _value.empty
          // ignore: cast_nullable_to_non_nullable
          : empty as bool?,
    );
  }
}

extension $SortObjectCopyWith on SortObject {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfSortObject.copyWith(...)` or `instanceOfSortObject.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SortObjectCWProxy get copyWith => _$SortObjectCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SortObject _$SortObjectFromJson(Map<String, dynamic> json) =>
    $checkedCreate('SortObject', json, ($checkedConvert) {
      final val = SortObject(
        sorted: $checkedConvert('sorted', (v) => v as bool?),
        unsorted: $checkedConvert('unsorted', (v) => v as bool?),
        empty: $checkedConvert('empty', (v) => v as bool?),
      );
      return val;
    });

Map<String, dynamic> _$SortObjectToJson(SortObject instance) =>
    <String, dynamic>{
      'sorted': ?instance.sorted,
      'unsorted': ?instance.unsorted,
      'empty': ?instance.empty,
    };
