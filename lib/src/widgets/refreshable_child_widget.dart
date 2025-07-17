import 'package:flutter/material.dart';

class RefreshChild extends StatelessWidget {
  const RefreshChild({
    super.key,
    this.alignment = Alignment.center,
    this.scrollDirection = Axis.vertical,
    this.child,
    this.height,
    this.width,
  });

  final Widget? child;
  final double? width;
  final double? height;
  final AlignmentGeometry alignment;
  final Axis scrollDirection;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        alignment: alignment,
        fit: StackFit.loose,
        children: [
          ListView(scrollDirection: scrollDirection),
          if (child != null) ...[child!],
        ],
      ),
    );
  }
}

enum RefreshableChildFit<T extends StackFit> {
  loose<StackFit>();

  //
  const RefreshableChildFit();
}
