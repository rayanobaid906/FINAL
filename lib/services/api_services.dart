import 'package:dio/dio.dart';
import 'package:fix_it/models/provider_profile_model.dart';
import 'package:fix_it/token_storage.dart';
import 'package:fix_it/models/specialization_model.dart';
import 'package:fix_it/models/order_model.dart';
import 'package:fix_it/models/subscription_status_model.dart';
import 'package:fix_it/models/subscription_plan_model.dart';
import 'package:fix_it/models/subscription_payment_request_model.dart';
import 'package:fix_it/models/provider_subscription_model.dart';
import 'package:fix_it/models/offer_model.dart';

class ApiService {
  final TokenStorage tokenStorage = TokenStorage(); //*this is instance of token

  late final Dio dio =
      Dio(
          BaseOptions(
            baseUrl:
                'http://192.168.1.105:5154/api/', //*this is the base url of backend
            headers: {
              'Content-Type': 'application/json',
            }, //* this is the format of data
          ),
        )
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) async {
              final token = await tokenStorage
                  .getAccessToken(); //* before get anything he get accesstoken

              print('REQUEST URL: ${options.baseUrl}${options.path}');
              print('TOKEN SENT: $token');

              if (token != null && token.isNotEmpty) {
                //* that mean if have token put it in the headers
                options.headers['Authorization'] = 'Bearer $token';
              }

              print('REQUEST HEADERS: ${options.headers}');
              print('REQUEST DATA: ${options.data}');

              return handler.next(options); //* this is the end of interceptors
            },
          ),
        );

  Future<Response> login(String email, String password) async {
    final response = await dio.post(
      'Auth/login',
      data: {'email': email, 'password': password},
    );

    final accessToken = response.data['accessToken'];
    final refreshToken = response.data['refreshToken'];

    if (accessToken != null) {
      await tokenStorage.saveTokens(accessToken, refreshToken);
    }

    return response;
  }

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

  Future<Response> verifyEmail(String email, String code) async {
    return await dio.post(
      'Auth/verify-email',
      data: {'email': email, 'code': code},
    );
  }

  //*this is for for logout
  Future<void> logout() async {
    await tokenStorage.clearTokens();
  }

  Future<List<SpecializationModel>> getSpecializations() async {
    print("TOKEN: ${await tokenStorage.getAccessToken()}");

    final response = await dio.get('specializations');

    print("STATUS: ${response.statusCode}");
    print("DATA: ${response.data}");

    print('RAW SPECIALIZATIONS: ${response.data}');

    final List<dynamic> data = response.data;

    return data
        .map(
          (item) => SpecializationModel.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }

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

  Future<List<OrderModel>> getMyOrders() async {
    final response = await dio.get('orders/my');

    final List<dynamic> data = response.data;

    return data
        .map((item) => OrderModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<OrderModel> getOrderById(int id) async {
    final response = await dio.get('orders/$id');

    return OrderModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> cancelOrder(int orderId) async {
    await dio.patch('orders/$orderId/cancel');
  }

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

  Future<List<OrderModel>> getAvailableProviderOrders() async {
    final response = await dio.get('provider/orders/available');

    final List<dynamic> data = response.data;

    return data
        .map((item) => OrderModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<OrderModel>> getAssignedProviderOrders() async {
    final response = await dio.get('provider/orders/assigned');

    final List<dynamic> data = response.data;

    return data
        .map((item) => OrderModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

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
}
