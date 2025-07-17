import 'package:agradiance_flutter_drive/src/extensions/text_align_extension.dart';
import 'package:flutter/material.dart';

class TextAlignUtils {
  static TextAlign fromMap(final Map<String, dynamic> map) {
    return TextAlignExtension.fromMap(map);
  }

  static Map<String, dynamic> toMap(final TextAlign textAlign) {
    return textAlign.toMap();
  }
}
