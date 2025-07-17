import 'dart:io'; //should not be used for web

import 'package:flutter/foundation.dart' show kIsWeb;

class PlatformUtils {
  static bool get isAndroid => Platform.isAndroid;
  static bool get isIOS => Platform.isIOS;
  static bool get isWeb => kIsWeb;
  static bool get isLinux => Platform.isLinux;
  static bool get isMacOS => Platform.isMacOS;
  static bool get isWindows => Platform.isWindows;
  static bool get isFuchsia => Platform.isFuchsia;

  static bool get isMobile => isAndroid || isIOS;
  static bool get isDesktop => isLinux || isMacOS || isWindows;

  static String get platformName {
    if (isWeb) {
      return "Web";
    } else if (isAndroid) {
      return "Android";
    } else if (isIOS) {
      return "IOS";
    } else if (isWindows) {
      return "Windows";
    } else if (isMacOS) {
      return "MacOS";
    } else if (isLinux) {
      return "Linux";
    } else if (isFuchsia) {
      return "Fuchsia";
    } else {
      return "Unknown";
    }
  }
}
