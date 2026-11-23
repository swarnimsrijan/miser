import 'package:miser_api/src/model/account_response.dart';
import 'package:miser_api/src/model/bank.dart';
import 'package:miser_api/src/model/budget_request.dart';
import 'package:miser_api/src/model/budget_response.dart';
import 'package:miser_api/src/model/budget_status.dart';
import 'package:miser_api/src/model/category.dart';
import 'package:miser_api/src/model/category_change.dart';
import 'package:miser_api/src/model/category_line.dart';
import 'package:miser_api/src/model/contribution_request.dart';
import 'package:miser_api/src/model/create_account_request.dart';
import 'package:miser_api/src/model/create_credit_card_request.dart';
import 'package:miser_api/src/model/create_goal_request.dart';
import 'package:miser_api/src/model/credit_card_response.dart';
import 'package:miser_api/src/model/goal_eta.dart';
import 'package:miser_api/src/model/goal_response.dart';
import 'package:miser_api/src/model/me_response.dart';
import 'package:miser_api/src/model/one_off.dart';
import 'package:miser_api/src/model/page_transaction_response.dart';
import 'package:miser_api/src/model/pageable_object.dart';
import 'package:miser_api/src/model/projected_month.dart';
import 'package:miser_api/src/model/reconciliation_result.dart';
import 'package:miser_api/src/model/recurring_payment.dart';
import 'package:miser_api/src/model/scenario.dart';
import 'package:miser_api/src/model/sort_object.dart';
import 'package:miser_api/src/model/statement_response.dart';
import 'package:miser_api/src/model/sub_category.dart';
import 'package:miser_api/src/model/tip.dart';
import 'package:miser_api/src/model/transaction_response.dart';
import 'package:miser_api/src/model/update_goal_request.dart';
import 'package:miser_api/src/model/update_transaction_category_request.dart';
import 'package:miser_api/src/model/what_if_request.dart';
import 'package:miser_api/src/model/what_if_response.dart';

final _regList = RegExp(r'^List<(.*)>$');
final _regSet = RegExp(r'^Set<(.*)>$');
final _regMap = RegExp(r'^Map<String,(.*)>$');

  ReturnType deserialize<ReturnType, BaseType>(dynamic value, String targetType, {bool growable= true}) {
      switch (targetType) {
        case 'String':
          return '$value' as ReturnType;
        case 'int':
          return (value is int ? value : int.parse('$value')) as ReturnType;
        case 'bool':
          if (value is bool) {
            return value as ReturnType;
          }
          final valueString = '$value'.toLowerCase();
          return (valueString == 'true' || valueString == '1') as ReturnType;
        case 'double':
          return (value is double ? value : double.parse('$value')) as ReturnType;
        case 'AccountResponse':
          return AccountResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'Bank':
          return Bank.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'BudgetRequest':
          return BudgetRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'BudgetResponse':
          return BudgetResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'BudgetStatus':
          return BudgetStatus.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'Category':
          return Category.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'CategoryChange':
          return CategoryChange.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'CategoryLine':
          return CategoryLine.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ContributionRequest':
          return ContributionRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'CreateAccountRequest':
          return CreateAccountRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'CreateCreditCardRequest':
          return CreateCreditCardRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'CreateGoalRequest':
          return CreateGoalRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'CreditCardResponse':
          return CreditCardResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'GoalEta':
          return GoalEta.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'GoalResponse':
          return GoalResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'MeResponse':
          return MeResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'OneOff':
          return OneOff.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PageTransactionResponse':
          return PageTransactionResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PageableObject':
          return PageableObject.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ProjectedMonth':
          return ProjectedMonth.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ReconciliationResult':
          return ReconciliationResult.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'RecurringPayment':
          return RecurringPayment.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'Scenario':
          return Scenario.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SortObject':
          return SortObject.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'StatementResponse':
          return StatementResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SubCategory':
          return SubCategory.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'Tip':
          return Tip.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'TransactionResponse':
          return TransactionResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UpdateGoalRequest':
          return UpdateGoalRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UpdateTransactionCategoryRequest':
          return UpdateTransactionCategoryRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'WhatIfRequest':
          return WhatIfRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'WhatIfResponse':
          return WhatIfResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
        default:
          RegExpMatch? match;

          if (value is List && (match = _regList.firstMatch(targetType)) != null) {
            targetType = match![1]!; // ignore: parameter_assignments
            return value
              .map<BaseType>((dynamic v) => deserialize<BaseType, BaseType>(v, targetType, growable: growable))
              .toList(growable: growable) as ReturnType;
          }
          if (value is Set && (match = _regSet.firstMatch(targetType)) != null) {
            targetType = match![1]!; // ignore: parameter_assignments
            return value
              .map<BaseType>((dynamic v) => deserialize<BaseType, BaseType>(v, targetType, growable: growable))
              .toSet() as ReturnType;
          }
          if (value is Map && (match = _regMap.firstMatch(targetType)) != null) {
            targetType = match![1]!.trim(); // ignore: parameter_assignments
            return Map<String, BaseType>.fromIterables(
              value.keys as Iterable<String>,
              value.values.map((dynamic v) => deserialize<BaseType, BaseType>(v, targetType, growable: growable)),
            ) as ReturnType;
          }
          break;
    }
    throw Exception('Cannot deserialize');
  }