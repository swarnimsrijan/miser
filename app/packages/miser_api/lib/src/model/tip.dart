//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tip.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Tip {
  /// Returns a new [Tip] instance.
  Tip({

     this.type,

     this.severity,

     this.title,

     this.message,

     this.amount,
  });

  @JsonKey(
    
    name: r'type',
    required: false,
    includeIfNull: false,
  )


  final String? type;



  @JsonKey(
    
    name: r'severity',
    required: false,
    includeIfNull: false,
  )


  final TipSeverityEnum? severity;



  @JsonKey(
    
    name: r'title',
    required: false,
    includeIfNull: false,
  )


  final String? title;



  @JsonKey(
    
    name: r'message',
    required: false,
    includeIfNull: false,
  )


  final String? message;



  @JsonKey(
    
    name: r'amount',
    required: false,
    includeIfNull: false,
  )


  final num? amount;





    @override
    bool operator ==(Object other) => identical(this, other) || other is Tip &&
      other.type == type &&
      other.severity == severity &&
      other.title == title &&
      other.message == message &&
      other.amount == amount;

    @override
    int get hashCode =>
        type.hashCode +
        severity.hashCode +
        title.hashCode +
        message.hashCode +
        amount.hashCode;

  factory Tip.fromJson(Map<String, dynamic> json) => _$TipFromJson(json);

  Map<String, dynamic> toJson() => _$TipToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum TipSeverityEnum {
@JsonValue(r'INFO')
INFO(r'INFO'),
@JsonValue(r'WARNING')
WARNING(r'WARNING'),
@JsonValue(r'ALERT')
ALERT(r'ALERT');

const TipSeverityEnum(this.value);

final String value;

@override
String toString() => value;
}


