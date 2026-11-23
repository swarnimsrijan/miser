//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:miser_api/src/model/one_off.dart';
import 'package:miser_api/src/model/category_change.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'what_if_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class WhatIfRequest {
  /// Returns a new [WhatIfRequest] instance.
  WhatIfRequest({

     this.months,

     this.incomeChangePercent,

     this.extraMonthlyIncome,

     this.categoryChanges,

     this.oneOffs,
  });

          // minimum: 1
          // maximum: 60
  @JsonKey(
    
    name: r'months',
    required: false,
    includeIfNull: false,
  )


  final int? months;



          // minimum: -100
  @JsonKey(
    
    name: r'incomeChangePercent',
    required: false,
    includeIfNull: false,
  )


  final num? incomeChangePercent;



  @JsonKey(
    
    name: r'extraMonthlyIncome',
    required: false,
    includeIfNull: false,
  )


  final num? extraMonthlyIncome;



  @JsonKey(
    
    name: r'categoryChanges',
    required: false,
    includeIfNull: false,
  )


  final List<CategoryChange>? categoryChanges;



  @JsonKey(
    
    name: r'oneOffs',
    required: false,
    includeIfNull: false,
  )


  final List<OneOff>? oneOffs;





    @override
    bool operator ==(Object other) => identical(this, other) || other is WhatIfRequest &&
      other.months == months &&
      other.incomeChangePercent == incomeChangePercent &&
      other.extraMonthlyIncome == extraMonthlyIncome &&
      other.categoryChanges == categoryChanges &&
      other.oneOffs == oneOffs;

    @override
    int get hashCode =>
        months.hashCode +
        incomeChangePercent.hashCode +
        extraMonthlyIncome.hashCode +
        categoryChanges.hashCode +
        oneOffs.hashCode;

  factory WhatIfRequest.fromJson(Map<String, dynamic> json) => _$WhatIfRequestFromJson(json);

  Map<String, dynamic> toJson() => _$WhatIfRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

