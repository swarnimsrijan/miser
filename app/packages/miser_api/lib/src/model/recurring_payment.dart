//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recurring_payment.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class RecurringPayment {
  /// Returns a new [RecurringPayment] instance.
  RecurringPayment({

     this.name,

     this.category,

     this.frequency,

     this.typicalAmount,

     this.monthlyEquivalent,

     this.occurrences,

     this.lastDate,

     this.nextExpectedDate,

     this.active,
  });

  @JsonKey(
    
    name: r'name',
    required: false,
    includeIfNull: false,
  )


  final String? name;



  @JsonKey(
    
    name: r'category',
    required: false,
    includeIfNull: false,
  )


  final String? category;



  @JsonKey(
    
    name: r'frequency',
    required: false,
    includeIfNull: false,
  )


  final RecurringPaymentFrequencyEnum? frequency;



  @JsonKey(
    
    name: r'typicalAmount',
    required: false,
    includeIfNull: false,
  )


  final num? typicalAmount;



  @JsonKey(
    
    name: r'monthlyEquivalent',
    required: false,
    includeIfNull: false,
  )


  final num? monthlyEquivalent;



  @JsonKey(
    
    name: r'occurrences',
    required: false,
    includeIfNull: false,
  )


  final int? occurrences;



  @JsonKey(
    
    name: r'lastDate',
    required: false,
    includeIfNull: false,
  )


  final DateTime? lastDate;



  @JsonKey(
    
    name: r'nextExpectedDate',
    required: false,
    includeIfNull: false,
  )


  final DateTime? nextExpectedDate;



  @JsonKey(
    
    name: r'active',
    required: false,
    includeIfNull: false,
  )


  final bool? active;





    @override
    bool operator ==(Object other) => identical(this, other) || other is RecurringPayment &&
      other.name == name &&
      other.category == category &&
      other.frequency == frequency &&
      other.typicalAmount == typicalAmount &&
      other.monthlyEquivalent == monthlyEquivalent &&
      other.occurrences == occurrences &&
      other.lastDate == lastDate &&
      other.nextExpectedDate == nextExpectedDate &&
      other.active == active;

    @override
    int get hashCode =>
        name.hashCode +
        category.hashCode +
        frequency.hashCode +
        typicalAmount.hashCode +
        monthlyEquivalent.hashCode +
        occurrences.hashCode +
        lastDate.hashCode +
        nextExpectedDate.hashCode +
        active.hashCode;

  factory RecurringPayment.fromJson(Map<String, dynamic> json) => _$RecurringPaymentFromJson(json);

  Map<String, dynamic> toJson() => _$RecurringPaymentToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum RecurringPaymentFrequencyEnum {
@JsonValue(r'WEEKLY')
WEEKLY(r'WEEKLY'),
@JsonValue(r'MONTHLY')
MONTHLY(r'MONTHLY'),
@JsonValue(r'QUARTERLY')
QUARTERLY(r'QUARTERLY'),
@JsonValue(r'YEARLY')
YEARLY(r'YEARLY');

const RecurringPaymentFrequencyEnum(this.value);

final String value;

@override
String toString() => value;
}


