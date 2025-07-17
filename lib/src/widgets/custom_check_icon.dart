import 'package:flutter/material.dart';

class CCheckIcon extends StatelessWidget {
  const CCheckIcon({super.key, this.value = false, this.width, this.height});

  final bool value;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: FittedBox(child: Icon(value ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded)),
    );
  }
}
