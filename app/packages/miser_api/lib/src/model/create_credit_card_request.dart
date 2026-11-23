//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_credit_card_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CreateCreditCardRequest {
  /// Returns a new [CreateCreditCardRequest] instance.
  CreateCreditCardRequest({

    required  this.bankId,

    required  this.cardName,

     this.maskedNumber,

     this.creditLimit,

     this.billingDate,

     this.dueDate,

    required  this.currency,
  });

  @JsonKey(
    
    name: r'bankId',
    required: true,
    includeIfNull: false,
  )


  final int bankId;



  @JsonKey(
    
    name: r'cardName',
    required: true,
    includeIfNull: false,
  )


  final String cardName;



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
    required: true,
    includeIfNull: false,
  )


  final String currency;





    @override
    bool operator ==(Object other) => identical(this, other) || other is CreateCreditCardRequest &&
      other.bankId == bankId &&
      other.cardName == cardName &&
      other.maskedNumber == maskedNumber &&
      other.creditLimit == creditLimit &&
      other.billingDate == billingDate &&
      other.dueDate == dueDate &&
      other.currency == currency;

    @override
    int get hashCode =>
        bankId.hashCode +
        cardName.hashCode +
        maskedNumber.hashCode +
        creditLimit.hashCode +
        billingDate.hashCode +
        dueDate.hashCode +
        currency.hashCode;

  factory CreateCreditCardRequest.fromJson(Map<String, dynamic> json) => _$CreateCreditCardRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateCreditCardRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

