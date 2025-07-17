import 'package:flutter/material.dart' show MediaQueryData, MediaQuery, BuildContext, Size;
import 'platform_constant.dart';

class ScreenUtils {
  static MediaQueryData mediaQueryData(BuildContext context) {
    return MediaQuery.of(context);
  }

  static Size screenSize(BuildContext context) {
    return MediaQuery.sizeOf(context);
  }

  static bool isPortrait(BuildContext context) {
    final size = screenSize(context);
    return size.height > size.width;
  }

  static bool isLandscape(BuildContext context) {
    return !isPortrait(context);
  }

  static bool get isAndroid => PlatformUtils.isAndroid;
  static bool get isIOS => PlatformUtils.isIOS;
  static bool get isWeb => PlatformUtils.isWeb;
  static bool get isLinux => PlatformUtils.isLinux;
  static bool get isMacOS => PlatformUtils.isMacOS;
  static bool get isWindows => PlatformUtils.isWindows;
  static bool get isFuchsia => PlatformUtils.isFuchsia;

  static bool get isMobile => PlatformUtils.isMobile;
  static bool get isDesktop => PlatformUtils.isDesktop;
}
