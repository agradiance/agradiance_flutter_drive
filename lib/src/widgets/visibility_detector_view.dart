import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VisibilityDetectorView extends StatefulWidget {
  const VisibilityDetectorView({required this.globalKey, required this.builder}) : super(key: globalKey);

  final Key globalKey;
  final Widget Function(bool inView) builder;

  @override
  State<VisibilityDetectorView> createState() => _VisibilityDetectorViewState();
}

class _VisibilityDetectorViewState extends State<VisibilityDetectorView> {
  ValueNotifier<bool> inView = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: widget.globalKey,
      child: ValueListenableBuilder(
        valueListenable: inView,
        builder: (context, value, child) {
          return widget.builder(value);
        },
      ),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.5) {
          inView.value = true;
        } else {
          inView.value = false;
        }
      },
    );
  }
}
