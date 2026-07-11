import 'package:dio/dio.dart';
import 'package:fix_it/token_storage.dart';
import 'package:fix_it/models/specialization_model.dart';
import 'package:fix_it/models/order_model.dart';
class ApiService {
  final TokenStorage tokenStorage = TokenStorage();

  late final Dio dio =
      Dio(
          BaseOptions(
            baseUrl: 'http://192.168.1.105:5154/api/',
            headers: {'Content-Type': 'application/json'},
          ),
        )
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) async {
              final token = await tokenStorage.getAccessToken();

              print('REQUEST URL: ${options.baseUrl}${options.path}');
              print('TOKEN SENT: $token');

              if (token != null && token.isNotEmpty) {
                options.headers['Authorization'] = 'Bearer $token';
              }

              print('REQUEST HEADERS: ${options.headers}');
              print('REQUEST DATA: ${options.data}');

              return handler.next(options);
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
      .map(
        (item) => OrderModel.fromJson(
          item as Map<String, dynamic>,
        ),
      )
      .toList();
}



Future<OrderModel> getOrderById(int id) async {
  final response = await dio.get('orders/$id');

  return OrderModel.fromJson(
    response.data as Map<String, dynamic>,
  );
}
Future<void> cancelOrder(int orderId) async {
  await dio.patch(
    'orders/$orderId/cancel',
  );
}


}
