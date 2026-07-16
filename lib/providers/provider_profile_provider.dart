import 'package:dio/dio.dart';
import 'package:fix_it/models/rating_summary_model.dart';
import 'package:flutter/material.dart';
import 'package:fix_it/models/provider_profile_model.dart';
import 'package:fix_it/services/api_services.dart';
import 'package:fix_it/models/subscription_status_model.dart';

class ProviderProfileProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();
  bool hasProviderProfile = false;
  ProviderProfileModel?
  profile; //*to save my profile this is helpfull to method 2
  bool isLoading = false;
  String? errorMessage;

  void reset() {
    hasProviderProfile = false;
    profile = null;
    isLoading = false;
    errorMessage = null;
    createProfileError = null;
    subscriptionStatus = null;
    ratingSummary = null;
    notifyListeners();
  }
  //*____________________________*//
  //*to get my provider profile *//
  Future<bool> checkProviderProfile() async {
    try {
      isLoading = true;

      errorMessage = null;
      notifyListeners();

      profile = await apiService.getMyProviderProfile();
      hasProviderProfile = true;
      return true;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        profile = null;
        hasProviderProfile = false;
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

  //*____________________________*//
  //*to get my provider profile*//
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
      hasProviderProfile = true;

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

  //*____________________________*//
  //*this is for update profile *//
  bool isUpdatingProfile = false;
  String? updateProfileError;

  Future<bool> updateProviderProfile({required String bio}) async {
    try {
      isUpdatingProfile = true;
      updateProfileError = null;
      notifyListeners();

      profile = await apiService.updateMyProviderProfile(bio: bio);

      return true;
    } catch (e) {
      updateProfileError = 'فشل تعديل ملف مقدم الخدمة';
      debugPrint('UPDATE PROVIDER PROFILE ERROR: $e');
      return false;
    } finally {
      isUpdatingProfile = false;
      notifyListeners();
    }
  } //*____________________________*//

  //*this is for get subscribtion status *//
  SubscriptionStatusModel? subscriptionStatus;

  bool isLoadingSubscriptionStatus = false;

  String? subscriptionStatusError;

  Future<void> getSubscriptionStatus() async {
    try {
      isLoadingSubscriptionStatus = true;
      subscriptionStatusError = null;
      notifyListeners();

      subscriptionStatus = await apiService.getSubscriptionStatus();

      debugPrint(
        'HAS ACTIVE SUBSCRIPTION: '
        '${subscriptionStatus?.hasActiveSubscription}',
      );
    } catch (e) {
      subscriptionStatusError = 'فشل تحميل حالة الاشتراك';

      debugPrint('SUBSCRIPTION STATUS ERROR: $e');
    } finally {
      isLoadingSubscriptionStatus = false;
      notifyListeners();
    }
  }

  //*____________________________*//
  //* this is for get summary of reating *//
  RatingSummaryModel? ratingSummary;

  bool isLoadingRatingSummary = false;

  String? ratingSummaryError;

  Future<void> getRatingSummary(int providerProfileId) async {
    try {
      isLoadingRatingSummary = true;
      ratingSummaryError = null;
      notifyListeners();

      ratingSummary = await apiService.getProviderRatingSummary(
        providerProfileId,
      );
    } on DioException catch (e) {
      debugPrint('RATING SUMMARY STATUS: ${e.response?.statusCode}');

      debugPrint('RATING SUMMARY DATA: ${e.response?.data}');

      debugPrint('RATING SUMMARY MESSAGE: ${e.message}');

      final message = e.response?.data?.toString() ?? '';

      ratingSummaryError = message.isNotEmpty
          ? message
          : 'فشل تحميل ملخص التقييم';
    } catch (e) {
      debugPrint('RATING SUMMARY UNKNOWN ERROR: $e');

      ratingSummaryError = 'حدث خطأ غير متوقع';
    } finally {
      isLoadingRatingSummary = false;
      notifyListeners();
    }
  }
}
