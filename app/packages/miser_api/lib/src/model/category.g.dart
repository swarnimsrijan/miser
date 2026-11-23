// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CategoryCWProxy {
  Category id(int? id);

  Category name(String? name);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `Category(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// Category(...).copyWith(id: 12, name: "My name")
  /// ```
  Category call({int? id, String? name});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfCategory.copyWith(...)` or call `instanceOfCategory.copyWith.fieldName(value)` for a single field.
class _$CategoryCWProxyImpl implements _$CategoryCWProxy {
  const _$CategoryCWProxyImpl(this._value);

  final Category _value;

  @override
  Category id(int? id) => call(id: id);

  @override
  Category name(String? name) => call(name: name);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `Category(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// Category(...).copyWith(id: 12, name: "My name")
  /// ```
  Category call({
    Object? id = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
  }) {
    return Category(
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

extension $CategoryCopyWith on Category {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfCategory.copyWith(...)` or `instanceOfCategory.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CategoryCWProxy get copyWith => _$CategoryCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) =>
    $checkedCreate('Category', json, ($checkedConvert) {
      final val = Category(
        id: $checkedConvert('id', (v) => (v as num?)?.toInt()),
        name: $checkedConvert('name', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
  'id': ?instance.id,
  'name': ?instance.name,
};
