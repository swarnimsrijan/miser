//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'projected_month.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ProjectedMonth {
  /// Returns a new [ProjectedMonth] instance.
  ProjectedMonth({

     this.month,

     this.income,

     this.expense,

     this.savings,

     this.cumulativeSavings,
  });

  @JsonKey(
    
    name: r'month',
    required: false,
    includeIfNull: false,
  )


  final String? month;



  @JsonKey(
    
    name: r'income',
    required: false,
    includeIfNull: false,
  )


  final num? income;



  @JsonKey(
    
    name: r'expense',
    required: false,
    includeIfNull: false,
  )


  final num? expense;



  @JsonKey(
    
    name: r'savings',
    required: false,
    includeIfNull: false,
  )


  final num? savings;



  @JsonKey(
    
    name: r'cumulativeSavings',
    required: false,
    includeIfNull: false,
  )


  final num? cumulativeSavings;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ProjectedMonth &&
      other.month == month &&
      other.income == income &&
      other.expense == expense &&
      other.savings == savings &&
      other.cumulativeSavings == cumulativeSavings;

    @override
    int get hashCode =>
        month.hashCode +
        income.hashCode +
        expense.hashCode +
        savings.hashCode +
        cumulativeSavings.hashCode;

  factory ProjectedMonth.fromJson(Map<String, dynamic> json) => _$ProjectedMonthFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectedMonthToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

