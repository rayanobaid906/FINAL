import 'package:fix_it/token_storage.dart';
import 'package:flutter/material.dart';
// import 'hoe/services/api_service.dart';
import 'package:fix_it/services/api_services.dart';
import 'package:dio/dio.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService apiService =
      ApiService(); //*this is instance of api services
  final TokenStorage tokenStorage = TokenStorage();

  //*_____________________________*//
  //*this is for login*//
  bool isLoading = false; //*this is for if have a operation
  Future<bool> login(String email, String password) async {
    try {
      isLoading = true;
      notifyListeners(); //*to tell to the ui to change the state to true

      final response = await apiService.login(email, password);

      
      // print(response.data);

      return true; //*that mean this okay and no exception
    } catch (e) {
      if (e is DioException) {
        debugPrint(
          'LOGIN STATUS: ${e.response?.statusCode}',
        ); //*the ? maybe null
        debugPrint('LOGIN DATA: ${e.response?.data}');
        debugPrint('LOGIN MESSAGE: ${e.message}');
      } else {
        debugPrint('LOGIN ERROR: $e');
      }

      return false;
    } finally {
      isLoading = false; //*this is for stop the loding
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
      notifyListeners();

      final response = await apiService.register(
        fullName,
        email,
        phoneNumber,
        password,
      );

      print(response.data);
      print("REGISTER SUCCESS");

      return true;
    } catch (e) {
      if (e is DioException) {
        debugPrint('REGISTER STATUS: ${e.response?.statusCode}');
        debugPrint('REGISTER DATA: ${e.response?.data}');
        debugPrint('REGISTER MESSAGE: ${e.message}');
      } else {
        debugPrint('REGISTER ERROR: $e');
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
      notifyListeners();

      final response = await apiService.verifyEmail(email, code);

      print('VERFIY RESPONSE: ${response.data}');
      print('STATUS CODE: ${response.statusCode}');

      return true;
    } catch (e) {
      if (e is DioException) {
        debugPrint('VERIFY STATUS: ${e.response?.statusCode}');
        debugPrint('VERIFY DATA: ${e.response?.data}');
        debugPrint('VERIFY MESSAGE: ${e.message}');
      } else {
        debugPrint('VERIFY ERROR: $e');
      }

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
