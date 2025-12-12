import 'package:flutter/material.dart' show Color, Colors;

extension ColorExtension on Color {
  Color get luminance {
    final luminance = computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  Color get invert {
    return Color.fromARGB((a * 255).round(), 255 - (r * 255).round(), 255 - (g * 255).round(), 255 - (b * 255).round());
  }

  Color withAlphaOpacity(double opacity) {
    assert(opacity >= 0.0 && opacity <= 1.0);
    return withAlpha((255.0 * opacity).round());
  }

  static Color colorFromHex(String hex) {
    hex = hex.replaceAll("#", "").replaceAll("0x", "");

    if (hex.length == 6) {
      // If no alpha value, add FF
      hex = "FF$hex";
    }

    return Color(int.parse(hex, radix: 16));
  }

  int get alphaRounded => (a * 255.0).round().clamp(0, 255);
  int get redRounded => (r * 255.0).round().clamp(0, 255);
  int get greenRounded => (g * 255.0).round().clamp(0, 255);
  int get blueRounded => (b * 255.0).round().clamp(0, 255);

  String toHexString({bool includeAlpha = false}) {
    final String alpha = alphaRounded.toRadixString(16).padLeft(2, '0').toUpperCase();
    final String red = redRounded.toRadixString(16).padLeft(2, '0').toUpperCase();
    final String green = greenRounded.toRadixString(16).padLeft(2, '0').toUpperCase();
    final String blue = blueRounded.toRadixString(16).padLeft(2, '0').toUpperCase();

    if (includeAlpha) {
      return '$alpha$red$green$blue';
    } else {
      return '$red$green$blue';
    }
  }
}
