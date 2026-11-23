//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bank.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Bank {
  /// Returns a new [Bank] instance.
  Bank({

     this.id,

     this.name,

     this.logo,

     this.country,
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



  @JsonKey(
    
    name: r'logo',
    required: false,
    includeIfNull: false,
  )


  final String? logo;



  @JsonKey(
    
    name: r'country',
    required: false,
    includeIfNull: false,
  )


  final String? country;





    @override
    bool operator ==(Object other) => identical(this, other) || other is Bank &&
      other.id == id &&
      other.name == name &&
      other.logo == logo &&
      other.country == country;

    @override
    int get hashCode =>
        id.hashCode +
        name.hashCode +
        logo.hashCode +
        country.hashCode;

  factory Bank.fromJson(Map<String, dynamic> json) => _$BankFromJson(json);

  Map<String, dynamic> toJson() => _$BankToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

