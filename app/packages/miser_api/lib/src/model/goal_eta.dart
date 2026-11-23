//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'goal_eta.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class GoalEta {
  /// Returns a new [GoalEta] instance.
  GoalEta({

     this.goalId,

     this.name,

     this.targetDate,

     this.baselineCompletion,

     this.scenarioCompletion,
  });

  @JsonKey(
    
    name: r'goalId',
    required: false,
    includeIfNull: false,
  )


  final int? goalId;



  @JsonKey(
    
    name: r'name',
    required: false,
    includeIfNull: false,
  )


  final String? name;



  @JsonKey(
    
    name: r'targetDate',
    required: false,
    includeIfNull: false,
  )


  final DateTime? targetDate;



  @JsonKey(
    
    name: r'baselineCompletion',
    required: false,
    includeIfNull: false,
  )


  final String? baselineCompletion;



  @JsonKey(
    
    name: r'scenarioCompletion',
    required: false,
    includeIfNull: false,
  )


  final String? scenarioCompletion;





    @override
    bool operator ==(Object other) => identical(this, other) || other is GoalEta &&
      other.goalId == goalId &&
      other.name == name &&
      other.targetDate == targetDate &&
      other.baselineCompletion == baselineCompletion &&
      other.scenarioCompletion == scenarioCompletion;

    @override
    int get hashCode =>
        goalId.hashCode +
        name.hashCode +
        targetDate.hashCode +
        baselineCompletion.hashCode +
        scenarioCompletion.hashCode;

  factory GoalEta.fromJson(Map<String, dynamic> json) => _$GoalEtaFromJson(json);

  Map<String, dynamic> toJson() => _$GoalEtaToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

