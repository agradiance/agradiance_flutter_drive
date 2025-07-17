import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingStateWidget extends StatelessWidget {
  const LoadingStateWidget({super.key, this.size = 30, this.loadingColor, this.skeletonWidget, this.animatorWidget});

  final double size;
  final Color? loadingColor;
  final Widget? skeletonWidget;
  final Widget? animatorWidget;

  @override
  Widget build(BuildContext context) {
    return Center(
      child:
          skeletonWidget ??
          animatorWidget ??
          LoadingAnimationWidget.threeArchedCircle(
            color: loadingColor ?? Theme.of(context).colorScheme.primary,
            size: size,
          ),
    );
  }
}
