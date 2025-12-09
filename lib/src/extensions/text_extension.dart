import 'package:agradiance_flutter_drive/src/extensions/color_extension.dart';
import 'package:flutter/material.dart';

extension TextStyleExtensions on Text {
  Text copyWith({
    Key? key,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextAlign? textAlign,
    TextDirection? textDirection,
    Locale? locale,
    bool? softWrap,
    TextOverflow? overflow,
    double? textScaleFactor,
    TextScaler? textScaler,
    int? maxLines,
    String? semanticsLabel,
    String? semanticsIdentifier,
    TextWidthBasis? textWidthBasis,
    TextHeightBehavior? textHeightBehavior,
    Color? selectionColor,
    String? data,
  }) {
    // final currentStyle = this.style ?? const TextStyle();
    return Text(
      data ?? this.data ?? '',
      key: key ?? this.key,
      style: style ?? this.style,
      strutStyle: strutStyle ?? this.strutStyle,
      textAlign: textAlign ?? this.textAlign,
      textDirection: textDirection ?? this.textDirection,
      locale: locale ?? this.locale,
      softWrap: softWrap ?? this.softWrap,
      overflow: overflow ?? this.overflow,
      textScaler: textScaler ?? this.textScaler,
      maxLines: maxLines ?? this.maxLines,
      semanticsLabel: semanticsLabel ?? this.semanticsLabel,
      semanticsIdentifier: semanticsIdentifier ?? this.semanticsIdentifier,
      textWidthBasis: textWidthBasis ?? this.textWidthBasis,
      textHeightBehavior: textHeightBehavior ?? this.textHeightBehavior,
      selectionColor: selectionColor ?? this.selectionColor,
    );
  }

  // FontStyle
  Text get italicFontStyle => copyWith(style: (style ?? TextStyle()).copyWith(fontStyle: FontStyle.italic));
  Text get normalFontStyle => copyWith(style: (style ?? TextStyle()).copyWith(fontStyle: FontStyle.normal));

  // TextDecoration
  Text get bold => weight(FontWeight.bold);
  Text get normal => weight(FontWeight.normal);
  Text get underline => copyWith(style: (style ?? TextStyle()).copyWith(decoration: TextDecoration.underline));
  Text get lineThrough => copyWith(style: (style ?? TextStyle()).copyWith(decoration: TextDecoration.lineThrough));
  Text get overline => copyWith(style: (style ?? TextStyle()).copyWith(decoration: TextDecoration.overline));
  Text get none => copyWith(style: (style ?? TextStyle()).copyWith(decoration: TextDecoration.none));

  // Align
  Text get center => copyWith(textAlign: TextAlign.center);
  Text get end => copyWith(textAlign: TextAlign.end);
  Text get justify => copyWith(textAlign: TextAlign.justify);
  Text get left => copyWith(textAlign: TextAlign.left);
  Text get right => copyWith(textAlign: TextAlign.right);
  Text get start => copyWith(textAlign: TextAlign.start);

  Text font(String fontFamily) => copyWith(style: (style ?? TextStyle()).copyWith(fontFamily: fontFamily));

  Text color(Color color) => copyWith(style: (style ?? TextStyle()).copyWith(color: color));

  Text lines(int maxLines) => copyWith(maxLines: maxLines);

  Text weight(FontWeight fontWeight) => copyWith(style: (style ?? TextStyle()).copyWith(fontWeight: fontWeight));

  Text size(double fontSize) => copyWith(style: (style ?? TextStyle()).copyWith(fontSize: fontSize));

  Text outlined({Color? outlinedColor, double strokeWidth = 2, PaintingStyle paintingStyle = PaintingStyle.stroke}) {
    return copyWith(
      style: (style ?? TextStyle()).copyWith(
        foreground: Paint()
          ..style = paintingStyle
          ..strokeWidth = strokeWidth
          ..color = (outlinedColor ?? style?.color?.luminance ?? Colors.black), // Outline color
      ),
    );
  }

  Text sp(double fontSize) => size(fontSize);
  Text get sp0 => size(0);
  Text get sp1 => size(1);
  Text get sp2 => size(2);
  Text get sp3 => size(3);
  Text get sp4 => size(4);
  Text get sp5 => size(5);
  Text get sp6 => size(6);
  Text get sp7 => size(7);
  Text get sp8 => size(8);
  Text get sp9 => size(9);
  Text get sp10 => size(10);
  Text get sp11 => size(11);
  Text get sp12 => size(12);
  Text get sp13 => size(13);
  Text get sp14 => size(14);
  Text get sp15 => size(15);
  Text get sp16 => size(16);
  Text get sp17 => size(17);
  Text get sp18 => size(18);
  Text get sp19 => size(19);
  Text get sp20 => size(20);
}
