import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    super.key,
    this.onPressed,
    this.child,
    this.text,
    this.textStyle,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.style,
  }) : assert(child != null || text != null, "child or text must be provided");

  final void Function()? onPressed;
  final Widget? child;
  final String? text;
  final TextStyle? textStyle;
  final void Function()? onLongPress;
  final void Function(bool)? onHover;
  final void Function(bool)? onFocusChange;
  final ButtonStyle? style;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      onLongPress: onLongPress,
      onFocusChange: onFocusChange,
      onHover: onHover,
      style: style,
      child:
          child ??
          (text != null ? Text(text!, style: textStyle) : SizedBox.shrink()),
    );
  }
}
