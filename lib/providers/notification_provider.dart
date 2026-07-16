import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:fix_it/models/notification_model.dart';
import 'package:fix_it/services/api_services.dart';

class NotificationProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();

  List<NotificationModel> notifications = [];
      //*____________________________*//
      //*to get all the notification*//
  bool isLoadingNotifications = false;
  String? notificationsError;

  Future<void> getNotifications() async {
    try {
      isLoadingNotifications = true;
      notificationsError = null;
      notifyListeners();

      notifications = await apiService.getNotifications();

      //debugPrint('NOTIFICATIONS COUNT: ${notifications.length}');
    } on DioException catch (e) {
      debugPrint('NOTIFICATIONS STATUS: ${e.response?.statusCode}');
      debugPrint('NOTIFICATIONS DATA: ${e.response?.data}');
      debugPrint('NOTIFICATIONS MESSAGE: ${e.message}');

      final message = e.response?.data?.toString() ?? '';

      notificationsError = message.isNotEmpty ? message : 'فشل تحميل الإشعارات';
    } catch (e) {
      debugPrint('NOTIFICATIONS UNKNOWN ERROR: $e');

      notificationsError = 'حدث خطأ غير متوقع';
    } finally {
      isLoadingNotifications = false;
      notifyListeners();
    }
  }

  int get unreadCount {
    return notifications.where((notification) => !notification.isRead).length;
  }
      //*____________________________*//
      //*this is for make notification read *//
  bool isMarkingAllAsRead = false;
  String? markAllAsReadError;

  Future<bool> markAllNotificationsAsRead() async {
    try {
      isMarkingAllAsRead = true;
      markAllAsReadError = null;
      notifyListeners();

      await apiService.markAllNotificationsAsRead();

      await getNotifications();

      return true;
    } on DioException catch (e) {
      debugPrint('READ ALL STATUS: ${e.response?.statusCode}');
      debugPrint('READ ALL DATA: ${e.response?.data}');
      debugPrint('READ ALL MESSAGE: ${e.message}');

      final message = e.response?.data?.toString() ?? '';

      markAllAsReadError = message.isNotEmpty
          ? message
          : 'فشل تعليم الإشعارات كمقروءة';

      return false;
    } catch (e) {
      debugPrint('READ ALL UNKNOWN ERROR: $e');

      markAllAsReadError = 'حدث خطأ غير متوقع';

      return false;
    } finally {
      isMarkingAllAsRead = false;
      notifyListeners();
    }
  }
}
