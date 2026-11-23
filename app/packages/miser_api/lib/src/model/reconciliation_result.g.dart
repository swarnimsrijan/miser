// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reconciliation_result.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ReconciliationResultCWProxy {
  ReconciliationResult linkedPairs(int? linkedPairs);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `ReconciliationResult(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// ReconciliationResult(...).copyWith(id: 12, name: "My name")
  /// ```
  ReconciliationResult call({int? linkedPairs});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfReconciliationResult.copyWith(...)` or call `instanceOfReconciliationResult.copyWith.fieldName(value)` for a single field.
class _$ReconciliationResultCWProxyImpl
    implements _$ReconciliationResultCWProxy {
  const _$ReconciliationResultCWProxyImpl(this._value);

  final ReconciliationResult _value;

  @override
  ReconciliationResult linkedPairs(int? linkedPairs) =>
      call(linkedPairs: linkedPairs);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `ReconciliationResult(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// ReconciliationResult(...).copyWith(id: 12, name: "My name")
  /// ```
  ReconciliationResult call({
    Object? linkedPairs = const $CopyWithPlaceholder(),
  }) {
    return ReconciliationResult(
      linkedPairs: linkedPairs == const $CopyWithPlaceholder()
          ? _value.linkedPairs
          // ignore: cast_nullable_to_non_nullable
          : linkedPairs as int?,
    );
  }
}

extension $ReconciliationResultCopyWith on ReconciliationResult {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfReconciliationResult.copyWith(...)` or `instanceOfReconciliationResult.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ReconciliationResultCWProxy get copyWith =>
      _$ReconciliationResultCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReconciliationResult _$ReconciliationResultFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('ReconciliationResult', json, ($checkedConvert) {
  final val = ReconciliationResult(
    linkedPairs: $checkedConvert('linkedPairs', (v) => (v as num?)?.toInt()),
  );
  return val;
});

Map<String, dynamic> _$ReconciliationResultToJson(
  ReconciliationResult instance,
) => <String, dynamic>{'linkedPairs': ?instance.linkedPairs};
