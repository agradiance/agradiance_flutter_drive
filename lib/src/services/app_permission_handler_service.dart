import 'package:permission_handler/permission_handler.dart';

class AppPermissionHandlerService {
  // Private constructor
  AppPermissionHandlerService._privateConstructor();

  // Singleton instance
  static final AppPermissionHandlerService _instance = AppPermissionHandlerService._privateConstructor();

  factory AppPermissionHandlerService() => _instance;

  /// Request a specific permission
  Future<bool> requestPermission(Permission permission) async {
    final status = await permission.request();
    return status.isGranted;
  }

  /// Check permission status
  Future<bool> isPermissionGranted(Permission permission) async {
    return await permission.status.isGranted;
  }

  /// Request multiple permissions
  Future<Map<Permission, PermissionStatus>> requestMultiple(List<Permission> permissions) async {
    return await permissions.request();
  }

  /// Open App Settings
  Future<void> openSettings() async {
    await openAppSettings();
  }
}
