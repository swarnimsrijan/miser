//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'contribution_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ContributionRequest {
  /// Returns a new [ContributionRequest] instance.
  ContributionRequest({

     this.amount,

     this.note,
  });

  @JsonKey(
    
    name: r'amount',
    required: false,
    includeIfNull: false,
  )


  final num? amount;



  @JsonKey(
    
    name: r'note',
    required: false,
    includeIfNull: false,
  )


  final String? note;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ContributionRequest &&
      other.amount == amount &&
      other.note == note;

    @override
    int get hashCode =>
        amount.hashCode +
        note.hashCode;

  factory ContributionRequest.fromJson(Map<String, dynamic> json) => _$ContributionRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ContributionRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

