//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'credit_card_response.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CreditCardResponse {
  /// Returns a new [CreditCardResponse] instance.
  CreditCardResponse({

     this.id,

     this.bankId,

     this.bankName,

     this.cardName,

     this.maskedNumber,

     this.creditLimit,

     this.billingDate,

     this.dueDate,

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
    
    name: r'cardName',
    required: false,
    includeIfNull: false,
  )


  final String? cardName;



  @JsonKey(
    
    name: r'maskedNumber',
    required: false,
    includeIfNull: false,
  )


  final String? maskedNumber;



  @JsonKey(
    
    name: r'creditLimit',
    required: false,
    includeIfNull: false,
  )


  final num? creditLimit;



  @JsonKey(
    
    name: r'billingDate',
    required: false,
    includeIfNull: false,
  )


  final int? billingDate;



  @JsonKey(
    
    name: r'dueDate',
    required: false,
    includeIfNull: false,
  )


  final int? dueDate;



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
    bool operator ==(Object other) => identical(this, other) || other is CreditCardResponse &&
      other.id == id &&
      other.bankId == bankId &&
      other.bankName == bankName &&
      other.cardName == cardName &&
      other.maskedNumber == maskedNumber &&
      other.creditLimit == creditLimit &&
      other.billingDate == billingDate &&
      other.dueDate == dueDate &&
      other.currency == currency &&
      other.status == status &&
      other.createdAt == createdAt;

    @override
    int get hashCode =>
        id.hashCode +
        bankId.hashCode +
        bankName.hashCode +
        cardName.hashCode +
        maskedNumber.hashCode +
        creditLimit.hashCode +
        billingDate.hashCode +
        dueDate.hashCode +
        currency.hashCode +
        status.hashCode +
        createdAt.hashCode;

  factory CreditCardResponse.fromJson(Map<String, dynamic> json) => _$CreditCardResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreditCardResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

