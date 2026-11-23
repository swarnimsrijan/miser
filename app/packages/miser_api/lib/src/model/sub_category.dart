//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sub_category.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SubCategory {
  /// Returns a new [SubCategory] instance.
  SubCategory({

     this.id,

     this.name,
  });

  @JsonKey(
    
    name: r'id',
    required: false,
    includeIfNull: false,
  )


  final int? id;



  @JsonKey(
    
    name: r'name',
    required: false,
    includeIfNull: false,
  )


  final String? name;





    @override
    bool operator ==(Object other) => identical(this, other) || other is SubCategory &&
      other.id == id &&
      other.name == name;

    @override
    int get hashCode =>
        id.hashCode +
        name.hashCode;

  factory SubCategory.fromJson(Map<String, dynamic> json) => _$SubCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$SubCategoryToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

