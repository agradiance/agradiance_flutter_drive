import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';

class FileSaverService {
  FileSaverService._internal();

  static FileSaverService instance = FileSaverService._internal();

  factory FileSaverService() {
    return instance;
  }

  Future<String?> save({
    String? path,
    required String filename,
    required Uint8List fileData,
    required String ext,
    required MimeType mimeType,
  }) async {
    // return FileSaver.instance.saveAs(name: filename, ext: ext, mimeType: mimeType, bytes: fileData);

    await FileSaver.instance.saveFile(
      name: filename,
      bytes: fileData,
      // ext: ext,
      mimeType: mimeType,
    );
    return "";
  }
}
