import 'package:dio/dio.dart';
import 'package:fix_it/token_storage.dart';

class AuthInterceptor extends Interceptor {
  final TokenStorage tokenStorage;
  final Dio dio;

  bool isRefreshing = false;

  AuthInterceptor({
    required this.tokenStorage,
    required this.dio,
  });


  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {

    final token =
        await tokenStorage.getAccessToken();

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] =
          'Bearer $token';
    }

    handler.next(options);
  }


  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {

    if (err.response?.statusCode == 401 &&
        !isRefreshing) {

      isRefreshing = true;

      try {

        final refreshToken =
            await tokenStorage.getRefreshToken();

        if (refreshToken == null) {
          return handler.next(err);
        }


        final response = await dio.post(
          'Auth/refresh',
          data: {
            'refreshToken': refreshToken,
          },
        );


        final newAccessToken =
            response.data['accessToken'];

        final newRefreshToken =
            response.data['refreshToken'];


        await tokenStorage.saveTokens(
          newAccessToken,
          newRefreshToken,
        );


        // إعادة الطلب القديم
        final request =
            err.requestOptions;


        request.headers['Authorization'] =
            'Bearer $newAccessToken';


        final retryResponse =
            await dio.fetch(request);


        return handler.resolve(
          retryResponse,
        );


      } catch (e) {

        await tokenStorage.clearTokens();

        return handler.next(err);

      } finally {

        isRefreshing = false;

      }
    }


    handler.next(err);
  }
}