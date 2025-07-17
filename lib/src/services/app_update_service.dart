import 'dart:async';

import 'package:agradiance_flutter_drive/src/widgets/custom_app_update_modal_sheet.dart';
import 'package:flutter/material.dart';

import 'package:new_version_plus/new_version_plus.dart';

import 'package:url_launcher/url_launcher.dart';

class AppUpdateService {
  AppUpdateService._internal();

  static AppUpdateService instance = AppUpdateService._internal();

  factory AppUpdateService() {
    return instance;
  }

  Future<NewVersionPlus> checkSS() async {
    return NewVersionPlus(
      androidHtmlReleaseNotes: true, //support country code
    );
  }

  Future<void> launch({
    required String appStoreLink,
    NewVersionPlus? newVersionPlus,
    LaunchMode launchMode = LaunchMode.platformDefault,
  }) async {
    await (newVersionPlus ?? await AppUpdateService.instance.checkSS()).launchAppStore(appStoreLink);
  }

  Future<VersionStatus?> _getVersionStatus([NewVersionPlus? newVersion]) async {
    return (newVersion ?? await checkSS()).getVersionStatus();
  }

  Future<void> showUpdateDialog({required BuildContext context, bool showWhenUptodate = false}) async {
    final newVersion = await checkSS();

    final versionStatus = await _getVersionStatus(newVersion);
    final canUpdate = versionStatus?.canUpdate ?? false;

    if (canUpdate || showWhenUptodate) {
      await showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(),
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) {
          //
          return PopScope(canPop: false, child: CustomAppUpdateModalSheet(versionStatus: versionStatus));
        },
      );
    }
  }
}
