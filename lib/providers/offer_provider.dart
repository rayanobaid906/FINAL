import 'package:flutter/material.dart';
import 'package:fix_it/models/offer_model.dart';
import 'package:fix_it/services/api_services.dart';
import 'package:dio/dio.dart';

class OfferProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();

  OfferModel? createdOffer;

  bool isCreatingOffer = false;
  String? createOfferError;

  Future<bool> createOffer({
    required int orderId,
    required double inspectionPrice,
    String? note,
    required double providerLatitude,
    required double providerLongitude,
  }) async {
    try {
      isCreatingOffer = true;
      createOfferError = null;
      notifyListeners();

      createdOffer = await apiService.createOffer(
        orderId: orderId,
        inspectionPrice: inspectionPrice,
        note: note,
        providerLatitude: providerLatitude,
        providerLongitude: providerLongitude,
      );

      return true;
    } on DioException catch (e) {
      debugPrint('CREATE OFFER STATUS: ${e.response?.statusCode}');
      debugPrint('CREATE OFFER DATA: ${e.response?.data}');
      debugPrint('CREATE OFFER MESSAGE: ${e.message}');

      final message = e.response?.data?.toString() ?? '';

      if (message.contains('active subscription')) {
        createOfferError = 'تحتاج إلى اشتراك فعال لتقديم عرض';
      } else if (message.contains('your own order')) {
        createOfferError = 'لا يمكنك تقديم عرض على طلبك الشخصي';
      } else if (message.isNotEmpty) {
        createOfferError = message;
      } else {
        createOfferError = 'فشل إرسال العرض';
      }

      return false;
    } catch (e) {
      debugPrint('CREATE OFFER UNKNOWN ERROR: $e');
      createOfferError = 'حدث خطأ غير متوقع';
      return false;
    } finally {
      isCreatingOffer = false;
      notifyListeners();
    }
  }

  List<OfferModel> myOffers = [];

  bool isLoadingMyOffers = false;

  String? myOffersError;

  Future<void> getMyOffers() async {
    try {
      isLoadingMyOffers = true;
      myOffersError = null;
      notifyListeners();

      myOffers = await apiService.getMyOffers();

      debugPrint('MY OFFERS COUNT: ${myOffers.length}');
    } on DioException catch (e) {
      debugPrint('MY OFFERS STATUS: ${e.response?.statusCode}');
      debugPrint('MY OFFERS DATA: ${e.response?.data}');
      debugPrint('MY OFFERS MESSAGE: ${e.message}');

      final message = e.response?.data?.toString() ?? '';

      myOffersError = message.isNotEmpty ? message : 'فشل تحميل العروض';
    } catch (e) {
      debugPrint('MY OFFERS UNKNOWN ERROR: $e');

      myOffersError = 'حدث خطأ غير متوقع';
    } finally {
      isLoadingMyOffers = false;
      notifyListeners();
    }
  }

  List<OfferModel> orderOffers = [];

  bool isLoadingOrderOffers = false;

  String? orderOffersError;

  Future<void> getOrderOffers(int orderId) async {
    try {
      isLoadingOrderOffers = true;
      orderOffersError = null;
      notifyListeners();

      orderOffers = await apiService.getOrderOffers(orderId);

      debugPrint('ORDER OFFERS COUNT: ${orderOffers.length}');
    } on DioException catch (e) {
      debugPrint('ORDER OFFERS STATUS: ${e.response?.statusCode}');
      debugPrint('ORDER OFFERS DATA: ${e.response?.data}');
      debugPrint('ORDER OFFERS MESSAGE: ${e.message}');

      final message = e.response?.data?.toString() ?? '';

      orderOffersError = message.isNotEmpty ? message : 'فشل تحميل عروض الطلب';
    } catch (e) {
      debugPrint('ORDER OFFERS UNKNOWN ERROR: $e');

      orderOffersError = 'حدث خطأ غير متوقع';
    } finally {
      isLoadingOrderOffers = false;
      notifyListeners();
    }
  }

  OfferModel? acceptedOffer;
  Future<bool> acceptInspectionOffer(int offerId) async {
    try {
      isCreatingOffer = true;
      createOfferError = null;
      notifyListeners();

      acceptedOffer = await apiService.acceptInspectionOffer(offerId);

      return true;
    } on DioException catch (e) {
      debugPrint('ACCEPT OFFER STATUS: ${e.response?.statusCode}');
      debugPrint('ACCEPT OFFER DATA: ${e.response?.data}');
      debugPrint('ACCEPT OFFER MESSAGE: ${e.message}');

      final message = e.response?.data?.toString() ?? '';

      createOfferError = message.isNotEmpty ? message : 'فشل قبول العرض';
      return false;
    } catch (e) {
      debugPrint('ACCEPT OFFER UNKNOWN ERROR: $e');

      createOfferError = 'حدث خطأ غير متوقع';
      return false;
    } finally {
      isCreatingOffer = false;
      notifyListeners();
    }
  }

  OfferModel? continuedOffer;

  bool isContinuingWork = false;
  String? continueWorkError;

  Future<bool> continueWorkOffer(int offerId) async {
    try {
      isContinuingWork = true;
      continueWorkError = null;
      notifyListeners();

      continuedOffer = await apiService.continueWorkOffer(offerId);

      return true;
    } on DioException catch (e) {
      debugPrint('CONTINUE WORK STATUS: ${e.response?.statusCode}');
      debugPrint('CONTINUE WORK DATA: ${e.response?.data}');
      debugPrint('CONTINUE WORK MESSAGE: ${e.message}');

      final message = e.response?.data?.toString() ?? '';

      continueWorkError = message.isNotEmpty ? message : 'فشل بدء العمل';

      return false;
    } catch (e) {
      debugPrint('CONTINUE WORK UNKNOWN ERROR: $e');

      continueWorkError = 'حدث خطأ غير متوقع';
      return false;
    } finally {
      isContinuingWork = false;
      notifyListeners();
    }
  }

  OfferModel? rejectedAfterInspectionOffer;

  bool isRejectingAfterInspection = false;

  String? rejectAfterInspectionError;
  Future<bool> rejectAfterInspectionOffer(int offerId) async {
    try {
      isRejectingAfterInspection = true;
      rejectAfterInspectionError = null;
      notifyListeners();

      rejectedAfterInspectionOffer = await apiService
          .rejectAfterInspectionOffer(offerId);

      return true;
    } on DioException catch (e) {
      debugPrint('REJECT AFTER INSPECTION STATUS: ${e.response?.statusCode}');
      debugPrint('REJECT AFTER INSPECTION DATA: ${e.response?.data}');
      debugPrint('REJECT AFTER INSPECTION MESSAGE: ${e.message}');

      final message = e.response?.data?.toString() ?? '';

      rejectAfterInspectionError = message.isNotEmpty
          ? message
          : 'فشل رفض العرض بعد المعاينة';

      return false;
    } catch (e) {
      debugPrint('REJECT AFTER INSPECTION UNKNOWN ERROR: $e');

      rejectAfterInspectionError = 'حدث خطأ غير متوقع';

      return false;
    } finally {
      isRejectingAfterInspection = false;
      notifyListeners();
    }
  }

  OfferModel? updatedOffer;

  bool isUpdatingOffer = false;

  String? updateOfferError;

  Future<bool> updateOffer({
    required int offerId,
    required double inspectionPrice,
    String? note,
    required double providerLatitude,
    required double providerLongitude,
  }) async {
    try {
      isUpdatingOffer = true;
      updateOfferError = null;
      notifyListeners();

      updatedOffer = await apiService.updateOffer(
        offerId: offerId,
        inspectionPrice: inspectionPrice,
        note: note,
        providerLatitude: providerLatitude,
        providerLongitude: providerLongitude,
      );

      return true;
    } on DioException catch (e) {
      debugPrint('UPDATE OFFER STATUS: ${e.response?.statusCode}');
      debugPrint('UPDATE OFFER DATA: ${e.response?.data}');
      debugPrint('UPDATE OFFER MESSAGE: ${e.message}');

      final message = e.response?.data?.toString() ?? '';

      updateOfferError = message.isNotEmpty ? message : 'فشل تعديل العرض';

      return false;
    } catch (e) {
      debugPrint('UPDATE OFFER UNKNOWN ERROR: $e');

      updateOfferError = 'حدث خطأ غير متوقع';

      return false;
    } finally {
      isUpdatingOffer = false;
      notifyListeners();
    }
  }

  bool isCancellingOffer = false;

  String? cancelOfferError;
  Future<bool> cancelOffer(int offerId) async {
    try {
      isCancellingOffer = true;
      cancelOfferError = null;
      notifyListeners();

      await apiService.cancelOffer(offerId);

      return true;
    } on DioException catch (e) {
      debugPrint('CANCEL OFFER STATUS: ${e.response?.statusCode}');
      debugPrint('CANCEL OFFER DATA: ${e.response?.data}');
      debugPrint('CANCEL OFFER MESSAGE: ${e.message}');

      final message = e.response?.data?.toString() ?? '';

      cancelOfferError = message.isNotEmpty ? message : 'فشل إلغاء العرض';

      return false;
    } catch (e) {
      debugPrint('CANCEL OFFER UNKNOWN ERROR: $e');

      cancelOfferError = 'حدث خطأ غير متوقع';

      return false;
    } finally {
      isCancellingOffer = false;
      notifyListeners();
    }
  }

  bool isRejectingOffer = false;

  String? rejectOfferError;

  Future<bool> rejectOffer(int offerId) async {
    try {
      isRejectingOffer = true;
      rejectOfferError = null;
      notifyListeners();

      await apiService.rejectOffer(offerId);

      return true;
    } on DioException catch (e) {
      debugPrint('REJECT OFFER STATUS: ${e.response?.statusCode}');
      debugPrint('REJECT OFFER DATA: ${e.response?.data}');
      debugPrint('REJECT OFFER MESSAGE: ${e.message}');

      final message = e.response?.data?.toString() ?? '';

      rejectOfferError = message.isNotEmpty ? message : 'فشل رفض العرض';

      return false;
    } catch (e) {
      debugPrint('REJECT OFFER UNKNOWN ERROR: $e');

      rejectOfferError = 'حدث خطأ غير متوقع';

      return false;
    } finally {
      isRejectingOffer = false;
      notifyListeners();
    }
  }
}
