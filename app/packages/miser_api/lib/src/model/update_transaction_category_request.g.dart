// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_transaction_category_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UpdateTransactionCategoryRequestCWProxy {
  UpdateTransactionCategoryRequest categoryId(int categoryId);

  UpdateTransactionCategoryRequest subCategoryId(int? subCategoryId);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `UpdateTransactionCategoryRequest(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// UpdateTransactionCategoryRequest(...).copyWith(id: 12, name: "My name")
  /// ```
  UpdateTransactionCategoryRequest call({int categoryId, int? subCategoryId});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfUpdateTransactionCategoryRequest.copyWith(...)` or call `instanceOfUpdateTransactionCategoryRequest.copyWith.fieldName(value)` for a single field.
class _$UpdateTransactionCategoryRequestCWProxyImpl
    implements _$UpdateTransactionCategoryRequestCWProxy {
  const _$UpdateTransactionCategoryRequestCWProxyImpl(this._value);

  final UpdateTransactionCategoryRequest _value;

  @override
  UpdateTransactionCategoryRequest categoryId(int categoryId) =>
      call(categoryId: categoryId);

  @override
  UpdateTransactionCategoryRequest subCategoryId(int? subCategoryId) =>
      call(subCategoryId: subCategoryId);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `UpdateTransactionCategoryRequest(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// UpdateTransactionCategoryRequest(...).copyWith(id: 12, name: "My name")
  /// ```
  UpdateTransactionCategoryRequest call({
    Object? categoryId = const $CopyWithPlaceholder(),
    Object? subCategoryId = const $CopyWithPlaceholder(),
  }) {
    return UpdateTransactionCategoryRequest(
      categoryId:
          categoryId == const $CopyWithPlaceholder() || categoryId == null
          ? _value.categoryId
          // ignore: cast_nullable_to_non_nullable
          : categoryId as int,
      subCategoryId: subCategoryId == const $CopyWithPlaceholder()
          ? _value.subCategoryId
          // ignore: cast_nullable_to_non_nullable
          : subCategoryId as int?,
    );
  }
}

extension $UpdateTransactionCategoryRequestCopyWith
    on UpdateTransactionCategoryRequest {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfUpdateTransactionCategoryRequest.copyWith(...)` or `instanceOfUpdateTransactionCategoryRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UpdateTransactionCategoryRequestCWProxy get copyWith =>
      _$UpdateTransactionCategoryRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateTransactionCategoryRequest _$UpdateTransactionCategoryRequestFromJson(
  Map<String, dynamic> json,
) =>
    $checkedCreate('UpdateTransactionCategoryRequest', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['categoryId']);
      final val = UpdateTransactionCategoryRequest(
        categoryId: $checkedConvert('categoryId', (v) => (v as num).toInt()),
        subCategoryId: $checkedConvert(
          'subCategoryId',
          (v) => (v as num?)?.toInt(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$UpdateTransactionCategoryRequestToJson(
  UpdateTransactionCategoryRequest instance,
) => <String, dynamic>{
  'categoryId': instance.categoryId,
  'subCategoryId': ?instance.subCategoryId,
};
