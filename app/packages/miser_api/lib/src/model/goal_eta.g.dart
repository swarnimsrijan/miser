// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_eta.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$GoalEtaCWProxy {
  GoalEta goalId(int? goalId);

  GoalEta name(String? name);

  GoalEta targetDate(DateTime? targetDate);

  GoalEta baselineCompletion(String? baselineCompletion);

  GoalEta scenarioCompletion(String? scenarioCompletion);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `GoalEta(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// GoalEta(...).copyWith(id: 12, name: "My name")
  /// ```
  GoalEta call({
    int? goalId,
    String? name,
    DateTime? targetDate,
    String? baselineCompletion,
    String? scenarioCompletion,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfGoalEta.copyWith(...)` or call `instanceOfGoalEta.copyWith.fieldName(value)` for a single field.
class _$GoalEtaCWProxyImpl implements _$GoalEtaCWProxy {
  const _$GoalEtaCWProxyImpl(this._value);

  final GoalEta _value;

  @override
  GoalEta goalId(int? goalId) => call(goalId: goalId);

  @override
  GoalEta name(String? name) => call(name: name);

  @override
  GoalEta targetDate(DateTime? targetDate) => call(targetDate: targetDate);

  @override
  GoalEta baselineCompletion(String? baselineCompletion) =>
      call(baselineCompletion: baselineCompletion);

  @override
  GoalEta scenarioCompletion(String? scenarioCompletion) =>
      call(scenarioCompletion: scenarioCompletion);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `GoalEta(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// GoalEta(...).copyWith(id: 12, name: "My name")
  /// ```
  GoalEta call({
    Object? goalId = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? targetDate = const $CopyWithPlaceholder(),
    Object? baselineCompletion = const $CopyWithPlaceholder(),
    Object? scenarioCompletion = const $CopyWithPlaceholder(),
  }) {
    return GoalEta(
      goalId: goalId == const $CopyWithPlaceholder()
          ? _value.goalId
          // ignore: cast_nullable_to_non_nullable
          : goalId as int?,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String?,
      targetDate: targetDate == const $CopyWithPlaceholder()
          ? _value.targetDate
          // ignore: cast_nullable_to_non_nullable
          : targetDate as DateTime?,
      baselineCompletion: baselineCompletion == const $CopyWithPlaceholder()
          ? _value.baselineCompletion
          // ignore: cast_nullable_to_non_nullable
          : baselineCompletion as String?,
      scenarioCompletion: scenarioCompletion == const $CopyWithPlaceholder()
          ? _value.scenarioCompletion
          // ignore: cast_nullable_to_non_nullable
          : scenarioCompletion as String?,
    );
  }
}

extension $GoalEtaCopyWith on GoalEta {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfGoalEta.copyWith(...)` or `instanceOfGoalEta.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$GoalEtaCWProxy get copyWith => _$GoalEtaCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoalEta _$GoalEtaFromJson(Map<String, dynamic> json) =>
    $checkedCreate('GoalEta', json, ($checkedConvert) {
      final val = GoalEta(
        goalId: $checkedConvert('goalId', (v) => (v as num?)?.toInt()),
        name: $checkedConvert('name', (v) => v as String?),
        targetDate: $checkedConvert(
          'targetDate',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        baselineCompletion: $checkedConvert(
          'baselineCompletion',
          (v) => v as String?,
        ),
        scenarioCompletion: $checkedConvert(
          'scenarioCompletion',
          (v) => v as String?,
        ),
      );
      return val;
    });

Map<String, dynamic> _$GoalEtaToJson(GoalEta instance) => <String, dynamic>{
  'goalId': ?instance.goalId,
  'name': ?instance.name,
  'targetDate': ?instance.targetDate?.toIso8601String(),
  'baselineCompletion': ?instance.baselineCompletion,
  'scenarioCompletion': ?instance.scenarioCompletion,
};
