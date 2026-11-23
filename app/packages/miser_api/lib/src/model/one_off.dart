//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'one_off.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class OneOff {
  /// Returns a new [OneOff] instance.
  OneOff({

     this.month,

     this.amount,

     this.label,
  });

  @JsonKey(
    
    name: r'month',
    required: false,
    includeIfNull: false,
  )


  final String? month;



  @JsonKey(
    
    name: r'amount',
    required: false,
    includeIfNull: false,
  )


  final num? amount;



  @JsonKey(
    
    name: r'label',
    required: false,
    includeIfNull: false,
  )


  final String? label;





    @override
    bool operator ==(Object other) => identical(this, other) || other is OneOff &&
      other.month == month &&
      other.amount == amount &&
      other.label == label;

    @override
    int get hashCode =>
        month.hashCode +
        amount.hashCode +
        label.hashCode;

  factory OneOff.fromJson(Map<String, dynamic> json) => _$OneOffFromJson(json);

  Map<String, dynamic> toJson() => _$OneOffToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

