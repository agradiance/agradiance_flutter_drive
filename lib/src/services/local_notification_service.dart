import 'dart:async';
import 'dart:io'; // Required for Platform check

import 'package:collection/collection.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Define the background handler function at the top level or as a static method
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // Handle notification tap events while the app is in the background.
  // Keep this logic minimal. Maybe store the payload for processing when app opens.
  //dprint(
  //   'Notification(background) tapped: payload = ${notificationResponse.payload}',
  // );
  // IMPORTANT: Don't perform long-running tasks or UI navigation here.
}

class LocalNotificationService {
  // Singleton pattern setup
  LocalNotificationService._internal();
  static final LocalNotificationService _instance = LocalNotificationService._internal();
  static LocalNotificationService get instance => _instance;

  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  // Use a StreamController for payload handling (optional but recommended)
  // Using broadcast allows multiple listeners. Use BehaviorSubject from rxdart for last emitted value.
  final StreamController<String?> _payloadStreamController = StreamController<String?>.broadcast();
  Stream<String?> get payloadStream => _payloadStreamController.stream;

  Future<void> init() async {
    // Ensure Flutter bindings are initialized (important if calling init before runApp)
    // WidgetsFlutterBinding.ensureInitialized(); // Usually done in main.dart

    // --- Android Initialization Settings ---
    // Replace 'app_icon' with the actual name of your drawable icon file (without extension)
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');

    // --- iOS/macOS Initialization Settings ---
    final DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings(
      requestAlertPermission: false, // Request permissions separately
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    // --- Combined Initialization Settings ---
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
    );

    // --- Initialize Plugin ---
    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse, // Foreground tap handler
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground, // Background tap handler
    );

    //dprint("Notification Service Initialized");

    // Optional: Request permissions right after initialization
    // await requestPermissions();
  }

  // --- Permission Handling ---
  Future<void> requestPermissions() async {
    bool? permissionsGranted;
    (permissionsGranted);
    if (Platform.isIOS || Platform.isMacOS) {
      permissionsGranted = await _notificationsPlugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation = _notificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      // Request permission (needed for Android 13+)
      permissionsGranted = await androidImplementation?.requestNotificationsPermission();
    }
    //dprint("Notification Permissions Requested. Granted: $permissionsGranted");
  }

  // --- Callback Handlers (called by the plugin) ---

  // Callback for when a notification is tapped (foreground)
  void _onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    //dprint('Notification(foreground) tapped: payload = $payload');
    if (payload != null && payload.isNotEmpty) {
      _payloadStreamController.add(payload); // Add payload to stream
    }
    // You can add navigation logic here based on the payload
    // Example: if (payload == 'navigate_to_screen_x') { Get.to(...); }
  }

  // --- Showing Notifications ---
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload, // Optional payload for tap handling
  }) async {
    // --- Define Android Notification Details ---
    // Ensure you have a channel ID, name, and description.
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'high_importance_channel', // Channel ID
      'High Importance Notifications', // Channel Name
      channelDescription: 'This channel is used for important notifications.', // Channel Description
      importance: Importance.max, // High importance for heads-up notification
      priority: Priority.high,
      ticker: 'ticker', // Ticker text shown in status bar
      // icon: 'app_icon', // Optional: specific icon for this notification
      // sound: RawResourceAndroidNotificationSound('notification_sound'), // Optional: custom sound
      // largeIcon: DrawableResourceAndroidBitmap('large_icon') // Optional: large icon
    );

    // --- Define iOS/macOS Notification Details ---
    const DarwinNotificationDetails darwinDetails = DarwinNotificationDetails(
      // presentAlert: true, // Ensure alert is shown in foreground (check plugin docs for default)
      // presentBadge: true,
      // presentSound: true,
      // sound: 'custom_sound.wav', // Optional: custom sound for iOS/macOS
      // badgeNumber: 1, // Optional: Set badge number
    );

    // --- Combined Notification Details ---
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
      macOS: darwinDetails,
    );

    // --- Show Notification ---
    try {
      //dprint("Showing notification id: $id");
      await _notificationsPlugin.show(id, title, body, notificationDetails, payload: payload);
    } catch (e) {
      //dprint("Error showing notification: $e");
    }
  }

  // --- Other Helper Methods (Optional) ---

  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  // Clean up stream controller (call this if your service can be disposed)
  void dispose() {
    _payloadStreamController.close();
  }

  void handleNotificationRouting({String? payload}) {
    //dprint(payload);
    if (payload != null) {
      // final map = (jsonDecode(payload) as Map<String, dynamic>);
      // final routeName = map["routeName"] ?? AppPages.home.name;

      // if (routeName == AppPages.vendorOrderDetail.name) {
      //   final orderId = map["orderId"];
      //   GetIt.I.get<AppRouterBloc>().router.goNamed(AppPages.vendorOrderDetail.name, extra: {"orderId": orderId});
      // } else {
      //   GetIt.I.get<AppRouterBloc>().router.goNamed(routeName);
      // }
    }
  }
}

enum LocalNotificationPayloadCodes {
  info._internal(code: "001001"),
  order._internal(code: "001002");

  const LocalNotificationPayloadCodes._internal({required this.code});
  factory LocalNotificationPayloadCodes({required String code}) {
    return LocalNotificationPayloadCodes.values.firstWhereOrNull((element) => element.code == code) ?? info;
  }
  final String code;
}
