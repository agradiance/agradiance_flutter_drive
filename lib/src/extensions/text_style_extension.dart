import 'package:flutter/material.dart';

extension TextStyleMapExtension on TextStyle {
  Map<String, dynamic> toMap() {
    return {
      'color': color?.toARGB32(),
      'fontSize': fontSize,
      'fontWeight': fontWeight?.index,
      'fontStyle': fontStyle?.index,
      'letterSpacing': letterSpacing,
      'wordSpacing': wordSpacing,
      'height': height,
      'decorationColor': decorationColor?.toARGB32(),
      'decorationStyle': decorationStyle?.index,
      'fontFamily': fontFamily,
    };
  }

  static TextStyle fromMap(Map<String, dynamic> map) {
    return TextStyle(
      color: map['color'] != null ? Color(map['color']) : null,
      fontSize: map['fontSize']?.toDouble(),
      fontWeight:
          map['fontWeight'] != null
              ? FontWeight.values[map['fontWeight']]
              : null,
      fontStyle:
          map['fontStyle'] != null ? FontStyle.values[map['fontStyle']] : null,
      letterSpacing: map['letterSpacing']?.toDouble(),
      wordSpacing: map['wordSpacing']?.toDouble(),
      height: map['height']?.toDouble(),

      decorationColor:
          map['decorationColor'] != null ? Color(map['decorationColor']) : null,
      decorationStyle:
          map['decorationStyle'] != null
              ? TextDecorationStyle.values[map['decorationStyle']]
              : null,
      fontFamily: map['fontFamily'],
    );
  }
}
