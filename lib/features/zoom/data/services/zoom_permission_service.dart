import 'package:durbar_physics/core/logger/app_logger.dart';
import 'package:permission_handler/permission_handler.dart';

class ZoomPermissionService {
  // static void requestPermission() {
  //   try {
  //     [Permission.camera, Permission.microphone].request();
  //   } catch (_) {}
  // }

  static Future<void> requestPermission() async {
    try {
      final cameraStatus = await Permission.camera.status;
      final micStatus = await Permission.microphone.status;

      if (cameraStatus.isGranted && micStatus.isGranted) {
        logger.f('Permission already granted');
      }

      await [Permission.camera, Permission.microphone].request();
    } catch (_) {}
  }
}
