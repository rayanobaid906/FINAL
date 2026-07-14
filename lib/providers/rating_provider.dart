import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fix_it/services/api_services.dart';

class RatingProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();

  bool isSubmittingRating = false;
  String? ratingError;

  Future<bool> createRating({
    required int orderId,
    required int value,
  }) async {
    try {
      isSubmittingRating = true;
      ratingError = null;
      notifyListeners();

      await apiService.createRating(
        orderId: orderId,
        value: value,
      );

      return true;
    } on DioException catch (e) {
      debugPrint(
        'CREATE RATING STATUS: ${e.response?.statusCode}',
      );
      debugPrint(
        'CREATE RATING DATA: ${e.response?.data}',
      );
      debugPrint(
        'CREATE RATING MESSAGE: ${e.message}',
      );

      final message = e.response?.data?.toString() ?? '';

      if (message.contains('Only completed orders can be rated')) {
        ratingError = 'لا يمكن تقييم الطلب قبل اكتماله';
      } else if (message.isNotEmpty) {
        ratingError = message;
      } else {
        ratingError = 'فشل إرسال التقييم';
      }

      return false;
    } catch (e) {
      debugPrint('CREATE RATING UNKNOWN ERROR: $e');

      ratingError = 'حدث خطأ غير متوقع';
      return false;
    } finally {
      isSubmittingRating = false;
      notifyListeners();
    }
  }
}