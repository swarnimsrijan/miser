//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category_line.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CategoryLine {
  /// Returns a new [CategoryLine] instance.
  CategoryLine({

     this.categoryId,

     this.category,

     this.baselineMonthly,

     this.scenarioMonthly,
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
    
    name: r'baselineMonthly',
    required: false,
    includeIfNull: false,
  )


  final num? baselineMonthly;



  @JsonKey(
    
    name: r'scenarioMonthly',
    required: false,
    includeIfNull: false,
  )


  final num? scenarioMonthly;





    @override
    bool operator ==(Object other) => identical(this, other) || other is CategoryLine &&
      other.categoryId == categoryId &&
      other.category == category &&
      other.baselineMonthly == baselineMonthly &&
      other.scenarioMonthly == scenarioMonthly;

    @override
    int get hashCode =>
        categoryId.hashCode +
        category.hashCode +
        baselineMonthly.hashCode +
        scenarioMonthly.hashCode;

  factory CategoryLine.fromJson(Map<String, dynamic> json) => _$CategoryLineFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryLineToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

