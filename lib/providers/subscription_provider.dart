import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fix_it/models/subscription_plan_model.dart';
import 'package:fix_it/services/api_services.dart';
import 'package:fix_it/models/subscription_payment_request_model.dart';
import 'package:fix_it/models/provider_subscription_model.dart';


class SubscriptionProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();

  List<SubscriptionPlanModel> plans = [];

  bool isLoadingPlans = false;
  String? plansError;

  Future<void> getSubscriptionPlans() async {
    try {
      isLoadingPlans = true;
      plansError = null;
      notifyListeners();

      plans = await apiService.getSubscriptionPlans();

      debugPrint(
        'SUBSCRIPTION PLANS COUNT: ${plans.length}',
      );
    } catch (e) {
      plansError = 'فشل تحميل خطط الاشتراك';

      debugPrint(
        'SUBSCRIPTION PLANS ERROR: $e',
      );
    } finally {
      isLoadingPlans = false;
      notifyListeners();
    }
  }
SubscriptionPaymentRequestModel? paymentRequest;

bool isSubmittingPaymentRequest = false;

String? submitPaymentRequestError;

Future<bool> submitPaymentRequest({
  required int subscriptionPlanId,
  required String transactionId,
  String? proofImageUrl,
}) async {
  try {
    isSubmittingPaymentRequest = true;
    submitPaymentRequestError = null;
    notifyListeners();

    paymentRequest =
        await apiService.createSubscriptionPaymentRequest(
      subscriptionPlanId: subscriptionPlanId,
      transactionId: transactionId,
      proofImageUrl: proofImageUrl,
    );

    return true;
  } on DioException catch (e) {
    debugPrint(
      'SUBMIT PAYMENT STATUS: ${e.response?.statusCode}',
    );
    debugPrint(
      'SUBMIT PAYMENT DATA: ${e.response?.data}',
    );
    debugPrint(
      'SUBMIT PAYMENT MESSAGE: ${e.message}',
    );

    if (e.response?.statusCode == 400) {
      final message = e.response?.data.toString() ?? '';

      if (message.contains('pending subscription request')) {
        submitPaymentRequestError =
            'لديك طلب اشتراك قيد المراجعة بالفعل';
      } else {
        submitPaymentRequestError = message;
      }
    } else {
      submitPaymentRequestError =
          'فشل إرسال طلب الاشتراك';
    }

    return false;
  } catch (e) {
    debugPrint(
      'SUBMIT PAYMENT UNKNOWN ERROR: $e',
    );

    submitPaymentRequestError =
        'حدث خطأ غير متوقع';

    return false;
  } finally {
    isSubmittingPaymentRequest = false;
    notifyListeners();
  }
}
List<SubscriptionPaymentRequestModel> myPaymentRequests = [];

bool isLoadingMyPaymentRequests = false;

String? myPaymentRequestsError;

Future<void> getMySubscriptionPaymentRequests() async {
  try {
    isLoadingMyPaymentRequests = true;
    myPaymentRequestsError = null;
    notifyListeners();

    myPaymentRequests =
        await apiService.getMySubscriptionPaymentRequests();

    debugPrint(
      'MY PAYMENT REQUESTS COUNT: ${myPaymentRequests.length}',
    );
  } catch (e) {
    myPaymentRequestsError =
        'فشل تحميل طلبات الاشتراك';

    debugPrint(
      'MY PAYMENT REQUESTS ERROR: $e',
    );
  } finally {
    isLoadingMyPaymentRequests = false;
    notifyListeners();
  }
}
List<ProviderSubscriptionModel> mySubscriptions = [];

bool isLoadingMySubscriptions = false;

String? mySubscriptionsError;

Future<void> getMyProviderSubscriptions() async {
  try {
    isLoadingMySubscriptions = true;
    mySubscriptionsError = null;
    notifyListeners();

    mySubscriptions =
        await apiService.getMyProviderSubscriptions();

    debugPrint(
      'MY SUBSCRIPTIONS COUNT: ${mySubscriptions.length}',
    );
  } catch (e) {
    mySubscriptionsError =
        'فشل تحميل الاشتراكات';

    debugPrint(
      'MY SUBSCRIPTIONS ERROR: $e',
    );
  } finally {
    isLoadingMySubscriptions = false;
    notifyListeners();
  }
}

}