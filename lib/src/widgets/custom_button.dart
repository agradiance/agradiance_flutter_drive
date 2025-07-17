import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:agradiance_flutter_drive/src/extensions/build_context_extension.dart';
import 'package:agradiance_flutter_drive/src/extensions/color_extension.dart';

class CButton extends StatefulWidget {
  const CButton({
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
  State<CButton> createState() => _CButtonState();
}

class _CButtonState extends State<CButton> {
  bool onHovered = false;
  bool onTappedDown = false;
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: AbsorbPointer(
        absorbing: !widget.enable,
        child: Builder(
          builder: (context) {
            // final backgroundColor =
            //     (widget.backgroundColor ?? Theme.of(context).colorScheme.secondaryContainer.withAlpha(150));

            final backgroundColor =
                (widget.backgroundColor ??
                Theme.of(context).colorScheme.primaryContainer.withAlpha(200));

            final hoverColor = Color.alphaBlend(
              context.colorScheme.primaryContainer.withAlpha(230),
              backgroundColor.withAlpha(230),
            );
            final tappedDownColor = Color.alphaBlend(
              context.colorScheme.primaryContainer.withAlpha(255),
              backgroundColor,
            );

            // return

            return Opacity(
              opacity: widget.enable ? 1 : 0.5,
              child: DefaultTextStyle(
                style: TextStyle(color: backgroundColor.luminance),
                child: Visibility(
                  visible: [
                    widget.text,
                    widget.child,
                  ].any((element) => element != null),
                  child: Container(
                    constraints:
                        widget.contraints ??
                        BoxConstraints(
                          maxHeight: widget.maxHeight,
                          maxWidth: widget.maxWidth,
                          minHeight: widget.minHeight,
                          minWidth: widget.minWidth,
                        ),

                    padding:
                        widget.padding ??
                        EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: context.colorScheme.inversePrimary,
                      ),
                      color: onTappedDown
                          ? tappedDownColor
                          : onHovered
                          ? hoverColor
                          : backgroundColor,
                      borderRadius:
                          widget.borderRadius ??
                          BorderRadius.circular(widget.radius),
                    ),
                    child: Focus(
                      canRequestFocus: true,
                      child: InkWell(
                        onTap: widget.onPressed,
                        onDoubleTap: widget.onDoubleTap,
                        onHover: (value) {
                          setState(() {
                            onHovered = value;
                            widget.onHover?.call(value);
                            if (!value && onTappedDown) {
                              onTappedDown = value;
                            }
                          });
                        },
                        hoverColor: context.colorScheme.primaryContainer,
                        onTapUp: (details) {
                          setState(() {
                            onTappedDown = false;
                            widget.onTapUp?.call(details);
                          });
                        },
                        onLongPress: widget.onLongPress,
                        onHighlightChanged: widget.onHighlightChanged,
                        onSecondaryTap: widget.onSecondaryTap,
                        onSecondaryTapCancel: widget.onSecondaryTapCancel,
                        onSecondaryTapDown: widget.onSecondaryTapDown,
                        onSecondaryTapUp: widget.onSecondaryTapUp,
                        onTapCancel: widget.onTapCancel,
                        onTapDown: (details) {
                          setState(() {
                            onTappedDown = true;
                            widget.onTapDown?.call(details);
                          });
                        },
                        onFocusChange: widget.onFocusChange,
                        radius: widget.radius,
                        child: Stack(
                          fit: StackFit.loose,
                          alignment: Alignment.center,
                          children: [
                            Opacity(
                              opacity:
                                  (widget.isRunning) &&
                                      (!widget.keepChildVisibleOnRunning)
                                  ? 0.68
                                  : 1,
                              child: Builder(
                                builder: (context) {
                                  return widget.child ??
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (widget.text != null)
                                            Text(
                                              widget.text!,
                                              style: widget.textStyle,
                                            ),
                                        ],
                                      );
                                },
                              ),
                            ),

                            if (widget.isRunning)
                              LoadingAnimationWidget.threeArchedCircle(
                                // color: Theme.of(context).colorScheme.primary,
                                color: backgroundColor.luminance,
                                size: 20,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
