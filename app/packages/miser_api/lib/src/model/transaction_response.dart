//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'transaction_response.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class TransactionResponse {
  /// Returns a new [TransactionResponse] instance.
  TransactionResponse({

     this.id,

     this.transactionDate,

     this.description,

     this.merchant,

     this.categoryId,

     this.category,

     this.subCategoryId,

     this.subCategory,

     this.amount,

     this.transactionType,

     this.balance,

     this.currency,

     this.reference,

     this.accountId,

     this.creditCardId,

     this.transfer,
  });

  @JsonKey(
    
    name: r'id',
    required: false,
    includeIfNull: false,
  )


  final int? id;



  @JsonKey(
    
    name: r'transactionDate',
    required: false,
    includeIfNull: false,
  )


  final DateTime? transactionDate;



  @JsonKey(
    
    name: r'description',
    required: false,
    includeIfNull: false,
  )


  final String? description;



  @JsonKey(
    
    name: r'merchant',
    required: false,
    includeIfNull: false,
  )


  final String? merchant;



  @JsonKey(
    
    name: r'categoryId',
    required: false,
    includeIfNull: false,
  )


  final int? categoryId;



  @JsonKey(
    
    name: r'category',
    required: false,
    includeIfNull: false,
  )


  final String? category;



  @JsonKey(
    
    name: r'subCategoryId',
    required: false,
    includeIfNull: false,
  )


  final int? subCategoryId;



  @JsonKey(
    
    name: r'subCategory',
    required: false,
    includeIfNull: false,
  )


  final String? subCategory;



  @JsonKey(
    
    name: r'amount',
    required: false,
    includeIfNull: false,
  )


  final num? amount;



  @JsonKey(
    
    name: r'transactionType',
    required: false,
    includeIfNull: false,
  )


  final TransactionResponseTransactionTypeEnum? transactionType;



  @JsonKey(
    
    name: r'balance',
    required: false,
    includeIfNull: false,
  )


  final num? balance;



  @JsonKey(
    
    name: r'currency',
    required: false,
    includeIfNull: false,
  )


  final String? currency;



  @JsonKey(
    
    name: r'reference',
    required: false,
    includeIfNull: false,
  )


  final String? reference;



  @JsonKey(
    
    name: r'accountId',
    required: false,
    includeIfNull: false,
  )


  final int? accountId;



  @JsonKey(
    
    name: r'creditCardId',
    required: false,
    includeIfNull: false,
  )


  final int? creditCardId;



  @JsonKey(
    
    name: r'transfer',
    required: false,
    includeIfNull: false,
  )


  final bool? transfer;





    @override
    bool operator ==(Object other) => identical(this, other) || other is TransactionResponse &&
      other.id == id &&
      other.transactionDate == transactionDate &&
      other.description == description &&
      other.merchant == merchant &&
      other.categoryId == categoryId &&
      other.category == category &&
      other.subCategoryId == subCategoryId &&
      other.subCategory == subCategory &&
      other.amount == amount &&
      other.transactionType == transactionType &&
      other.balance == balance &&
      other.currency == currency &&
      other.reference == reference &&
      other.accountId == accountId &&
      other.creditCardId == creditCardId &&
      other.transfer == transfer;

    @override
    int get hashCode =>
        id.hashCode +
        transactionDate.hashCode +
        description.hashCode +
        merchant.hashCode +
        categoryId.hashCode +
        category.hashCode +
        subCategoryId.hashCode +
        subCategory.hashCode +
        amount.hashCode +
        transactionType.hashCode +
        balance.hashCode +
        currency.hashCode +
        reference.hashCode +
        accountId.hashCode +
        creditCardId.hashCode +
        transfer.hashCode;

  factory TransactionResponse.fromJson(Map<String, dynamic> json) => _$TransactionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum TransactionResponseTransactionTypeEnum {
@JsonValue(r'CREDIT')
CREDIT(r'CREDIT'),
@JsonValue(r'DEBIT')
DEBIT(r'DEBIT');

const TransactionResponseTransactionTypeEnum(this.value);

final String value;

@override
String toString() => value;
}


