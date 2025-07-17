import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CElevatedButton extends StatefulWidget {
  const CElevatedButton({
    super.key,
    this.text,
    this.padding,
    this.margin,
    this.enable = true,
    this.isRunning = false,
    this.textStyle,
    this.borderRadius,
    this.radius = 15,
    this.onDoubleTap,
    this.onHighlightChanged,
    this.onHover,
    this.onLongPress,
    this.onSecondaryTap,
    this.onSecondaryTapCancel,
    this.onSecondaryTapDown,
    this.onSecondaryTapUp,
    this.onPressed,
    this.onTapCancel,
    this.onTapDown,
    this.onTapUp,
    this.onFocusChange,
    this.backgroundColor,
    this.child,
    this.keepChildVisibleOnRunning = false,
    this.tooltip = "",
    this.maxHeight = double.maxFinite,
    this.maxWidth = double.maxFinite,
    this.minHeight = 0,
    this.minWidth = 0,
    this.contraints,
    this.icon,
  });

  final String? text;
  final String tooltip;
  final Widget? child;
  final Widget? icon;
  final double radius;
  final double minWidth;
  final double maxWidth;
  final double minHeight;
  final double maxHeight;
  final BoxConstraints? contraints;
  final bool enable;
  final bool isRunning;
  final bool keepChildVisibleOnRunning;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;

  final void Function()? onPressed;
  final void Function()? onDoubleTap;
  final void Function()? onLongPress;
  final void Function(TapDownDetails)? onTapDown;
  final void Function(TapUpDetails)? onTapUp;
  final void Function()? onTapCancel;
  final void Function()? onSecondaryTap;
  final void Function(TapUpDetails)? onSecondaryTapUp;
  final void Function(TapDownDetails)? onSecondaryTapDown;
  final void Function()? onSecondaryTapCancel;
  final void Function(bool)? onHighlightChanged;
  final void Function(bool)? onHover;
  final void Function(bool)? onFocusChange;

  @override
  State<CElevatedButton> createState() => _CElevatedButtonState();
}

class _CElevatedButtonState extends State<CElevatedButton> {
  bool onHovered = false;
  bool onTappedDown = false;
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: AbsorbPointer(
        absorbing: !widget.enable,
        child: Container(
          constraints:
              widget.contraints ??
              BoxConstraints(
                maxHeight: widget.maxHeight,
                maxWidth: widget.maxWidth,
                minHeight: widget.minHeight,
                minWidth: widget.minWidth,
              ),

          padding: widget.padding ?? EdgeInsets.all(5),
          margin: widget.margin ?? EdgeInsets.all(5),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(),
            onPressed: widget.onPressed,
            icon: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 3,
              children: [
                if (widget.isRunning)
                  LoadingAnimationWidget.threeArchedCircle(color: Theme.of(context).colorScheme.primary, size: 20),

                if (widget.icon != null) widget.icon!,
              ],
            ),
            label: Builder(
              builder: (context) {
                if (widget.child != null) {
                  return widget.child!;
                }
                if (widget.text?.isNotEmpty ?? false) {
                  return Text(widget.text ?? "");
                }
                return SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }
}
