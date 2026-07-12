import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fix_it/models/provider_profile_model.dart';
import 'package:fix_it/services/api_services.dart';

class ProviderProfileProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();

  ProviderProfileModel? profile;

  bool isLoading = false;
  String? errorMessage;

  Future<bool> checkProviderProfile() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      profile = await apiService.getMyProviderProfile();

      return true;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        profile = null;
        return false;
      }

      errorMessage = 'فشل التحقق من ملف مقدم الخدمة';
      debugPrint('PROVIDER PROFILE ERROR: ${e.response?.data}');
      return false;
    } catch (e) {
      errorMessage = 'حدث خطأ غير متوقع';
      debugPrint('PROVIDER PROFILE ERROR: $e');
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


  bool isCreatingProfile = false;
String? createProfileError;

Future<bool> createProviderProfile({
  required int specializationId,
  String? bio,
}) async {
  try {
    isCreatingProfile = true;
    createProfileError = null;
    notifyListeners();

    await apiService.createProviderProfile(
      specializationId: specializationId,
      bio: bio,
    );

    profile = await apiService.getMyProviderProfile();

    return true;
  } catch (e) {
    createProfileError = 'فشل إنشاء ملف مقدم الخدمة';
    debugPrint('CREATE PROVIDER PROFILE ERROR: $e');

    return false;
  } finally {
    isCreatingProfile = false;
    notifyListeners();
  }
}
}