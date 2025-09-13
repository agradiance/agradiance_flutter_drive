import 'package:permission_handler/permission_handler.dart';

class AppPermissionService {
  // Private constructor
  AppPermissionService._internal();

  // Singleton instance
  static final AppPermissionService _instance = AppPermissionService._internal();

  factory AppPermissionService() => _instance;
  static AppPermissionService get instance => AppPermissionService();

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

  Future<Map<Permission, PermissionStatus>> requestMultipleAndSettiings(List<Permission> permissions) async {
    Map<Permission, PermissionStatus> statuses = await requestMultiple(permissions);

    for (final permissionMap in statuses.entries) {
      final permission = permissionMap.key;
      if (statuses[permission]?.isPermanentlyDenied ?? false) {
        await openAppSettings().then((value) async {
          if (value) {
            if (statuses[permission]?.isPermanentlyDenied == true && statuses[permission]?.isGranted == false) {
              // openAppSettings();
              requestPermissionService(permission); /* opens app settings until permission is granted */
            }
          }
        });
      } else {
        if (statuses[Permission.storage]?.isDenied ?? false) {
          requestPermissionService(permission);
        }
      }
    }

    return await requestMultiple(permissions);
  }

  Future<void> requestPermissionService(Permission permission) async {
    await requestPermission(permission);
  }

  /// Open App Settings
  Future<bool> openSettings() async {
    return await openAppSettings();
  }
}
