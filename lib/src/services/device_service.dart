import 'dart:io'; //should not be used for web

import 'package:agradiance_flutter_drive/src/utils/platform_constant.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

class DeviceService {
  DeviceService._internal({required DeviceInfoPlugin deviceInfoPlugin}) : _deviceInfoPlugin = deviceInfoPlugin;
  static final DeviceService _instance = DeviceService._internal(deviceInfoPlugin: DeviceInfoPlugin());
  //
  static final DeviceService instance = DeviceService();

  factory DeviceService() {
    return _instance;
  }

  final DeviceInfoPlugin _deviceInfoPlugin;

  String? _deviceId;
  String? _deviceModel;

  Future<AndroidDeviceInfo> get androidInfo => _deviceInfoPlugin.androidInfo;

  /// Call this method once during app startup (e.g., in main())
  Future<String?> get deviceId async {
    if (_deviceId != null) {
      return _deviceId;
    }
    if (kIsWeb || kIsWasm) {
      _deviceId = (await _deviceInfoPlugin.webBrowserInfo).userAgent;
    } else if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await _deviceInfoPlugin.androidInfo;
      _deviceId = androidInfo.id;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await _deviceInfoPlugin.iosInfo;
      _deviceId = iosInfo.identifierForVendor;
    } else if (Platform.isWindows) {
      WindowsDeviceInfo windowsInfo = await _deviceInfoPlugin.windowsInfo;
      _deviceId = windowsInfo.deviceId;
    } else if (Platform.isLinux) {
      LinuxDeviceInfo linuxInfo = await _deviceInfoPlugin.linuxInfo;
      _deviceId = linuxInfo.machineId;
    } else if (Platform.isMacOS) {
      MacOsDeviceInfo macInfo = await _deviceInfoPlugin.macOsInfo;
      _deviceId = macInfo.systemGUID;
    } else {
      _deviceId = null;
    }

    return _deviceId;
  }

  Future<String?> get deviceModel async {
    if (_deviceModel != null) {
      return _deviceModel;
    }

    if (kIsWeb || kIsWasm) {
      _deviceId = (await _deviceInfoPlugin.webBrowserInfo).userAgent;
    } else if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await _deviceInfoPlugin.androidInfo;
      _deviceModel = androidInfo.device;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await _deviceInfoPlugin.iosInfo;
      _deviceModel = iosInfo.modelName;
    } else if (Platform.isWindows) {
      WindowsDeviceInfo windowsInfo = await _deviceInfoPlugin.windowsInfo;
      _deviceModel = windowsInfo.computerName;
    } else if (Platform.isLinux) {
      LinuxDeviceInfo linuxInfo = await _deviceInfoPlugin.linuxInfo;
      _deviceModel = linuxInfo.variant;
    } else if (Platform.isMacOS) {
      MacOsDeviceInfo macInfo = await _deviceInfoPlugin.macOsInfo;
      _deviceModel = macInfo.modelName;
    } else {
      _deviceModel = null;
    }

    return _deviceModel;
  }

  String get platform {
    return PlatformUtils.platformName;
  }
}
