import 'package:permission_handler/permission_handler.dart';

class AppPermissionManager {
  // Singleton setup
  AppPermissionManager._internal();
  static final AppPermissionManager _instance = AppPermissionManager._internal();
  factory AppPermissionManager() => _instance;
  static AppPermissionManager get instance => AppPermissionManager();

  /*Permission services*/
  Future<Map<Permission, PermissionStatus>> _permissionServices() async {
    // You can request multiple permissions at once.
    Map<Permission, PermissionStatus> statuses = await [
      //add more permission to request here.
      Permission.storage,
    ].request();

    if (statuses[Permission.storage]?.isPermanentlyDenied ?? false) {
      await openAppSettings().then((value) async {
        if (value) {
          if (await Permission.storage.status.isPermanentlyDenied == true &&
              await Permission.storage.status.isGranted == false) {
            // openAppSettings();
            requestPermissionService(); /* opens app settings until permission is granted */
          }
        }
      });
    } else {
      if (statuses[Permission.storage]?.isDenied ?? false) {
        requestPermissionService();
      }
    }

    /*{Permission.camera: PermissionStatus.granted, Permission.storage: PermissionStatus.granted}*/
    return statuses;
  }

  Future<bool> get isStorageGranted {
    return Permission.storage.isGranted;
  }

  Future<void> requestPermissionService() async {
    await _permissionServices().then((value) {
      if (value.isNotEmpty) {
        if (value[Permission.storage]?.isGranted ?? false) {
          /* ========= New Screen Added  ============= */

          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(builder: (context) => SplashScreen()),
          // );
        }
      }
    });
  }

  // Request storage permission
  Future<void> requestStoragePermission() async {
    final status = await Permission.storage.status;

    if (status.isGranted) {
      //dprint('Storage permission already granted');
      return;
    }

    final result = await Permission.storage.request();

    if (result.isGranted) {
      //dprint('Storage permission granted');
    } else if (result.isDenied) {
      //dprint('Storage permission denied');
    } else if (result.isPermanentlyDenied) {
      //dprint('Storage permission permanently denied');
      await openAppSettings(); // Optional: prompt user to open app settings
    }
  }
}
