// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_change.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CategoryChangeCWProxy {
  CategoryChange categoryId(int? categoryId);

  CategoryChange changePercent(num? changePercent);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `CategoryChange(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// CategoryChange(...).copyWith(id: 12, name: "My name")
  /// ```
  CategoryChange call({int? categoryId, num? changePercent});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfCategoryChange.copyWith(...)` or call `instanceOfCategoryChange.copyWith.fieldName(value)` for a single field.
class _$CategoryChangeCWProxyImpl implements _$CategoryChangeCWProxy {
  const _$CategoryChangeCWProxyImpl(this._value);

  final CategoryChange _value;

  @override
  CategoryChange categoryId(int? categoryId) => call(categoryId: categoryId);

  @override
  CategoryChange changePercent(num? changePercent) =>
      call(changePercent: changePercent);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `CategoryChange(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// CategoryChange(...).copyWith(id: 12, name: "My name")
  /// ```
  CategoryChange call({
    Object? categoryId = const $CopyWithPlaceholder(),
    Object? changePercent = const $CopyWithPlaceholder(),
  }) {
    return CategoryChange(
      categoryId: categoryId == const $CopyWithPlaceholder()
          ? _value.categoryId
          // ignore: cast_nullable_to_non_nullable
          : categoryId as int?,
      changePercent: changePercent == const $CopyWithPlaceholder()
          ? _value.changePercent
          // ignore: cast_nullable_to_non_nullable
          : changePercent as num?,
    );
  }
}

extension $CategoryChangeCopyWith on CategoryChange {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfCategoryChange.copyWith(...)` or `instanceOfCategoryChange.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CategoryChangeCWProxy get copyWith => _$CategoryChangeCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryChange _$CategoryChangeFromJson(Map<String, dynamic> json) =>
    $checkedCreate('CategoryChange', json, ($checkedConvert) {
      final val = CategoryChange(
        categoryId: $checkedConvert('categoryId', (v) => (v as num?)?.toInt()),
        changePercent: $checkedConvert('changePercent', (v) => v as num?),
      );
      return val;
    });

Map<String, dynamic> _$CategoryChangeToJson(CategoryChange instance) =>
    <String, dynamic>{
      'categoryId': ?instance.categoryId,
      'changePercent': ?instance.changePercent,
    };
