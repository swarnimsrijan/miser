//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_account_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CreateAccountRequest {
  /// Returns a new [CreateAccountRequest] instance.
  CreateAccountRequest({

    required  this.bankId,

     this.nickname,

     this.accountNumberMasked,

    required  this.accountType,

    required  this.currency,
  });

  @JsonKey(
    
    name: r'bankId',
    required: true,
    includeIfNull: false,
  )


  final int bankId;



  @JsonKey(
    
    name: r'nickname',
    required: false,
    includeIfNull: false,
  )


  final String? nickname;



  @JsonKey(
    
    name: r'accountNumberMasked',
    required: false,
    includeIfNull: false,
  )


  final String? accountNumberMasked;



  @JsonKey(
    
    name: r'accountType',
    required: true,
    includeIfNull: false,
  )


  final CreateAccountRequestAccountTypeEnum accountType;



  @JsonKey(
    
    name: r'currency',
    required: true,
    includeIfNull: false,
  )


  final String currency;





    @override
    bool operator ==(Object other) => identical(this, other) || other is CreateAccountRequest &&
      other.bankId == bankId &&
      other.nickname == nickname &&
      other.accountNumberMasked == accountNumberMasked &&
      other.accountType == accountType &&
      other.currency == currency;

    @override
    int get hashCode =>
        bankId.hashCode +
        nickname.hashCode +
        accountNumberMasked.hashCode +
        accountType.hashCode +
        currency.hashCode;

  factory CreateAccountRequest.fromJson(Map<String, dynamic> json) => _$CreateAccountRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateAccountRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum CreateAccountRequestAccountTypeEnum {
@JsonValue(r'SAVINGS')
SAVINGS(r'SAVINGS'),
@JsonValue(r'CURRENT')
CURRENT(r'CURRENT'),
@JsonValue(r'SALARY')
SALARY(r'SALARY'),
@JsonValue(r'FD')
FD(r'FD'),
@JsonValue(r'RD')
RD(r'RD');

const CreateAccountRequestAccountTypeEnum(this.value);

final String value;

@override
String toString() => value;
}


