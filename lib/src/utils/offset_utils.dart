import 'package:agradiance_flutter_drive/src/extensions/offset_extension.dart';
import 'package:flutter/material.dart';

class OffsetUtils {
  static Offset fromMap(final Map<String, dynamic> map) {
    return OffsetExtension.fromMap(map);
  }

  static Map<String, dynamic> toMap(final Offset offset) {
    return offset.toMap();
  }
}
