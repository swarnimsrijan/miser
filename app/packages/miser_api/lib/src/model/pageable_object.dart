//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:miser_api/src/model/sort_object.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pageable_object.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PageableObject {
  /// Returns a new [PageableObject] instance.
  PageableObject({

     this.paged,

     this.pageNumber,

     this.pageSize,

     this.unpaged,

     this.offset,

     this.sort,
  });

  @JsonKey(
    
    name: r'paged',
    required: false,
    includeIfNull: false,
  )


  final bool? paged;



  @JsonKey(
    
    name: r'pageNumber',
    required: false,
    includeIfNull: false,
  )


  final int? pageNumber;



  @JsonKey(
    
    name: r'pageSize',
    required: false,
    includeIfNull: false,
  )


  final int? pageSize;



  @JsonKey(
    
    name: r'unpaged',
    required: false,
    includeIfNull: false,
  )


  final bool? unpaged;



  @JsonKey(
    
    name: r'offset',
    required: false,
    includeIfNull: false,
  )


  final int? offset;



  @JsonKey(
    
    name: r'sort',
    required: false,
    includeIfNull: false,
  )


  final SortObject? sort;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PageableObject &&
      other.paged == paged &&
      other.pageNumber == pageNumber &&
      other.pageSize == pageSize &&
      other.unpaged == unpaged &&
      other.offset == offset &&
      other.sort == sort;

    @override
    int get hashCode =>
        paged.hashCode +
        pageNumber.hashCode +
        pageSize.hashCode +
        unpaged.hashCode +
        offset.hashCode +
        sort.hashCode;

  factory PageableObject.fromJson(Map<String, dynamic> json) => _$PageableObjectFromJson(json);

  Map<String, dynamic> toJson() => _$PageableObjectToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

