// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:agradiance_flutter_drive/src/logs/debub_print.dart';
import 'package:agradiance_flutter_drive/src/notifications/app_toastification.dart';
import 'package:agradiance_flutter_drive/src/services/device_service.dart';
import 'package:agradiance_flutter_drive/src/services/local_notification_service.dart';
import 'package:agradiance_flutter_drive/src/utils/num_utils.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FCMService {
  factory FCMService() {
    return _instance;
  }

  FCMService._internal({required FirebaseMessaging messaging}) : _messaging = messaging;

  static final FCMService _instance = FCMService._internal(messaging: FirebaseMessaging.instance);

  DeviceService get _deviceService => DeviceService();
  final FirebaseMessaging _messaging;

  static void initOnMessage() {
    // FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    _firebaseMessagingForegroundHandler();
  }

  void setupFirebaseMessagingListeners() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      LocalNotificationService.instance.handleNotificationRouting(payload: jsonEncode(message.data));
    });

    checkForInitialMessage();
  }

  Future<void> checkForInitialMessage() async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      LocalNotificationService.instance.handleNotificationRouting(payload: jsonEncode(initialMessage.data));
    }
  }

  Future<void> remoteMessageHandler({required RemoteMessage message}) async {
    dprint('Got a message whilst in the foreground!');
    dprint('Message data: ${message.data}');

    final notification = message.notification;

    if (notification != null) {
      AppToastification.success(
        message: notification.body ?? "",
        title: notification.title,
        autoCloseDuration: Duration(seconds: 5),
      );

      final payload = message.data;

      final notificationId = NumUtils.parseOrNullValue(payload["notificationId"])!.toInt();

      LocalNotificationService.instance.showNotification(
        id: notificationId, // Unique ID for the notification
        title: notification.title ?? "",
        body: notification.body ?? "",
        payload: jsonEncode(payload), // Optional: data to pass when tapped
      );
      // dprint('Message Title: ${message.notification?.title}');
      // dprint('Message Body: ${message.notification?.body}');
      // dprint('Message messageId: ${message.messageId}');
      // dprint('Message messageId: ${notification.android?.channelId}');
      // dprint('Message data: ${message.data}');
      // dprint('Message data: ${message.senderId}');
    }
  }

  Future<void> onDoneMessagingForeground() async {
    dprint('Done!!!');
  }

  void onErrorMessagingForeground(Object value) {
    dprint('Error!');
  }

  Future<AuthorizationStatusType> requestPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    return AuthorizationStatusType(settings.authorizationStatus.name);
  }

  Future<String?> get fcmToken async {
    final per = await requestPermission();

    if ([
      AuthorizationStatusType.authorized,
      AuthorizationStatusType.provisional,
      AuthorizationStatusType.notDetermined,
    ].contains(per)) {
      return _messaging.getToken();
    }
    return null;
  }

  Future<FCMDeviceModel?> getFCMDeviceModel({required String userId}) async {
    dprint(await _deviceService.deviceModel);
    final deviceId = await _deviceService.deviceId;
    final deviceModel = await _deviceService.deviceModel;
    final platform = _deviceService.platform;
    final token = await fcmToken;

    if (deviceId != null && token != null && deviceModel != null) {
      return FCMDeviceModel(
        userId: userId,
        deviceId: deviceId,
        deviceModel: deviceModel,
        platform: platform,
        fcmToken: token,
      );
    }
    return null;
  }

  static Future<void> _firebaseMessagingForegroundHandler() async {
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        FCMService().remoteMessageHandler(message: message);
      },
      onDone: () {
        FCMService().onDoneMessagingForeground();
      },
      onError: (value) {
        FCMService().onErrorMessagingForeground(value);
      },
    );
  }
}

void ddd() {
  FirebaseMessaging.instance.onTokenRefresh
      .listen((fcmToken) {
        // Note: This callback is fired at each app startup and whenever a new
        // token is generated.
      })
      .onError((err) {
        // Error getting token.
      });
}

enum AuthorizationStatusType {
  authorized._internal(key: "authorized", text: "Authorized"),
  denied._internal(key: "denied", text: "Denied"),
  notDetermined._internal(key: "notDetermined", text: "Not Determined"),
  provisional._internal(key: "provisional", text: "Provisional");

  const AuthorizationStatusType._internal({required this.key, required this.text});
  factory AuthorizationStatusType(String key) {
    return AuthorizationStatusType.values.firstWhereOrNull((element) => element.key == key.toLowerCase()) ??
        AuthorizationStatusType.notDetermined;
  }

  final String key;
  final String text;
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final notification = message.notification;
  final payload = message.data;

  if (notification != null) {
    final notificationId = NumUtils.parseOrNullValue(payload["notificationId"])!.toInt();

    LocalNotificationService.instance.showNotification(
      id: notificationId, // Unique ID for the notification
      title: notification.title ?? "",
      body: notification.body ?? "",
      payload: jsonEncode(payload), // Optional: data to pass when tapped
    );
  }

  dprint("Handling a background message: ${message.messageId}");
}

class FCMDeviceModel extends Equatable {
  const FCMDeviceModel({
    required this.userId,
    required this.platform,
    required this.deviceModel,
    required this.deviceId,
    required this.fcmToken,
  });

  factory FCMDeviceModel.fromJson(String source) => FCMDeviceModel.fromMap(json.decode(source) as Map<String, dynamic>);

  factory FCMDeviceModel.fromMap(Map<String, dynamic> map) {
    return FCMDeviceModel(
      userId: map['userId'] as String,
      platform: map['platform'] as String,
      deviceModel: map['deviceModel'] as String,
      deviceId: map['deviceId'] as String,
      fcmToken: map['fcmToken'] as String,
    );
  }

  final String deviceId;
  final String deviceModel;
  final String fcmToken;
  final String platform;
  final String userId;

  @override
  List<Object> get props {
    return [userId, platform, deviceModel, deviceId, fcmToken];
  }

  @override
  bool get stringify => true;

  FCMDeviceModel copyWith({String? userId, String? platform, String? deviceModel, String? deviceId, String? fcmToken}) {
    return FCMDeviceModel(
      userId: userId ?? this.userId,
      platform: platform ?? this.platform,
      deviceModel: deviceModel ?? this.deviceModel,
      deviceId: deviceId ?? this.deviceId,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'platform': platform,
      'deviceModel': deviceModel,
      'deviceId': deviceId,
      'fcmToken': fcmToken,
    };
  }

  String toJson() => json.encode(toMap());
}
