import 'package:flutter/material.dart';
import 'package:fix_it/models/specialization_model.dart';
import 'package:fix_it/services/api_services.dart';
import 'package:dio/dio.dart';
import 'package:fix_it/models/order_model.dart';
import 'package:dio/dio.dart';

class OrderProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();

  List<SpecializationModel> specializations = [];

  bool isLoadingSpecializations = false;

  String? errorMessage;
  bool isCreatingOrder = false;
  String? createOrderError;

  Future<void> getSpecializations() async {
    try {
      debugPrint('START GET SPECIALIZATIONS');

      isLoadingSpecializations = true;
      errorMessage = null;
      notifyListeners();

      specializations = await apiService.getSpecializations();

      debugPrint('SPECIALIZATIONS COUNT: ${specializations.length}');
    } catch (e) {
      debugPrint('SPECIALIZATIONS ERROR: $e');
      errorMessage = 'فشل الاتصال بالخادم';
    } finally {
      isLoadingSpecializations = false;
      notifyListeners();
    }
  }

  Future<bool> createOrder({
    required int specializationId,
    required String description,
    required double latitude,
    required double longitude,
    required String addressText,
  }) async {
    try {
      isCreatingOrder = true;
      createOrderError = null;
      notifyListeners();

      await apiService.createOrder(
        specializationId: specializationId,
        description: description,
        latitude: latitude,
        longitude: longitude,
        addressText: addressText,
      );

      return true;
    } catch (e) {
      if (e is DioException) {
        debugPrint('CREATE ORDER STATUS: ${e.response?.statusCode}');
        debugPrint('CREATE ORDER DATA: ${e.response?.data}');
        debugPrint('CREATE ORDER MESSAGE: ${e.message}');
      } else {
        debugPrint('CREATE ORDER ERROR: $e');
      }

      createOrderError = 'فشل إنشاء الطلب';
      return false;
    } finally {
      isCreatingOrder = false;
      notifyListeners();
    }
  }

  List<OrderModel> myOrders = [];

  bool isLoadingMyOrders = false;

  String? myOrdersError;

  Future<void> getMyOrders() async {
    try {
      isLoadingMyOrders = true;
      myOrdersError = null;
      notifyListeners();

      myOrders = await apiService.getMyOrders();

      debugPrint('MY ORDERS COUNT: ${myOrders.length}');
    } catch (e) {
      if (e is DioException) {
        debugPrint('MY ORDERS STATUS: ${e.response?.statusCode}');
        debugPrint('MY ORDERS DATA: ${e.response?.data}');
        debugPrint('MY ORDERS MESSAGE: ${e.message}');
      } else {
        debugPrint('MY ORDERS ERROR: $e');
      }

      myOrdersError = 'فشل تحميل الطلبات';
    } finally {
      isLoadingMyOrders = false;
      notifyListeners();
    }
  }

  OrderModel? selectedOrder;

  bool isLoadingOrderDetails = false;

  String? orderDetailsError;

  Future<void> getOrderById(int id) async {
    try {
      isLoadingOrderDetails = true;
      orderDetailsError = null;
      notifyListeners();

      selectedOrder = await apiService.getOrderById(id);

      debugPrint('ORDER DETAILS ID: ${selectedOrder?.id}');
    } catch (e) {
      orderDetailsError = 'فشل تحميل تفاصيل الطلب';
      debugPrint('ORDER DETAILS ERROR: $e');
    } finally {
      isLoadingOrderDetails = false;
      notifyListeners();
    }
  }

  bool isCancellingOrder = false;
  String? cancelOrderError;

  Future<bool> cancelOrder(int orderId) async {
    try {
      isCancellingOrder = true;
      cancelOrderError = null;
      notifyListeners();

      await apiService.cancelOrder(orderId);

      await getMyOrders();

      return true;
    } catch (e) {
      cancelOrderError = 'فشل إلغاء الطلب';
      debugPrint('CANCEL ORDER ERROR: $e');

      return false;
    } finally {
      isCancellingOrder = false;
      notifyListeners();
    }
  }

  bool isUpdatingOrder = false;
  String? updateOrderError;

  Future<bool> updateOrder({
    required int orderId,
    required int specializationId,
    required String description,
    required double latitude,
    required double longitude,
    required String addressText,
  }) async {
    try {
      isUpdatingOrder = true;
      updateOrderError = null;
      notifyListeners();

      await apiService.updateOrder(
        orderId: orderId,
        specializationId: specializationId,
        description: description,
        latitude: latitude,
        longitude: longitude,
        addressText: addressText,
      );

      await getMyOrders();
      await getOrderById(orderId);

      return true;
    } catch (e) {
      updateOrderError = 'فشل تعديل الطلب';
      debugPrint('UPDATE ORDER ERROR: $e');
      return false;
    } finally {
      isUpdatingOrder = false;
      notifyListeners();
    }
  }

  List<OrderModel> availableProviderOrders = [];

  bool isLoadingAvailableProviderOrders = false;

  String? availableProviderOrdersError;

  Future<void> getAvailableProviderOrders() async {
    try {
      isLoadingAvailableProviderOrders = true;
      availableProviderOrdersError = null;
      notifyListeners();

      availableProviderOrders = await apiService.getAvailableProviderOrders();

      debugPrint(
        'AVAILABLE PROVIDER ORDERS COUNT: '
        '${availableProviderOrders.length}',
      );
    } catch (e) {
      availableProviderOrdersError = 'فشل تحميل الطلبات المتاحة';

      debugPrint('AVAILABLE PROVIDER ORDERS ERROR: $e');
    } finally {
      isLoadingAvailableProviderOrders = false;
      notifyListeners();
    }
  }
}
