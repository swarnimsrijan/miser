// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_goal_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UpdateGoalRequestCWProxy {
  UpdateGoalRequest name(String? name);

  UpdateGoalRequest targetAmount(num? targetAmount);

  UpdateGoalRequest targetDate(DateTime? targetDate);

  UpdateGoalRequest priority(int? priority);

  UpdateGoalRequest status(UpdateGoalRequestStatusEnum? status);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `UpdateGoalRequest(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// UpdateGoalRequest(...).copyWith(id: 12, name: "My name")
  /// ```
  UpdateGoalRequest call({
    String? name,
    num? targetAmount,
    DateTime? targetDate,
    int? priority,
    UpdateGoalRequestStatusEnum? status,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfUpdateGoalRequest.copyWith(...)` or call `instanceOfUpdateGoalRequest.copyWith.fieldName(value)` for a single field.
class _$UpdateGoalRequestCWProxyImpl implements _$UpdateGoalRequestCWProxy {
  const _$UpdateGoalRequestCWProxyImpl(this._value);

  final UpdateGoalRequest _value;

  @override
  UpdateGoalRequest name(String? name) => call(name: name);

  @override
  UpdateGoalRequest targetAmount(num? targetAmount) =>
      call(targetAmount: targetAmount);

  @override
  UpdateGoalRequest targetDate(DateTime? targetDate) =>
      call(targetDate: targetDate);

  @override
  UpdateGoalRequest priority(int? priority) => call(priority: priority);

  @override
  UpdateGoalRequest status(UpdateGoalRequestStatusEnum? status) =>
      call(status: status);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `UpdateGoalRequest(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// UpdateGoalRequest(...).copyWith(id: 12, name: "My name")
  /// ```
  UpdateGoalRequest call({
    Object? name = const $CopyWithPlaceholder(),
    Object? targetAmount = const $CopyWithPlaceholder(),
    Object? targetDate = const $CopyWithPlaceholder(),
    Object? priority = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
  }) {
    return UpdateGoalRequest(
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String?,
      targetAmount: targetAmount == const $CopyWithPlaceholder()
          ? _value.targetAmount
          // ignore: cast_nullable_to_non_nullable
          : targetAmount as num?,
      targetDate: targetDate == const $CopyWithPlaceholder()
          ? _value.targetDate
          // ignore: cast_nullable_to_non_nullable
          : targetDate as DateTime?,
      priority: priority == const $CopyWithPlaceholder()
          ? _value.priority
          // ignore: cast_nullable_to_non_nullable
          : priority as int?,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as UpdateGoalRequestStatusEnum?,
    );
  }
}

extension $UpdateGoalRequestCopyWith on UpdateGoalRequest {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfUpdateGoalRequest.copyWith(...)` or `instanceOfUpdateGoalRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UpdateGoalRequestCWProxy get copyWith =>
      _$UpdateGoalRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateGoalRequest _$UpdateGoalRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('UpdateGoalRequest', json, ($checkedConvert) {
      final val = UpdateGoalRequest(
        name: $checkedConvert('name', (v) => v as String?),
        targetAmount: $checkedConvert('targetAmount', (v) => v as num?),
        targetDate: $checkedConvert(
          'targetDate',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        priority: $checkedConvert('priority', (v) => (v as num?)?.toInt()),
        status: $checkedConvert(
          'status',
          (v) => $enumDecodeNullable(_$UpdateGoalRequestStatusEnumEnumMap, v),
        ),
      );
      return val;
    });

Map<String, dynamic> _$UpdateGoalRequestToJson(UpdateGoalRequest instance) =>
    <String, dynamic>{
      'name': ?instance.name,
      'targetAmount': ?instance.targetAmount,
      'targetDate': ?instance.targetDate?.toIso8601String(),
      'priority': ?instance.priority,
      'status': ?_$UpdateGoalRequestStatusEnumEnumMap[instance.status],
    };

const _$UpdateGoalRequestStatusEnumEnumMap = {
  UpdateGoalRequestStatusEnum.ACTIVE: 'ACTIVE',
  UpdateGoalRequestStatusEnum.ACHIEVED: 'ACHIEVED',
  UpdateGoalRequestStatusEnum.PAUSED: 'PAUSED',
};
