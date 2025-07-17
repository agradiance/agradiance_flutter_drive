import 'package:agradiance_flutter_drive/src/extensions/rect_extension.dart';
import 'package:flutter/material.dart';

class RectUtils {
  static Rect fromMap(final Map<String, dynamic> map) {
    final left = map["left"];
    final top = map["top"];
    final right = map["right"];
    final bottom = map["bottom"];
    return Rect.fromLTRB(left, top, right, bottom);
  }

  static Map<String, dynamic> toMap(final Rect rect) {
    return rect.toMap();
  }
}
