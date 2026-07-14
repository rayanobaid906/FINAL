import 'package:flutter/material.dart';
import 'package:fix_it/models/specialization_model.dart';
import 'package:fix_it/services/api_services.dart';
import 'package:dio/dio.dart';
import 'package:fix_it/models/order_model.dart';
import 'package:dio/dio.dart';

class OrderProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();
  //*_____________________________*//
  //*this is for specialization*//
  List<SpecializationModel> specializations = [];

  bool isLoadingSpecializations = false;

  String? errorMessage;
 
 

  Future<void> getSpecializations() async {
    try {
      //debugPrint('START GET SPECIALIZATIONS');

      isLoadingSpecializations = true;
      errorMessage = null;
      notifyListeners();

      specializations = await apiService.getSpecializations(); //*get the api and saved it into list 

     // debugPrint('SPECIALIZATIONS COUNT: ${specializations.length}');
    } catch (e) {
      //debugPrint('SPECIALIZATIONS ERROR: $e');
      errorMessage = 'فشل الاتصال بالخادم';
    } finally {
      isLoadingSpecializations = false; //*because the requst is end 
      notifyListeners(); //*to tell the ui the update is end 
    }
  }
        //*_____________________________*//
        //*this is for ceate order*//
         bool isCreatingOrder = false;
          String? createOrderError;
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
      //*_____________________________*//
      //*this is for getmy orders*//
  List<OrderModel> myOrders = [];

  bool isLoadingMyOrders = false;

  String? myOrdersError;

  Future<void> getMyOrders() async {
    try {
      isLoadingMyOrders = true;
      myOrdersError = null;
      notifyListeners();

      myOrders = await apiService.getMyOrders();

      //debugPrint('MY ORDERS COUNT: ${myOrders.length}');
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
       //*_____________________________*//
       //*this is for get order by id*//
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
        //*_____________________________*//
        //*this is for cancel order*//
  bool isCancellingOrder = false;
  String? cancelOrderError;

  Future<bool> cancelOrder(int orderId) async {
    try {
      isCancellingOrder = true;
      cancelOrderError = null;
      notifyListeners();

      await apiService.cancelOrder(orderId);

      await getMyOrders();  //*this is like refresh because we canceled the order 
      //*the orders must shown without this one 

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
         //*_____________________________*//
         //*this is for update order*//
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
      await getOrderById(orderId);  //*to update the current order *//

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
         //*_____________________________*//
         //*this is for available order for provider*//
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

           //*_____________________________*//
           //*this is for order assigned to providers*//
List<OrderModel> assignedProviderOrders = [];

bool isLoadingAssignedProviderOrders = false;

String? assignedProviderOrdersError;

Future<void> getAssignedProviderOrders() async { //*we make it void because we dont return it but 
//*stored into list refresh the ui 
  try {
    isLoadingAssignedProviderOrders = true;
    assignedProviderOrdersError = null;
    notifyListeners();

    assignedProviderOrders =
        await apiService.getAssignedProviderOrders();

    debugPrint(
      'ASSIGNED PROVIDER ORDERS COUNT: '
      '${assignedProviderOrders.length}',
    );
  } catch (e) {
    assignedProviderOrdersError =
        'فشل تحميل الطلبات المسندة';

    debugPrint(
      'ASSIGNED PROVIDER ORDERS ERROR: $e',
    );
  } finally {
    isLoadingAssignedProviderOrders = false;
    notifyListeners();
  }
}

}
