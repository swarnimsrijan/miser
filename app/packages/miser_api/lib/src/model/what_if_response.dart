//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:miser_api/src/model/scenario.dart';
import 'package:miser_api/src/model/category_line.dart';
import 'package:miser_api/src/model/goal_eta.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'what_if_response.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class WhatIfResponse {
  /// Returns a new [WhatIfResponse] instance.
  WhatIfResponse({

     this.basedOn,

     this.baseline,

     this.scenario,

     this.monthlySavingsDelta,

     this.categories,

     this.goals,
  });

  @JsonKey(
    
    name: r'basedOn',
    required: false,
    includeIfNull: false,
  )


  final List<String>? basedOn;



  @JsonKey(
    
    name: r'baseline',
    required: false,
    includeIfNull: false,
  )


  final Scenario? baseline;



  @JsonKey(
    
    name: r'scenario',
    required: false,
    includeIfNull: false,
  )


  final Scenario? scenario;



  @JsonKey(
    
    name: r'monthlySavingsDelta',
    required: false,
    includeIfNull: false,
  )


  final num? monthlySavingsDelta;



  @JsonKey(
    
    name: r'categories',
    required: false,
    includeIfNull: false,
  )


  final List<CategoryLine>? categories;



  @JsonKey(
    
    name: r'goals',
    required: false,
    includeIfNull: false,
  )


  final List<GoalEta>? goals;





    @override
    bool operator ==(Object other) => identical(this, other) || other is WhatIfResponse &&
      other.basedOn == basedOn &&
      other.baseline == baseline &&
      other.scenario == scenario &&
      other.monthlySavingsDelta == monthlySavingsDelta &&
      other.categories == categories &&
      other.goals == goals;

    @override
    int get hashCode =>
        basedOn.hashCode +
        baseline.hashCode +
        scenario.hashCode +
        monthlySavingsDelta.hashCode +
        categories.hashCode +
        goals.hashCode;

  factory WhatIfResponse.fromJson(Map<String, dynamic> json) => _$WhatIfResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WhatIfResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

