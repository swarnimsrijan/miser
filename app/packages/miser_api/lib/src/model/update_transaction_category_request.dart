//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'update_transaction_category_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UpdateTransactionCategoryRequest {
  /// Returns a new [UpdateTransactionCategoryRequest] instance.
  UpdateTransactionCategoryRequest({

    required  this.categoryId,

     this.subCategoryId,
  });

  @JsonKey(
    
    name: r'categoryId',
    required: true,
    includeIfNull: false,
  )


  final int categoryId;



  @JsonKey(
    
    name: r'subCategoryId',
    required: false,
    includeIfNull: false,
  )


  final int? subCategoryId;





    @override
    bool operator ==(Object other) => identical(this, other) || other is UpdateTransactionCategoryRequest &&
      other.categoryId == categoryId &&
      other.subCategoryId == subCategoryId;

    @override
    int get hashCode =>
        categoryId.hashCode +
        subCategoryId.hashCode;

  factory UpdateTransactionCategoryRequest.fromJson(Map<String, dynamic> json) => _$UpdateTransactionCategoryRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateTransactionCategoryRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

