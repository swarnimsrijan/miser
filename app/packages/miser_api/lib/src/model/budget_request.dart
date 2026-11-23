//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'budget_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class BudgetRequest {
  /// Returns a new [BudgetRequest] instance.
  BudgetRequest({

     this.monthlyLimit,

     this.alertThresholdPercent,
  });

          // minimum: 0.01
  @JsonKey(
    
    name: r'monthlyLimit',
    required: false,
    includeIfNull: false,
  )


  final num? monthlyLimit;



          // minimum: 1
          // maximum: 100
  @JsonKey(
    
    name: r'alertThresholdPercent',
    required: false,
    includeIfNull: false,
  )


  final int? alertThresholdPercent;





    @override
    bool operator ==(Object other) => identical(this, other) || other is BudgetRequest &&
      other.monthlyLimit == monthlyLimit &&
      other.alertThresholdPercent == alertThresholdPercent;

    @override
    int get hashCode =>
        monthlyLimit.hashCode +
        alertThresholdPercent.hashCode;

  factory BudgetRequest.fromJson(Map<String, dynamic> json) => _$BudgetRequestFromJson(json);

  Map<String, dynamic> toJson() => _$BudgetRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

