//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'goal_response.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class GoalResponse {
  /// Returns a new [GoalResponse] instance.
  GoalResponse({

     this.id,

     this.name,

     this.targetAmount,

     this.savedAmount,

     this.remaining,

     this.percentComplete,

     this.targetDate,

     this.priority,

     this.status,

     this.requiredMonthly,

     this.projectedCompletion,

     this.onTrack,
  });

  @JsonKey(
    
    name: r'id',
    required: false,
    includeIfNull: false,
  )


  final int? id;



  @JsonKey(
    
    name: r'name',
    required: false,
    includeIfNull: false,
  )


  final String? name;



  @JsonKey(
    
    name: r'targetAmount',
    required: false,
    includeIfNull: false,
  )


  final num? targetAmount;



  @JsonKey(
    
    name: r'savedAmount',
    required: false,
    includeIfNull: false,
  )


  final num? savedAmount;



  @JsonKey(
    
    name: r'remaining',
    required: false,
    includeIfNull: false,
  )


  final num? remaining;



  @JsonKey(
    
    name: r'percentComplete',
    required: false,
    includeIfNull: false,
  )


  final num? percentComplete;



  @JsonKey(
    
    name: r'targetDate',
    required: false,
    includeIfNull: false,
  )


  final DateTime? targetDate;



  @JsonKey(
    
    name: r'priority',
    required: false,
    includeIfNull: false,
  )


  final int? priority;



  @JsonKey(
    
    name: r'status',
    required: false,
    includeIfNull: false,
  )


  final GoalResponseStatusEnum? status;



  @JsonKey(
    
    name: r'requiredMonthly',
    required: false,
    includeIfNull: false,
  )


  final num? requiredMonthly;



  @JsonKey(
    
    name: r'projectedCompletion',
    required: false,
    includeIfNull: false,
  )


  final String? projectedCompletion;



  @JsonKey(
    
    name: r'onTrack',
    required: false,
    includeIfNull: false,
  )


  final bool? onTrack;





    @override
    bool operator ==(Object other) => identical(this, other) || other is GoalResponse &&
      other.id == id &&
      other.name == name &&
      other.targetAmount == targetAmount &&
      other.savedAmount == savedAmount &&
      other.remaining == remaining &&
      other.percentComplete == percentComplete &&
      other.targetDate == targetDate &&
      other.priority == priority &&
      other.status == status &&
      other.requiredMonthly == requiredMonthly &&
      other.projectedCompletion == projectedCompletion &&
      other.onTrack == onTrack;

    @override
    int get hashCode =>
        id.hashCode +
        name.hashCode +
        targetAmount.hashCode +
        savedAmount.hashCode +
        remaining.hashCode +
        percentComplete.hashCode +
        targetDate.hashCode +
        priority.hashCode +
        status.hashCode +
        requiredMonthly.hashCode +
        projectedCompletion.hashCode +
        onTrack.hashCode;

  factory GoalResponse.fromJson(Map<String, dynamic> json) => _$GoalResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GoalResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum GoalResponseStatusEnum {
@JsonValue(r'ACTIVE')
ACTIVE(r'ACTIVE'),
@JsonValue(r'ACHIEVED')
ACHIEVED(r'ACHIEVED'),
@JsonValue(r'PAUSED')
PAUSED(r'PAUSED');

const GoalResponseStatusEnum(this.value);

final String value;

@override
String toString() => value;
}


