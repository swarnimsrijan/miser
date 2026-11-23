//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'statement_response.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class StatementResponse {
  /// Returns a new [StatementResponse] instance.
  StatementResponse({

     this.id,

     this.statementType,

     this.status,

     this.accountId,

     this.creditCardId,

     this.fromDate,

     this.toDate,

     this.uploadedAt,

     this.issuer,

     this.parserLayout,

     this.transactionCount,
  });

  @JsonKey(
    
    name: r'id',
    required: false,
    includeIfNull: false,
  )


  final int? id;



  @JsonKey(
    
    name: r'statementType',
    required: false,
    includeIfNull: false,
  )


  final StatementResponseStatementTypeEnum? statementType;



  @JsonKey(
    
    name: r'status',
    required: false,
    includeIfNull: false,
  )


  final String? status;



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
    
    name: r'fromDate',
    required: false,
    includeIfNull: false,
  )


  final DateTime? fromDate;



  @JsonKey(
    
    name: r'toDate',
    required: false,
    includeIfNull: false,
  )


  final DateTime? toDate;



  @JsonKey(
    
    name: r'uploadedAt',
    required: false,
    includeIfNull: false,
  )


  final DateTime? uploadedAt;



  @JsonKey(
    
    name: r'issuer',
    required: false,
    includeIfNull: false,
  )


  final String? issuer;



  @JsonKey(
    
    name: r'parserLayout',
    required: false,
    includeIfNull: false,
  )


  final String? parserLayout;



  @JsonKey(
    
    name: r'transactionCount',
    required: false,
    includeIfNull: false,
  )


  final int? transactionCount;





    @override
    bool operator ==(Object other) => identical(this, other) || other is StatementResponse &&
      other.id == id &&
      other.statementType == statementType &&
      other.status == status &&
      other.accountId == accountId &&
      other.creditCardId == creditCardId &&
      other.fromDate == fromDate &&
      other.toDate == toDate &&
      other.uploadedAt == uploadedAt &&
      other.issuer == issuer &&
      other.parserLayout == parserLayout &&
      other.transactionCount == transactionCount;

    @override
    int get hashCode =>
        id.hashCode +
        statementType.hashCode +
        status.hashCode +
        accountId.hashCode +
        creditCardId.hashCode +
        fromDate.hashCode +
        toDate.hashCode +
        uploadedAt.hashCode +
        issuer.hashCode +
        parserLayout.hashCode +
        transactionCount.hashCode;

  factory StatementResponse.fromJson(Map<String, dynamic> json) => _$StatementResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StatementResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum StatementResponseStatementTypeEnum {
@JsonValue(r'PDF')
PDF(r'PDF'),
@JsonValue(r'CSV')
CSV(r'CSV'),
@JsonValue(r'XLSX')
XLSX(r'XLSX');

const StatementResponseStatementTypeEnum(this.value);

final String value;

@override
String toString() => value;
}


