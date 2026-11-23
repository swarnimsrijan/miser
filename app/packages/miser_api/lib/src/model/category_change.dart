//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category_change.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CategoryChange {
  /// Returns a new [CategoryChange] instance.
  CategoryChange({

     this.categoryId,

     this.changePercent,
  });

  @JsonKey(
    
    name: r'categoryId',
    required: false,
    includeIfNull: false,
  )


  final int? categoryId;



          // minimum: -100
  @JsonKey(
    
    name: r'changePercent',
    required: false,
    includeIfNull: false,
  )


  final num? changePercent;





    @override
    bool operator ==(Object other) => identical(this, other) || other is CategoryChange &&
      other.categoryId == categoryId &&
      other.changePercent == changePercent;

    @override
    int get hashCode =>
        categoryId.hashCode +
        changePercent.hashCode;

  factory CategoryChange.fromJson(Map<String, dynamic> json) => _$CategoryChangeFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryChangeToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

