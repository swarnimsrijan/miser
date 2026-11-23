// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sub_category.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SubCategoryCWProxy {
  SubCategory id(int? id);

  SubCategory name(String? name);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `SubCategory(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// SubCategory(...).copyWith(id: 12, name: "My name")
  /// ```
  SubCategory call({int? id, String? name});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfSubCategory.copyWith(...)` or call `instanceOfSubCategory.copyWith.fieldName(value)` for a single field.
class _$SubCategoryCWProxyImpl implements _$SubCategoryCWProxy {
  const _$SubCategoryCWProxyImpl(this._value);

  final SubCategory _value;

  @override
  SubCategory id(int? id) => call(id: id);

  @override
  SubCategory name(String? name) => call(name: name);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `SubCategory(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// SubCategory(...).copyWith(id: 12, name: "My name")
  /// ```
  SubCategory call({
    Object? id = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
  }) {
    return SubCategory(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int?,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String?,
    );
  }
}

extension $SubCategoryCopyWith on SubCategory {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfSubCategory.copyWith(...)` or `instanceOfSubCategory.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SubCategoryCWProxy get copyWith => _$SubCategoryCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubCategory _$SubCategoryFromJson(Map<String, dynamic> json) =>
    $checkedCreate('SubCategory', json, ($checkedConvert) {
      final val = SubCategory(
        id: $checkedConvert('id', (v) => (v as num?)?.toInt()),
        name: $checkedConvert('name', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$SubCategoryToJson(SubCategory instance) =>
    <String, dynamic>{'id': ?instance.id, 'name': ?instance.name};
