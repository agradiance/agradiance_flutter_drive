import 'dart:async';

import 'package:app_links/app_links.dart';

class AppLinkManager {
  AppLinkManager._internal();
  static final AppLinkManager _instance = AppLinkManager._internal();
  factory AppLinkManager() => _instance;
  static AppLinkManager get instance => AppLinkManager();

  Future<StreamSubscription<Uri>?> initDeepLinks(
    void Function(Uri)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) async {
    // Handle links
    return AppLinks().uriLinkStream.listen(onData, onDone: onDone, onError: onError, cancelOnError: cancelOnError);
  }
}
