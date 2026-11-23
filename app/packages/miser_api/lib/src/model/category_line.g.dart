// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_line.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CategoryLineCWProxy {
  CategoryLine categoryId(int? categoryId);

  CategoryLine category(String? category);

  CategoryLine baselineMonthly(num? baselineMonthly);

  CategoryLine scenarioMonthly(num? scenarioMonthly);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `CategoryLine(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// CategoryLine(...).copyWith(id: 12, name: "My name")
  /// ```
  CategoryLine call({
    int? categoryId,
    String? category,
    num? baselineMonthly,
    num? scenarioMonthly,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfCategoryLine.copyWith(...)` or call `instanceOfCategoryLine.copyWith.fieldName(value)` for a single field.
class _$CategoryLineCWProxyImpl implements _$CategoryLineCWProxy {
  const _$CategoryLineCWProxyImpl(this._value);

  final CategoryLine _value;

  @override
  CategoryLine categoryId(int? categoryId) => call(categoryId: categoryId);

  @override
  CategoryLine category(String? category) => call(category: category);

  @override
  CategoryLine baselineMonthly(num? baselineMonthly) =>
      call(baselineMonthly: baselineMonthly);

  @override
  CategoryLine scenarioMonthly(num? scenarioMonthly) =>
      call(scenarioMonthly: scenarioMonthly);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `CategoryLine(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// CategoryLine(...).copyWith(id: 12, name: "My name")
  /// ```
  CategoryLine call({
    Object? categoryId = const $CopyWithPlaceholder(),
    Object? category = const $CopyWithPlaceholder(),
    Object? baselineMonthly = const $CopyWithPlaceholder(),
    Object? scenarioMonthly = const $CopyWithPlaceholder(),
  }) {
    return CategoryLine(
      categoryId: categoryId == const $CopyWithPlaceholder()
          ? _value.categoryId
          // ignore: cast_nullable_to_non_nullable
          : categoryId as int?,
      category: category == const $CopyWithPlaceholder()
          ? _value.category
          // ignore: cast_nullable_to_non_nullable
          : category as String?,
      baselineMonthly: baselineMonthly == const $CopyWithPlaceholder()
          ? _value.baselineMonthly
          // ignore: cast_nullable_to_non_nullable
          : baselineMonthly as num?,
      scenarioMonthly: scenarioMonthly == const $CopyWithPlaceholder()
          ? _value.scenarioMonthly
          // ignore: cast_nullable_to_non_nullable
          : scenarioMonthly as num?,
    );
  }
}

extension $CategoryLineCopyWith on CategoryLine {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfCategoryLine.copyWith(...)` or `instanceOfCategoryLine.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CategoryLineCWProxy get copyWith => _$CategoryLineCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryLine _$CategoryLineFromJson(Map<String, dynamic> json) =>
    $checkedCreate('CategoryLine', json, ($checkedConvert) {
      final val = CategoryLine(
        categoryId: $checkedConvert('categoryId', (v) => (v as num?)?.toInt()),
        category: $checkedConvert('category', (v) => v as String?),
        baselineMonthly: $checkedConvert('baselineMonthly', (v) => v as num?),
        scenarioMonthly: $checkedConvert('scenarioMonthly', (v) => v as num?),
      );
      return val;
    });

Map<String, dynamic> _$CategoryLineToJson(CategoryLine instance) =>
    <String, dynamic>{
      'categoryId': ?instance.categoryId,
      'category': ?instance.category,
      'baselineMonthly': ?instance.baselineMonthly,
      'scenarioMonthly': ?instance.scenarioMonthly,
    };
