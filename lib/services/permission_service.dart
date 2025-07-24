import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<bool> requestPhonePermission() async {
    final status = await Permission.phone.request();
    return status.isGranted;
  }

  static Future<bool> requestLocationPermission() async {
    final status = await Permission.locationWhenInUse.request();
    return status.isGranted;
  }

  static Future<void> openAppSettingsIfPermanentlyDenied(
      Permission permission) async {
    if (await permission.isPermanentlyDenied) {
      await openAppSettings();
    }
  }
}