//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'update_goal_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UpdateGoalRequest {
  /// Returns a new [UpdateGoalRequest] instance.
  UpdateGoalRequest({

     this.name,

     this.targetAmount,

     this.targetDate,

     this.priority,

     this.status,
  });

  @JsonKey(
    
    name: r'name',
    required: false,
    includeIfNull: false,
  )


  final String? name;



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



          // minimum: 1
          // maximum: 5
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


  final UpdateGoalRequestStatusEnum? status;





    @override
    bool operator ==(Object other) => identical(this, other) || other is UpdateGoalRequest &&
      other.name == name &&
      other.targetAmount == targetAmount &&
      other.targetDate == targetDate &&
      other.priority == priority &&
      other.status == status;

    @override
    int get hashCode =>
        name.hashCode +
        targetAmount.hashCode +
        targetDate.hashCode +
        priority.hashCode +
        status.hashCode;

  factory UpdateGoalRequest.fromJson(Map<String, dynamic> json) => _$UpdateGoalRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateGoalRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum UpdateGoalRequestStatusEnum {
@JsonValue(r'ACTIVE')
ACTIVE(r'ACTIVE'),
@JsonValue(r'ACHIEVED')
ACHIEVED(r'ACHIEVED'),
@JsonValue(r'PAUSED')
PAUSED(r'PAUSED');

const UpdateGoalRequestStatusEnum(this.value);

final String value;

@override
String toString() => value;
}


