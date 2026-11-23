//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'budget_status.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class BudgetStatus {
  /// Returns a new [BudgetStatus] instance.
  BudgetStatus({

     this.categoryId,

     this.category,

     this.month,

     this.monthlyLimit,

     this.spent,

     this.remaining,

     this.percentUsed,

     this.projectedSpend,

     this.status,
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
    
    name: r'month',
    required: false,
    includeIfNull: false,
  )


  final String? month;



  @JsonKey(
    
    name: r'monthlyLimit',
    required: false,
    includeIfNull: false,
  )


  final num? monthlyLimit;



  @JsonKey(
    
    name: r'spent',
    required: false,
    includeIfNull: false,
  )


  final num? spent;



  @JsonKey(
    
    name: r'remaining',
    required: false,
    includeIfNull: false,
  )


  final num? remaining;



  @JsonKey(
    
    name: r'percentUsed',
    required: false,
    includeIfNull: false,
  )


  final num? percentUsed;



  @JsonKey(
    
    name: r'projectedSpend',
    required: false,
    includeIfNull: false,
  )


  final num? projectedSpend;



  @JsonKey(
    
    name: r'status',
    required: false,
    includeIfNull: false,
  )


  final BudgetStatusStatusEnum? status;





    @override
    bool operator ==(Object other) => identical(this, other) || other is BudgetStatus &&
      other.categoryId == categoryId &&
      other.category == category &&
      other.month == month &&
      other.monthlyLimit == monthlyLimit &&
      other.spent == spent &&
      other.remaining == remaining &&
      other.percentUsed == percentUsed &&
      other.projectedSpend == projectedSpend &&
      other.status == status;

    @override
    int get hashCode =>
        categoryId.hashCode +
        category.hashCode +
        month.hashCode +
        monthlyLimit.hashCode +
        spent.hashCode +
        remaining.hashCode +
        percentUsed.hashCode +
        projectedSpend.hashCode +
        status.hashCode;

  factory BudgetStatus.fromJson(Map<String, dynamic> json) => _$BudgetStatusFromJson(json);

  Map<String, dynamic> toJson() => _$BudgetStatusToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum BudgetStatusStatusEnum {
@JsonValue(r'ON_TRACK')
ON_TRACK(r'ON_TRACK'),
@JsonValue(r'WARNING')
WARNING(r'WARNING'),
@JsonValue(r'EXCEEDED')
EXCEEDED(r'EXCEEDED');

const BudgetStatusStatusEnum(this.value);

final String value;

@override
String toString() => value;
}


