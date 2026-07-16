import 'package:fix_it/token_storage.dart';
import 'package:flutter/material.dart';
// import 'hoe/services/api_service.dart';
import 'package:fix_it/services/api_services.dart';
import 'package:dio/dio.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService apiService =
      ApiService(); //*this is instance of api services
  final TokenStorage tokenStorage = TokenStorage();
  String? authError;
  //*_____________________________*//
  //*this is for login*//
  bool isLoading = false; //*this is for if have a operation
  Future<bool> login(String email, String password) async {
    try {
      isLoading = true;
      authError = null;
      notifyListeners();

      await apiService.login(email, password);

      return true;
    } on DioException catch (e) {
      debugPrint('LOGIN STATUS: ${e.response?.statusCode}');
      debugPrint('LOGIN DATA: ${e.response?.data}');
      debugPrint('LOGIN MESSAGE: ${e.message}');

      final data = e.response?.data;

      if (data is Map<String, dynamic>) {
        authError =
            data['message']?.toString() ??
            data['title']?.toString() ??
            'Login failed';
      } else if (data != null) {
        authError = data.toString();
      } else {
        authError = 'Login failed';
      }

      return false;
    } catch (e) {
      debugPrint('LOGIN UNKNOWN ERROR: $e');

      authError = 'حدث خطأ غير متوقع';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> refreshToken() async {
    try {
      final oldRefreshToken = await tokenStorage.getRefreshToken();

      if (oldRefreshToken == null) {
        return false;
      }

      final result = await apiService.refreshToken(oldRefreshToken);

      await tokenStorage.saveTokens(result.accessToken, result.refreshToken);

      return true;
    } catch (e) {
      debugPrint('REFRESH TOKEN ERROR: $e');

      await tokenStorage.clearTokens();

      return false;
    }
  }

  //*_____________________________*//
  //*this is for register *//
  Future<bool> register(
    String fullName,
    String email,
    String phoneNumber,
    String password,
  ) async {
    try {
      isLoading = true;
      authError = null;
      notifyListeners();

      final response = await apiService.register(
        fullName,
        email,
        phoneNumber,
        password,
      );

      return true;
    } catch (e) {
      if (e is DioException) {
        authError =
            e.response?.data?['message'] ??
            e.response?.data?.toString() ??
            'Register failed';

        debugPrint('REGISTER ERROR: $authError');
      } else {
        authError = 'Something went wrong';
      }

      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  //*_____________________________*//
  //*this is for verify email*//
  Future<bool> verifyEmail(String email, String code) async {
    try {
      isLoading = true;
      authError = null;
      notifyListeners();

      await apiService.verifyEmail(email, code);

      return true;
    } on DioException catch (e) {
      debugPrint('VERIFY STATUS: ${e.response?.statusCode}');

      debugPrint('VERIFY DATA: ${e.response?.data}');

      debugPrint('VERIFY MESSAGE: ${e.message}');

      final data = e.response?.data;

      if (data is Map<String, dynamic>) {
        authError =
            data['message']?.toString() ??
            data['title']?.toString() ??
            'Verification failed';
      } else if (data != null) {
        authError = data.toString();
      } else {
        authError = 'Verification failed';
      }

      return false;
    } catch (e) {
      debugPrint('VERIFY UNKNOWN ERROR: $e');

      authError = 'حدث خطأ غير متوقع';

      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  bool isLoggingOut = false;
  String? logoutError;

  Future<bool> logout() async {
    try {
      isLoggingOut = true;
      logoutError = null;
      notifyListeners();

      await apiService.logout();

      return true;
    } catch (e) {
      debugPrint('LOGOUT ERROR: $e');

      logoutError = 'حدث خطأ أثناء تسجيل الخروج';

      return false;
    } finally {
      isLoggingOut = false;
      notifyListeners();
    }
  }
}
