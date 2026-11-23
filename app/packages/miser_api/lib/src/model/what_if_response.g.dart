// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'what_if_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$WhatIfResponseCWProxy {
  WhatIfResponse basedOn(List<String>? basedOn);

  WhatIfResponse baseline(Scenario? baseline);

  WhatIfResponse scenario(Scenario? scenario);

  WhatIfResponse monthlySavingsDelta(num? monthlySavingsDelta);

  WhatIfResponse categories(List<CategoryLine>? categories);

  WhatIfResponse goals(List<GoalEta>? goals);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `WhatIfResponse(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// WhatIfResponse(...).copyWith(id: 12, name: "My name")
  /// ```
  WhatIfResponse call({
    List<String>? basedOn,
    Scenario? baseline,
    Scenario? scenario,
    num? monthlySavingsDelta,
    List<CategoryLine>? categories,
    List<GoalEta>? goals,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfWhatIfResponse.copyWith(...)` or call `instanceOfWhatIfResponse.copyWith.fieldName(value)` for a single field.
class _$WhatIfResponseCWProxyImpl implements _$WhatIfResponseCWProxy {
  const _$WhatIfResponseCWProxyImpl(this._value);

  final WhatIfResponse _value;

  @override
  WhatIfResponse basedOn(List<String>? basedOn) => call(basedOn: basedOn);

  @override
  WhatIfResponse baseline(Scenario? baseline) => call(baseline: baseline);

  @override
  WhatIfResponse scenario(Scenario? scenario) => call(scenario: scenario);

  @override
  WhatIfResponse monthlySavingsDelta(num? monthlySavingsDelta) =>
      call(monthlySavingsDelta: monthlySavingsDelta);

  @override
  WhatIfResponse categories(List<CategoryLine>? categories) =>
      call(categories: categories);

  @override
  WhatIfResponse goals(List<GoalEta>? goals) => call(goals: goals);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `WhatIfResponse(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// WhatIfResponse(...).copyWith(id: 12, name: "My name")
  /// ```
  WhatIfResponse call({
    Object? basedOn = const $CopyWithPlaceholder(),
    Object? baseline = const $CopyWithPlaceholder(),
    Object? scenario = const $CopyWithPlaceholder(),
    Object? monthlySavingsDelta = const $CopyWithPlaceholder(),
    Object? categories = const $CopyWithPlaceholder(),
    Object? goals = const $CopyWithPlaceholder(),
  }) {
    return WhatIfResponse(
      basedOn: basedOn == const $CopyWithPlaceholder()
          ? _value.basedOn
          // ignore: cast_nullable_to_non_nullable
          : basedOn as List<String>?,
      baseline: baseline == const $CopyWithPlaceholder()
          ? _value.baseline
          // ignore: cast_nullable_to_non_nullable
          : baseline as Scenario?,
      scenario: scenario == const $CopyWithPlaceholder()
          ? _value.scenario
          // ignore: cast_nullable_to_non_nullable
          : scenario as Scenario?,
      monthlySavingsDelta: monthlySavingsDelta == const $CopyWithPlaceholder()
          ? _value.monthlySavingsDelta
          // ignore: cast_nullable_to_non_nullable
          : monthlySavingsDelta as num?,
      categories: categories == const $CopyWithPlaceholder()
          ? _value.categories
          // ignore: cast_nullable_to_non_nullable
          : categories as List<CategoryLine>?,
      goals: goals == const $CopyWithPlaceholder()
          ? _value.goals
          // ignore: cast_nullable_to_non_nullable
          : goals as List<GoalEta>?,
    );
  }
}

extension $WhatIfResponseCopyWith on WhatIfResponse {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfWhatIfResponse.copyWith(...)` or `instanceOfWhatIfResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$WhatIfResponseCWProxy get copyWith => _$WhatIfResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WhatIfResponse _$WhatIfResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('WhatIfResponse', json, ($checkedConvert) {
      final val = WhatIfResponse(
        basedOn: $checkedConvert(
          'basedOn',
          (v) => (v as List<dynamic>?)?.map((e) => e as String).toList(),
        ),
        baseline: $checkedConvert(
          'baseline',
          (v) =>
              v == null ? null : Scenario.fromJson(v as Map<String, dynamic>),
        ),
        scenario: $checkedConvert(
          'scenario',
          (v) =>
              v == null ? null : Scenario.fromJson(v as Map<String, dynamic>),
        ),
        monthlySavingsDelta: $checkedConvert(
          'monthlySavingsDelta',
          (v) => v as num?,
        ),
        categories: $checkedConvert(
          'categories',
          (v) => (v as List<dynamic>?)
              ?.map((e) => CategoryLine.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        goals: $checkedConvert(
          'goals',
          (v) => (v as List<dynamic>?)
              ?.map((e) => GoalEta.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$WhatIfResponseToJson(WhatIfResponse instance) =>
    <String, dynamic>{
      'basedOn': ?instance.basedOn,
      'baseline': ?instance.baseline?.toJson(),
      'scenario': ?instance.scenario?.toJson(),
      'monthlySavingsDelta': ?instance.monthlySavingsDelta,
      'categories': ?instance.categories?.map((e) => e.toJson()).toList(),
      'goals': ?instance.goals?.map((e) => e.toJson()).toList(),
    };
