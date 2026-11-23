//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:miser_api/src/model/projected_month.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'scenario.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Scenario {
  /// Returns a new [Scenario] instance.
  Scenario({

     this.monthlyIncome,

     this.monthlyExpense,

     this.monthlySavings,

     this.totalSavings,

     this.months,
  });

  @JsonKey(
    
    name: r'monthlyIncome',
    required: false,
    includeIfNull: false,
  )


  final num? monthlyIncome;



  @JsonKey(
    
    name: r'monthlyExpense',
    required: false,
    includeIfNull: false,
  )


  final num? monthlyExpense;



  @JsonKey(
    
    name: r'monthlySavings',
    required: false,
    includeIfNull: false,
  )


  final num? monthlySavings;



  @JsonKey(
    
    name: r'totalSavings',
    required: false,
    includeIfNull: false,
  )


  final num? totalSavings;



  @JsonKey(
    
    name: r'months',
    required: false,
    includeIfNull: false,
  )


  final List<ProjectedMonth>? months;





    @override
    bool operator ==(Object other) => identical(this, other) || other is Scenario &&
      other.monthlyIncome == monthlyIncome &&
      other.monthlyExpense == monthlyExpense &&
      other.monthlySavings == monthlySavings &&
      other.totalSavings == totalSavings &&
      other.months == months;

    @override
    int get hashCode =>
        monthlyIncome.hashCode +
        monthlyExpense.hashCode +
        monthlySavings.hashCode +
        totalSavings.hashCode +
        months.hashCode;

  factory Scenario.fromJson(Map<String, dynamic> json) => _$ScenarioFromJson(json);

  Map<String, dynamic> toJson() => _$ScenarioToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

