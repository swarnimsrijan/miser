//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'budget_response.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class BudgetResponse {
  /// Returns a new [BudgetResponse] instance.
  BudgetResponse({

     this.categoryId,

     this.category,

     this.monthlyLimit,

     this.alertThresholdPercent,
  });

  @JsonKey(
    
    name: r'categoryId',
    required: false,
    includeIfNull: false,
  )


  final int? categoryId;



  @JsonKey(
    
    name: r'category',
    required: false,
    includeIfNull: false,
  )


  final String? category;



  @JsonKey(
    
    name: r'monthlyLimit',
    required: false,
    includeIfNull: false,
  )


  final num? monthlyLimit;



  @JsonKey(
    
    name: r'alertThresholdPercent',
    required: false,
    includeIfNull: false,
  )


  final int? alertThresholdPercent;





    @override
    bool operator ==(Object other) => identical(this, other) || other is BudgetResponse &&
      other.categoryId == categoryId &&
      other.category == category &&
      other.monthlyLimit == monthlyLimit &&
      other.alertThresholdPercent == alertThresholdPercent;

    @override
    int get hashCode =>
        categoryId.hashCode +
        category.hashCode +
        monthlyLimit.hashCode +
        alertThresholdPercent.hashCode;

  factory BudgetResponse.fromJson(Map<String, dynamic> json) => _$BudgetResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BudgetResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

