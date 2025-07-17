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
}
