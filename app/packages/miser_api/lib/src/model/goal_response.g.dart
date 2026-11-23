// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$GoalResponseCWProxy {
  GoalResponse id(int? id);

  GoalResponse name(String? name);

  GoalResponse targetAmount(num? targetAmount);

  GoalResponse savedAmount(num? savedAmount);

  GoalResponse remaining(num? remaining);

  GoalResponse percentComplete(num? percentComplete);

  GoalResponse targetDate(DateTime? targetDate);

  GoalResponse priority(int? priority);

  GoalResponse status(GoalResponseStatusEnum? status);

  GoalResponse requiredMonthly(num? requiredMonthly);

  GoalResponse projectedCompletion(String? projectedCompletion);

  GoalResponse onTrack(bool? onTrack);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `GoalResponse(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// GoalResponse(...).copyWith(id: 12, name: "My name")
  /// ```
  GoalResponse call({
    int? id,
    String? name,
    num? targetAmount,
    num? savedAmount,
    num? remaining,
    num? percentComplete,
    DateTime? targetDate,
    int? priority,
    GoalResponseStatusEnum? status,
    num? requiredMonthly,
    String? projectedCompletion,
    bool? onTrack,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfGoalResponse.copyWith(...)` or call `instanceOfGoalResponse.copyWith.fieldName(value)` for a single field.
class _$GoalResponseCWProxyImpl implements _$GoalResponseCWProxy {
  const _$GoalResponseCWProxyImpl(this._value);

  final GoalResponse _value;

  @override
  GoalResponse id(int? id) => call(id: id);

  @override
  GoalResponse name(String? name) => call(name: name);

  @override
  GoalResponse targetAmount(num? targetAmount) =>
      call(targetAmount: targetAmount);

  @override
  GoalResponse savedAmount(num? savedAmount) => call(savedAmount: savedAmount);

  @override
  GoalResponse remaining(num? remaining) => call(remaining: remaining);

  @override
  GoalResponse percentComplete(num? percentComplete) =>
      call(percentComplete: percentComplete);

  @override
  GoalResponse targetDate(DateTime? targetDate) => call(targetDate: targetDate);

  @override
  GoalResponse priority(int? priority) => call(priority: priority);

  @override
  GoalResponse status(GoalResponseStatusEnum? status) => call(status: status);

  @override
  GoalResponse requiredMonthly(num? requiredMonthly) =>
      call(requiredMonthly: requiredMonthly);

  @override
  GoalResponse projectedCompletion(String? projectedCompletion) =>
      call(projectedCompletion: projectedCompletion);

  @override
  GoalResponse onTrack(bool? onTrack) => call(onTrack: onTrack);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `GoalResponse(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// GoalResponse(...).copyWith(id: 12, name: "My name")
  /// ```
  GoalResponse call({
    Object? id = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? targetAmount = const $CopyWithPlaceholder(),
    Object? savedAmount = const $CopyWithPlaceholder(),
    Object? remaining = const $CopyWithPlaceholder(),
    Object? percentComplete = const $CopyWithPlaceholder(),
    Object? targetDate = const $CopyWithPlaceholder(),
    Object? priority = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? requiredMonthly = const $CopyWithPlaceholder(),
    Object? projectedCompletion = const $CopyWithPlaceholder(),
    Object? onTrack = const $CopyWithPlaceholder(),
  }) {
    return GoalResponse(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int?,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String?,
      targetAmount: targetAmount == const $CopyWithPlaceholder()
          ? _value.targetAmount
          // ignore: cast_nullable_to_non_nullable
          : targetAmount as num?,
      savedAmount: savedAmount == const $CopyWithPlaceholder()
          ? _value.savedAmount
          // ignore: cast_nullable_to_non_nullable
          : savedAmount as num?,
      remaining: remaining == const $CopyWithPlaceholder()
          ? _value.remaining
          // ignore: cast_nullable_to_non_nullable
          : remaining as num?,
      percentComplete: percentComplete == const $CopyWithPlaceholder()
          ? _value.percentComplete
          // ignore: cast_nullable_to_non_nullable
          : percentComplete as num?,
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
          : status as GoalResponseStatusEnum?,
      requiredMonthly: requiredMonthly == const $CopyWithPlaceholder()
          ? _value.requiredMonthly
          // ignore: cast_nullable_to_non_nullable
          : requiredMonthly as num?,
      projectedCompletion: projectedCompletion == const $CopyWithPlaceholder()
          ? _value.projectedCompletion
          // ignore: cast_nullable_to_non_nullable
          : projectedCompletion as String?,
      onTrack: onTrack == const $CopyWithPlaceholder()
          ? _value.onTrack
          // ignore: cast_nullable_to_non_nullable
          : onTrack as bool?,
    );
  }
}

extension $GoalResponseCopyWith on GoalResponse {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfGoalResponse.copyWith(...)` or `instanceOfGoalResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$GoalResponseCWProxy get copyWith => _$GoalResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoalResponse _$GoalResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('GoalResponse', json, ($checkedConvert) {
      final val = GoalResponse(
        id: $checkedConvert('id', (v) => (v as num?)?.toInt()),
        name: $checkedConvert('name', (v) => v as String?),
        targetAmount: $checkedConvert('targetAmount', (v) => v as num?),
        savedAmount: $checkedConvert('savedAmount', (v) => v as num?),
        remaining: $checkedConvert('remaining', (v) => v as num?),
        percentComplete: $checkedConvert('percentComplete', (v) => v as num?),
        targetDate: $checkedConvert(
          'targetDate',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        priority: $checkedConvert('priority', (v) => (v as num?)?.toInt()),
        status: $checkedConvert(
          'status',
          (v) => $enumDecodeNullable(_$GoalResponseStatusEnumEnumMap, v),
        ),
        requiredMonthly: $checkedConvert('requiredMonthly', (v) => v as num?),
        projectedCompletion: $checkedConvert(
          'projectedCompletion',
          (v) => v as String?,
        ),
        onTrack: $checkedConvert('onTrack', (v) => v as bool?),
      );
      return val;
    });

Map<String, dynamic> _$GoalResponseToJson(GoalResponse instance) =>
    <String, dynamic>{
      'id': ?instance.id,
      'name': ?instance.name,
      'targetAmount': ?instance.targetAmount,
      'savedAmount': ?instance.savedAmount,
      'remaining': ?instance.remaining,
      'percentComplete': ?instance.percentComplete,
      'targetDate': ?instance.targetDate?.toIso8601String(),
      'priority': ?instance.priority,
      'status': ?_$GoalResponseStatusEnumEnumMap[instance.status],
      'requiredMonthly': ?instance.requiredMonthly,
      'projectedCompletion': ?instance.projectedCompletion,
      'onTrack': ?instance.onTrack,
    };

const _$GoalResponseStatusEnumEnumMap = {
  GoalResponseStatusEnum.ACTIVE: 'ACTIVE',
  GoalResponseStatusEnum.ACHIEVED: 'ACHIEVED',
  GoalResponseStatusEnum.PAUSED: 'PAUSED',
};
