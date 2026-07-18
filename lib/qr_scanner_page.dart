import 'package:flutter/services.dart';

class CameraService {
  static const MethodChannel _channel =
      MethodChannel('fixit/camera');

  static Future<bool> openCamera() async {
    try {
      final result =
          await _channel.invokeMethod<bool>(
        'openCamera',
      );

      return result ?? false;
    } on PlatformException catch (e) {
      print(
        'OPEN CAMERA PLATFORM ERROR: ${e.message}',
      );

      return false;
    } catch (e) {
      print(
        'OPEN CAMERA UNKNOWN ERROR: $e',
      );

      return false;
    }
  }
}