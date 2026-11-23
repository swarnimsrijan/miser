//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:dio/dio.dart';
import 'package:miser_api/src/auth/api_key_auth.dart';
import 'package:miser_api/src/auth/basic_auth.dart';
import 'package:miser_api/src/auth/bearer_auth.dart';
import 'package:miser_api/src/auth/oauth.dart';
import 'package:miser_api/src/api/account_controller_api.dart';
import 'package:miser_api/src/api/bank_controller_api.dart';
import 'package:miser_api/src/api/budget_controller_api.dart';
import 'package:miser_api/src/api/category_controller_api.dart';
import 'package:miser_api/src/api/credit_card_controller_api.dart';
import 'package:miser_api/src/api/dashboard_controller_api.dart';
import 'package:miser_api/src/api/goal_controller_api.dart';
import 'package:miser_api/src/api/insight_controller_api.dart';
import 'package:miser_api/src/api/me_controller_api.dart';
import 'package:miser_api/src/api/planner_controller_api.dart';
import 'package:miser_api/src/api/reconciliation_controller_api.dart';
import 'package:miser_api/src/api/report_controller_api.dart';
import 'package:miser_api/src/api/statement_controller_api.dart';
import 'package:miser_api/src/api/transaction_controller_api.dart';

class MiserApi {
  static const String basePath = r'http://localhost:8080';

  final Dio dio;
  MiserApi({
    Dio? dio,
    String? basePathOverride,
    List<Interceptor>? interceptors,
  })  : 
        this.dio = dio ??
            Dio(BaseOptions(
              baseUrl: basePathOverride ?? basePath,
              connectTimeout: const Duration(milliseconds: 5000),
              receiveTimeout: const Duration(milliseconds: 3000),
            )) {
    if (interceptors == null) {
      this.dio.interceptors.addAll([
        OAuthInterceptor(),
        BasicAuthInterceptor(),
        BearerAuthInterceptor(),
        ApiKeyAuthInterceptor(),
      ]);
    } else {
      this.dio.interceptors.addAll(interceptors);
    }
  }

  void setOAuthToken(String name, String token) {
    if (this.dio.interceptors.any((i) => i is OAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((i) => i is OAuthInterceptor) as OAuthInterceptor).tokens[name] = token;
    }
  }

  /// Removes the OAuth token associated with the given [name].
  ///
  /// If no [OAuthInterceptor] is registered or no token exists for the given
  /// [name], this method has no effect.
  void removeOAuthToken(String name) {
    if (this.dio.interceptors.any((i) => i is OAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((i) => i is OAuthInterceptor) as OAuthInterceptor).tokens.remove(name);
    }
  }

  void setBearerAuth(String name, String token) {
    if (this.dio.interceptors.any((i) => i is BearerAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((i) => i is BearerAuthInterceptor) as BearerAuthInterceptor).tokens[name] = token;
    }
  }

  /// Removes the bearer authentication token associated with the given [name].
  ///
  /// If no [BearerAuthInterceptor] is registered or no token exists for the
  /// given [name], this method has no effect.
  void removeBearerAuth(String name) {
    if (this.dio.interceptors.any((i) => i is BearerAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((i) => i is BearerAuthInterceptor) as BearerAuthInterceptor).tokens.remove(name);
    }
  }

  void setBasicAuth(String name, String username, String password) {
    if (this.dio.interceptors.any((i) => i is BasicAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((i) => i is BasicAuthInterceptor) as BasicAuthInterceptor).authInfo[name] = BasicAuthInfo(username, password);
    }
  }

  /// Removes the basic authentication credentials associated with the given [name].
  ///
  /// If no [BasicAuthInterceptor] is registered or no credentials exist for the
  /// given [name], this method has no effect.
  void removeBasicAuth(String name) {
    if (this.dio.interceptors.any((i) => i is BasicAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((i) => i is BasicAuthInterceptor) as BasicAuthInterceptor).authInfo.remove(name);
    }
  }

  void setApiKey(String name, String apiKey) {
    if (this.dio.interceptors.any((i) => i is ApiKeyAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((element) => element is ApiKeyAuthInterceptor) as ApiKeyAuthInterceptor).apiKeys[name] = apiKey;
    }
  }

  /// Removes the API key associated with the given [name].
  ///
  /// If no [ApiKeyAuthInterceptor] is registered or no API key exists for the
  /// given [name], this method has no effect.
  void removeApiKey(String name) {
    if (this.dio.interceptors.any((i) => i is ApiKeyAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((element) => element is ApiKeyAuthInterceptor) as ApiKeyAuthInterceptor).apiKeys.remove(name);
    }
  }

  /// Get AccountControllerApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AccountControllerApi getAccountControllerApi() {
    return AccountControllerApi(dio);
  }

  /// Get BankControllerApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BankControllerApi getBankControllerApi() {
    return BankControllerApi(dio);
  }

  /// Get BudgetControllerApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BudgetControllerApi getBudgetControllerApi() {
    return BudgetControllerApi(dio);
  }

  /// Get CategoryControllerApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  CategoryControllerApi getCategoryControllerApi() {
    return CategoryControllerApi(dio);
  }

  /// Get CreditCardControllerApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  CreditCardControllerApi getCreditCardControllerApi() {
    return CreditCardControllerApi(dio);
  }

  /// Get DashboardControllerApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  DashboardControllerApi getDashboardControllerApi() {
    return DashboardControllerApi(dio);
  }

  /// Get GoalControllerApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  GoalControllerApi getGoalControllerApi() {
    return GoalControllerApi(dio);
  }

  /// Get InsightControllerApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  InsightControllerApi getInsightControllerApi() {
    return InsightControllerApi(dio);
  }

  /// Get MeControllerApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  MeControllerApi getMeControllerApi() {
    return MeControllerApi(dio);
  }

  /// Get PlannerControllerApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  PlannerControllerApi getPlannerControllerApi() {
    return PlannerControllerApi(dio);
  }

  /// Get ReconciliationControllerApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  ReconciliationControllerApi getReconciliationControllerApi() {
    return ReconciliationControllerApi(dio);
  }

  /// Get ReportControllerApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  ReportControllerApi getReportControllerApi() {
    return ReportControllerApi(dio);
  }

  /// Get StatementControllerApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  StatementControllerApi getStatementControllerApi() {
    return StatementControllerApi(dio);
  }

  /// Get TransactionControllerApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  TransactionControllerApi getTransactionControllerApi() {
    return TransactionControllerApi(dio);
  }
}
