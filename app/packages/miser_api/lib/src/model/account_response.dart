//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'account_response.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AccountResponse {
  /// Returns a new [AccountResponse] instance.
  AccountResponse({

     this.id,

     this.bankId,

     this.bankName,

     this.nickname,

     this.accountNumberMasked,

     this.accountType,

     this.currency,

     this.status,

     this.createdAt,
  });

  @JsonKey(
    
    name: r'id',
    required: false,
    includeIfNull: false,
  )


  final int? id;



  @JsonKey(
    
    name: r'bankId',
    required: false,
    includeIfNull: false,
  )


  final int? bankId;



  @JsonKey(
    
    name: r'bankName',
    required: false,
    includeIfNull: false,
  )


  final String? bankName;



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
    required: false,
    includeIfNull: false,
  )


  final AccountResponseAccountTypeEnum? accountType;



  @JsonKey(
    
    name: r'currency',
    required: false,
    includeIfNull: false,
  )


  final String? currency;



  @JsonKey(
    
    name: r'status',
    required: false,
    includeIfNull: false,
  )


  final String? status;



  @JsonKey(
    
    name: r'createdAt',
    required: false,
    includeIfNull: false,
  )


  final DateTime? createdAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AccountResponse &&
      other.id == id &&
      other.bankId == bankId &&
      other.bankName == bankName &&
      other.nickname == nickname &&
      other.accountNumberMasked == accountNumberMasked &&
      other.accountType == accountType &&
      other.currency == currency &&
      other.status == status &&
      other.createdAt == createdAt;

    @override
    int get hashCode =>
        id.hashCode +
        bankId.hashCode +
        bankName.hashCode +
        nickname.hashCode +
        accountNumberMasked.hashCode +
        accountType.hashCode +
        currency.hashCode +
        status.hashCode +
        createdAt.hashCode;

  factory AccountResponse.fromJson(Map<String, dynamic> json) => _$AccountResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AccountResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum AccountResponseAccountTypeEnum {
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

const AccountResponseAccountTypeEnum(this.value);

final String value;

@override
String toString() => value;
}


