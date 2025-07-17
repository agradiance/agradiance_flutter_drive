import 'dart:ui' show Rect;

import 'package:share_plus/share_plus.dart';

class ShareService {
  ShareService._internal();

  static ShareService instance = ShareService._internal();

  factory ShareService() {
    return instance;
  }

  Future<ShareResult> shareWithParams({required ShareParams params}) async {
    return await SharePlus.instance.share(params);
  }

  Future<ShareResult> share({
    String? text,
    String? subject,
    String? title,
    XFile? previewThumbnail,
    Rect? sharePositionOrigin,
    Uri? uri,
    List<XFile>? files,
    List<String>? fileNameOverrides,
    bool downloadFallbackEnabled = true,
    bool mailToFallbackEnabled = true,
  }) async {
    final params = ShareParams(
      downloadFallbackEnabled: downloadFallbackEnabled,
      fileNameOverrides: fileNameOverrides,
      files: files,
      mailToFallbackEnabled: mailToFallbackEnabled,
      previewThumbnail: previewThumbnail,
      sharePositionOrigin: sharePositionOrigin,
      subject: subject,
      text: text,
      title: title,
      uri: uri,
    );

    return await SharePlus.instance.share(params);
  }

  Future<ShareResult> shareText({
    String? text,
    String? subject,
    String? title,
    XFile? previewThumbnail,
    Rect? sharePositionOrigin,
    bool downloadFallbackEnabled = true,
    bool mailToFallbackEnabled = true,
  }) async {
    final params = ShareParams(
      downloadFallbackEnabled: downloadFallbackEnabled,
      mailToFallbackEnabled: mailToFallbackEnabled,
      previewThumbnail: previewThumbnail,
      sharePositionOrigin: sharePositionOrigin,
      subject: subject,
      text: text,
      title: title,
    );

    return await SharePlus.instance.share(params);
  }

  Future<ShareResult> shareUri({
    String? subject,
    String? title,
    XFile? previewThumbnail,
    Rect? sharePositionOrigin,
    Uri? uri,
    List<XFile>? files,
    List<String>? fileNameOverrides,
    bool downloadFallbackEnabled = true,
    bool mailToFallbackEnabled = true,
  }) async {
    final params = ShareParams(
      downloadFallbackEnabled: downloadFallbackEnabled,
      fileNameOverrides: fileNameOverrides,
      files: files,
      mailToFallbackEnabled: mailToFallbackEnabled,
      previewThumbnail: previewThumbnail,
      sharePositionOrigin: sharePositionOrigin,
      subject: subject,
      title: title,
      uri: uri,
    );

    return await SharePlus.instance.share(params);
  }

  Future<ShareResult> shareFiles({
    String? text,
    String? subject,
    String? title,
    XFile? previewThumbnail,
    Rect? sharePositionOrigin,
    Uri? uri,
    List<XFile>? files,
    List<String>? fileNameOverrides,
    bool downloadFallbackEnabled = true,
    bool mailToFallbackEnabled = true,
  }) async {
    final params = ShareParams(
      downloadFallbackEnabled: downloadFallbackEnabled,
      fileNameOverrides: fileNameOverrides,
      files: files,
      mailToFallbackEnabled: mailToFallbackEnabled,
      previewThumbnail: previewThumbnail,
      sharePositionOrigin: sharePositionOrigin,
      subject: subject,
      text: text,
      title: title,
      uri: uri,
    );

    return await SharePlus.instance.share(params);
  }
}
