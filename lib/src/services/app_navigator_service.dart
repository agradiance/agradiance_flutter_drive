import 'package:flutter/material.dart';

class AppMainNavigationService {
  final navigatorKey = GlobalKey<NavigatorState>();
  final rootScaffoldStateKey = GlobalKey<ScaffoldState>();

  static final AppMainNavigationService _internal =
      AppMainNavigationService._();
  static AppMainNavigationService instance = AppMainNavigationService();

  AppMainNavigationService._();

  factory AppMainNavigationService() {
    return _internal;
  }

  BuildContext? get context => instance.navigatorKey.currentState?.context;

  void openDrawer() {
    rootScaffoldStateKey.currentState?.openDrawer();
  }

  void closeDrawer() {
    rootScaffoldStateKey.currentState?.closeDrawer();
  }
}
