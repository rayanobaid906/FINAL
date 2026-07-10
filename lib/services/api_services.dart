import 'package:dio/dio.dart';
import 'package:fix_it/token_storage.dart';

class ApiService {
  final TokenStorage tokenStorage = TokenStorage();

  late final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'http://192.168.1.101:5154/api/',
      headers: {'Content-Type': 'application/json'},
    ),
  )..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await tokenStorage.getAccessToken();

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

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

  Future<Response> verifyEmail(
    String email,
    String code,
  ) async {
    return await dio.post(
      'Auth/verify-email',
      data: {
        'email': email,
        'code': code,
      },
    );
  }

  Future<void> logout() async {
    await tokenStorage.clearTokens();
  }
}