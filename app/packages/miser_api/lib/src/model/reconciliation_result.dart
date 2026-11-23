//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reconciliation_result.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ReconciliationResult {
  /// Returns a new [ReconciliationResult] instance.
  ReconciliationResult({

     this.linkedPairs,
  });

  @JsonKey(
    
    name: r'linkedPairs',
    required: false,
    includeIfNull: false,
  )


  final int? linkedPairs;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ReconciliationResult &&
      other.linkedPairs == linkedPairs;

    @override
    int get hashCode =>
        linkedPairs.hashCode;

  factory ReconciliationResult.fromJson(Map<String, dynamic> json) => _$ReconciliationResultFromJson(json);

  Map<String, dynamic> toJson() => _$ReconciliationResultToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

