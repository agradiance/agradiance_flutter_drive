import 'package:flutter/material.dart';

class AppText extends Text {
  const AppText(super.data, {super.key, super.style});

  // Text get fw10 {
  //   return this..style!.copyWith(fontVariations: [], fontWeight: FontVa);
  // }

  Text fv(double value) {
    return AppText(data ?? "", style: (style ?? TextStyle()).copyWith(fontVariations: [FontVariation.weight(value)]));

    // return this..style!.copyWith(fontVariations: [FontVariation.weight(value)]);
  }
}
