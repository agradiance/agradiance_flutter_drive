import 'package:flutter/material.dart';

class CFittedBox extends StatelessWidget {
  const CFittedBox({
    super.key,
    this.fit = BoxFit.scaleDown,
    this.alignment = Alignment.centerLeft,
    this.clipBehavior = Clip.none,
    this.child,
    this.size,
  });

  final BoxFit fit;
  final AlignmentGeometry alignment;
  final Clip clipBehavior;
  final Widget? child;
  final Size? size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: size,
      child: FittedBox(alignment: alignment, clipBehavior: clipBehavior, fit: fit, child: child),
    );
  }
}
