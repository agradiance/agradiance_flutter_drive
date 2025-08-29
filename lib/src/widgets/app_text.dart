import 'package:flutter/material.dart';

class AppText extends Text {
  const AppText(super.data, {super.key, super.style});

  Text fv(double value) {
    return AppText(data ?? "", style: (style ?? TextStyle()).copyWith(fontVariations: [FontVariation.weight(value)]));
  }
}
