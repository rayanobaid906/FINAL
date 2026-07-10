import 'package:flutter/material.dart';
// import 'hoe/services/api_service.dart';
import 'package:fix_it/services/api_services.dart';

class AuthProvider extends ChangeNotifier {

  final ApiService apiService = ApiService();

  bool isLoading = false;
Future<bool> login(String email, String password) async {

  try {

    isLoading = true;
    notifyListeners();

    final response = await apiService.login(email, password);

    print(response.data);

    return true;

  } catch (e) {

    print("LOGIN ERROR: $e");

    return false;

  } finally {

    isLoading = false;
    notifyListeners();
  }
}


//___________________________________________


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

    print("REGISTER ERROR:");
print(e.toString());

    return false;

  } finally {

    isLoading = false;
    notifyListeners();
  }
}
 Future<bool> verifyEmail(
  String email,
  String code,
) async {

  try {

    isLoading = true;
    notifyListeners();

    final response = await apiService.verifyEmail(
      email,
      code,
    );

   print('LOGIN RESPONSE: ${response.data}');
print('STATUS CODE: ${response.statusCode}');
    

    return true;

  } catch (e) {

    print("VERIFY ERROR: $e");

    return false;

  } finally {

    isLoading = false;
    notifyListeners();
  }
}
}
