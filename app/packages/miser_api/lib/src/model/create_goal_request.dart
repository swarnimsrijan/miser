//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_goal_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CreateGoalRequest {
  /// Returns a new [CreateGoalRequest] instance.
  CreateGoalRequest({

    required  this.name,

     this.targetAmount,

     this.targetDate,

     this.savedAmount,

     this.priority,
  });

  @JsonKey(
    
    name: r'name',
    required: true,
    includeIfNull: false,
  )


  final String name;



          // minimum: 0.01
  @JsonKey(
    
    name: r'targetAmount',
    required: false,
    includeIfNull: false,
  )


  final num? targetAmount;



  @JsonKey(
    
    name: r'targetDate',
    required: false,
    includeIfNull: false,
  )


  final DateTime? targetDate;



          // minimum: 0
  @JsonKey(
    
    name: r'savedAmount',
    required: false,
    includeIfNull: false,
  )


  final num? savedAmount;



          // minimum: 1
          // maximum: 5
  @JsonKey(
    
    name: r'priority',
    required: false,
    includeIfNull: false,
  )


  final int? priority;





    @override
    bool operator ==(Object other) => identical(this, other) || other is CreateGoalRequest &&
      other.name == name &&
      other.targetAmount == targetAmount &&
      other.targetDate == targetDate &&
      other.savedAmount == savedAmount &&
      other.priority == priority;

    @override
    int get hashCode =>
        name.hashCode +
        targetAmount.hashCode +
        targetDate.hashCode +
        savedAmount.hashCode +
        priority.hashCode;

  factory CreateGoalRequest.fromJson(Map<String, dynamic> json) => _$CreateGoalRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateGoalRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

