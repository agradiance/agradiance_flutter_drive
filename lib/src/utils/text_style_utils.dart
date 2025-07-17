import 'package:agradiance_flutter_drive/src/extensions/text_style_extension.dart';
import 'package:flutter/material.dart';

class TextStyleUtils {
  static Map<String, dynamic> toMap(final TextStyle style) {
    return style.toMap();
  }

  static TextStyle fromMap(Map<String, dynamic> map) {
    return TextStyle().copyWith(
      color: map['color'] != null ? Color(map['color']) : null,
      fontSize: map['fontSize']?.toDouble(),
      fontWeight: map['fontWeight'] != null
          ? FontWeight.values[map['fontWeight']]
          : null,
      fontStyle: map['fontStyle'] != null
          ? FontStyle.values[map['fontStyle']]
          : null,
      letterSpacing: map['letterSpacing']?.toDouble(),
      wordSpacing: map['wordSpacing']?.toDouble(),
      height: map['height']?.toDouble(),
      fontFamily: map['fontFamily'],
    );
  }
}
