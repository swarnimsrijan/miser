// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_goal_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CreateGoalRequestCWProxy {
  CreateGoalRequest name(String name);

  CreateGoalRequest targetAmount(num? targetAmount);

  CreateGoalRequest targetDate(DateTime? targetDate);

  CreateGoalRequest savedAmount(num? savedAmount);

  CreateGoalRequest priority(int? priority);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `CreateGoalRequest(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// CreateGoalRequest(...).copyWith(id: 12, name: "My name")
  /// ```
  CreateGoalRequest call({
    String name,
    num? targetAmount,
    DateTime? targetDate,
    num? savedAmount,
    int? priority,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfCreateGoalRequest.copyWith(...)` or call `instanceOfCreateGoalRequest.copyWith.fieldName(value)` for a single field.
class _$CreateGoalRequestCWProxyImpl implements _$CreateGoalRequestCWProxy {
  const _$CreateGoalRequestCWProxyImpl(this._value);

  final CreateGoalRequest _value;

  @override
  CreateGoalRequest name(String name) => call(name: name);

  @override
  CreateGoalRequest targetAmount(num? targetAmount) =>
      call(targetAmount: targetAmount);

  @override
  CreateGoalRequest targetDate(DateTime? targetDate) =>
      call(targetDate: targetDate);

  @override
  CreateGoalRequest savedAmount(num? savedAmount) =>
      call(savedAmount: savedAmount);

  @override
  CreateGoalRequest priority(int? priority) => call(priority: priority);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `CreateGoalRequest(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// CreateGoalRequest(...).copyWith(id: 12, name: "My name")
  /// ```
  CreateGoalRequest call({
    Object? name = const $CopyWithPlaceholder(),
    Object? targetAmount = const $CopyWithPlaceholder(),
    Object? targetDate = const $CopyWithPlaceholder(),
    Object? savedAmount = const $CopyWithPlaceholder(),
    Object? priority = const $CopyWithPlaceholder(),
  }) {
    return CreateGoalRequest(
      name: name == const $CopyWithPlaceholder() || name == null
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      targetAmount: targetAmount == const $CopyWithPlaceholder()
          ? _value.targetAmount
          // ignore: cast_nullable_to_non_nullable
          : targetAmount as num?,
      targetDate: targetDate == const $CopyWithPlaceholder()
          ? _value.targetDate
          // ignore: cast_nullable_to_non_nullable
          : targetDate as DateTime?,
      savedAmount: savedAmount == const $CopyWithPlaceholder()
          ? _value.savedAmount
          // ignore: cast_nullable_to_non_nullable
          : savedAmount as num?,
      priority: priority == const $CopyWithPlaceholder()
          ? _value.priority
          // ignore: cast_nullable_to_non_nullable
          : priority as int?,
    );
  }
}

extension $CreateGoalRequestCopyWith on CreateGoalRequest {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfCreateGoalRequest.copyWith(...)` or `instanceOfCreateGoalRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CreateGoalRequestCWProxy get copyWith =>
      _$CreateGoalRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateGoalRequest _$CreateGoalRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('CreateGoalRequest', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['name']);
      final val = CreateGoalRequest(
        name: $checkedConvert('name', (v) => v as String),
        targetAmount: $checkedConvert('targetAmount', (v) => v as num?),
        targetDate: $checkedConvert(
          'targetDate',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        savedAmount: $checkedConvert('savedAmount', (v) => v as num?),
        priority: $checkedConvert('priority', (v) => (v as num?)?.toInt()),
      );
      return val;
    });

Map<String, dynamic> _$CreateGoalRequestToJson(CreateGoalRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'targetAmount': ?instance.targetAmount,
      'targetDate': ?instance.targetDate?.toIso8601String(),
      'savedAmount': ?instance.savedAmount,
      'priority': ?instance.priority,
    };
