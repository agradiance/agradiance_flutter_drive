import 'package:agradiance_flutter_drive/src/extensions/null_extension.dart';
import 'package:flutter/material.dart';

class CustomStackPlaceholderWidget extends StatelessWidget {
  const CustomStackPlaceholderWidget({
    super.key,
    this.child,
    this.topWidget,
    this.hideTop = false,
    this.hideChild = false,
    this.childOpacity = 1,
  });

  final Widget? topWidget;
  final Widget? child;
  final bool hideTop;
  final bool hideChild;
  final double childOpacity;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (topWidget.isNotNull)
          Visibility(
            visible: !hideChild,
            child: Opacity(opacity: childOpacity, child: child),
          ),
        if (topWidget.isNotNull) Visibility(visible: !hideTop, child: topWidget!),
      ],
    );
  }
}
