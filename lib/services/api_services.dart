import 'package:dio/dio.dart';
import 'package:fix_it/models/auth_refresh_model.dart';
import 'package:fix_it/models/completion_qr_model.dart';
import 'package:fix_it/models/provider_profile_model.dart';
import 'package:fix_it/models/rating_summary_model.dart';
import 'package:fix_it/token_storage.dart';
import 'package:fix_it/models/specialization_model.dart';
import 'package:fix_it/models/order_model.dart';
import 'package:fix_it/models/subscription_status_model.dart';
import 'package:fix_it/models/subscription_plan_model.dart';
import 'package:fix_it/models/subscription_payment_request_model.dart';
import 'package:fix_it/models/provider_subscription_model.dart';
import 'package:fix_it/models/offer_model.dart';
import 'package:fix_it/models/notification_model.dart';
import 'package:fix_it/services/auth_interceptor.dart';

class ApiService {
  final TokenStorage tokenStorage = TokenStorage(); //*this is instance of token

  late final Dio dio;

  ApiService() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'http://192.168.1.105:5154/api/',
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(AuthInterceptor(tokenStorage: tokenStorage, dio: dio));
  }
  //*_____________________________*//
  //*this is for login endpoint*//
  Future<Response> login(String email, String password) async {
    final response = await dio.post(
      'Auth/login', //*address of api
      data: {'email': email, 'password': password},
    );

    final accessToken =
        response.data['accessToken']; //*if data is okay he return access
    final refreshToken = response.data['refreshToken']; //* and refresh token

    if (accessToken != null) {
      await tokenStorage.saveTokens(accessToken, refreshToken); //*to save token
    }

    return response;
  }

  //*___________________________*//
  //* this is for refresh token*//
  Future<AuthRefreshModel> refreshToken(String refreshToken) async {
    final response = await dio.post(
      'Auth/refresh',
      data: {'refreshToken': refreshToken},
    );

    return AuthRefreshModel.fromJson(response.data);
  }

  //*__________________________*//
  //*this is for register*//
  Future<Response> register(
    String fullName,
    String email,
    String phoneNumber,
    String password,
  ) async {
    return await dio.post(
      'Auth/register',
      data: {
        'fullName': fullName,
        'email': email,
        'phoneNumber': phoneNumber,
        'password': password,
      },
    );
  }

  //*_____________________________*//
  //* this is for verify email*//
  Future<Response> verifyEmail(String email, String code) async {
    return await dio.post(
      'Auth/verify-email',
      data: {'email': email, 'code': code},
    );
  }

  //*_____________________________*//
  //*this is for for logout*//
  Future<void> logout() async {
    await tokenStorage.clearTokens(); //*this is for deleate the token
  }

  //*_____________________________*//
  //*this is for get specialization*//
  Future<List<SpecializationModel>> getSpecializations() async {
    // print("TOKEN: ${await tokenStorage.getAccessToken()}");

    final response = await dio.get('specializations'); //*to get spec from db

    // print("STATUS: ${response.statusCode}");
    // print("DATA: ${response.data}");

    // print('RAW SPECIALIZATIONS: ${response.data}');
    //*that mean the dio return data in list dynamic and i change it into model type
    final List<dynamic> data = response.data;

    return data //*to change from dynamic into object
        .map(
          (item) => SpecializationModel.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }
  //*_____________________________*//
  //*this is for create order*//

  Future<Response> createOrder({
    required int specializationId,
    required String description,
    required double latitude,
    required double longitude,
    required String addressText,
  }) async {
    return await dio.post(
      'orders',
      data: {
        'specializationId': specializationId,
        'description': description,
        'latitude': latitude,
        'longitude': longitude,
        'addressText': addressText,
      },
    );
  }

  //*_____________________________*//
  //*this is for get my orders *//
  Future<List<OrderModel>> getMyOrders() async {
    final response = await dio.get('orders/my');

    final List<dynamic> data = response.data;

    return data
        .map((item) => OrderModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  //*_____________________________*//
  //*this is for get orderaccording id*//
  Future<OrderModel> getOrderById(int id) async {
    final response = await dio.get('orders/$id');

    return OrderModel.fromJson(response.data as Map<String, dynamic>);
  }

  //*_____________________________*//
  //*this is for cancel the order according the id *//
  Future<void> cancelOrder(int orderId) async {
    await dio.patch('orders/$orderId/cancel');
  }

  //*_____________________________*//
  //* this is for update order*//
  Future<Response> updateOrder({
    required int orderId,
    required int specializationId,
    required String description,
    required double latitude,
    required double longitude,
    required String addressText,
  }) async {
    return await dio.put(
      'orders/$orderId',
      data: {
        'specializationId': specializationId,
        'description': description,
        'latitude': latitude,
        'longitude': longitude,
        'addressText': addressText,
      },
    );
  }

  Future<ProviderProfileModel> getMyProviderProfile() async {
    final response = await dio.get('provider-profile/me');

    return ProviderProfileModel.fromJson(response.data as Map<String, dynamic>);
  }

  //*____________________________*//
  //*this is for cerate profile account *//
  Future<Response> createProviderProfile({
    required int specializationId,
    String? bio,
  }) async {
    return await dio.post(
      'provider-profile',
      data: {'specializationId': specializationId, 'bio': bio},
    );
  }

  Future<ProviderProfileModel> updateMyProviderProfile({
    required String bio,
  }) async {
    final response = await dio.put('provider-profile/me', data: {'bio': bio});

    return ProviderProfileModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<SubscriptionStatusModel> getSubscriptionStatus() async {
    final response = await dio.get('provider-profile/me/subscription-status');

    return SubscriptionStatusModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  //*_____________________________*//
  //*this is for available order for provider*//
  Future<List<OrderModel>> getAvailableProviderOrders() async {
    final response = await dio.get('provider/orders/available');

    final List<dynamic> data = response.data;

    return data
        .map((item) => OrderModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  //*_____________________________*//
  //*this is for order assigned to the provider*//
  Future<List<OrderModel>> getAssignedProviderOrders() async {
    final response = await dio.get('provider/orders/assigned');

    final List<dynamic> data = response.data;

    return data
        .map((item) => OrderModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  //*_____________________________*//
  //* to get subscription plan *//
  Future<List<SubscriptionPlanModel>> getSubscriptionPlans() async {
    final response = await dio.get('subscription-plans');

    final List<dynamic> data = response.data;

    return data
        .map(
          (item) =>
              SubscriptionPlanModel.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }

  //*_____________________________*//
  //*to create subscribtion requast*//
  Future<SubscriptionPaymentRequestModel> createSubscriptionPaymentRequest({
    required int subscriptionPlanId,
    required String transactionId,
    String? proofImageUrl,
  }) async {
    final response = await dio.post(
      'subscription-payment-requests',
      data: {
        'subscriptionPlanId': subscriptionPlanId,
        'paymentMethod': 1,
        'transactionId': transactionId,
        'proofImageUrl': proofImageUrl,
      },
    );

    return SubscriptionPaymentRequestModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  Future<List<SubscriptionPaymentRequestModel>>
  getMySubscriptionPaymentRequests() async {
    final response = await dio.get('subscription-payment-requests/me');

    final List<dynamic> data = response.data;

    return data
        .map(
          (item) => SubscriptionPaymentRequestModel.fromJson(
            item as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  //*________________________________*//
  //* to get my subscripein *//
  Future<List<ProviderSubscriptionModel>> getMyProviderSubscriptions() async {
    final response = await dio.get('provider-subscriptions/me');

    final List<dynamic> data = response.data;

    return data
        .map(
          (item) =>
              ProviderSubscriptionModel.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }

  Future<OfferModel> createOffer({
    required int orderId,
    required double inspectionPrice,
    String? note,
    required double providerLatitude,
    required double providerLongitude,
  }) async {
    final response = await dio.post(
      'offers',
      data: {
        'orderId': orderId,
        'inspectionPrice': inspectionPrice,
        'note': note,
        'providerLatitude': providerLatitude,
        'providerLongitude': providerLongitude,
      },
    );

    return OfferModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<List<OfferModel>> getMyOffers() async {
    final response = await dio.get('offers/my');

    final List<dynamic> data = response.data;

    return data
        .map((item) => OfferModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<OfferModel>> getOrderOffers(int orderId) async {
    final response = await dio.get('orders/$orderId/offers');

    final List<dynamic> data = response.data;

    return data
        .map((item) => OfferModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<OfferModel> acceptInspectionOffer(int offerId) async {
    final response = await dio.patch('offers/$offerId/accept-inspection');

    return OfferModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<OfferModel> continueWorkOffer(int offerId) async {
    final response = await dio.patch('offers/$offerId/continue-work');

    return OfferModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<OfferModel> rejectAfterInspectionOffer(int offerId) async {
    final response = await dio.patch('offers/$offerId/reject-after-inspection');

    return OfferModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<OfferModel> updateOffer({
    required int offerId,
    required double inspectionPrice,
    String? note,
    required double providerLatitude,
    required double providerLongitude,
  }) async {
    final response = await dio.put(
      'offers/$offerId',
      data: {
        'inspectionPrice': inspectionPrice,
        'note': note,
        'providerLatitude': providerLatitude,
        'providerLongitude': providerLongitude,
      },
    );

    return OfferModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> cancelOffer(int offerId) async {
    await dio.patch('offers/$offerId/cancel');
  }

  Future<void> rejectOffer(int offerId) async {
    await dio.patch('offers/$offerId/reject');
  }

  //*____________________________*//
  //*this is for ratieng the order after compleated*//
  Future<void> createRating({required int orderId, required int value}) async {
    await dio.post('ratings', data: {'orderId': orderId, 'value': value});
  }
    //*____________________________*//
    //*this is for get all the rateing*//
  Future<RatingSummaryModel> getProviderRatingSummary(
    int providerProfileId,
  ) async {
    final response = await dio.get(
      'providers/$providerProfileId/rating-summary',
    );

    return RatingSummaryModel.fromJson(response.data as Map<String, dynamic>);
  }

          //*____________________________*//
          //*this is for git notification *//
  Future<List<NotificationModel>> getNotifications() async {
    final response = await dio.get('notifications');

    final List data = response.data as List;

    return data
        .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
      //*____________________________*//
      //*this is for make notification read all *//
  Future<void> markAllNotificationsAsRead() async {
    await dio.patch('notifications/read-all');
  }


  Future<CompletionQrModel> generateCompletionQr(int orderId) async {
    final response = await dio.post('orders/$orderId/completion-qr');

    return CompletionQrModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> completeOrderByQr({
    required int orderId,
    required String token,
  }) async {
    await dio.post(
      'orders/complete-by-qr',
      data: {'orderId': orderId, 'token': token},
    );
  }
}
