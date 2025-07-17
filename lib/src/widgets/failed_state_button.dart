import 'package:flutter/material.dart';

class FailedStateWidget extends StatelessWidget {
  const FailedStateWidget({
    super.key,
    required this.message,
    this.buttonText,
    this.label,
    this.onButtonPressed,
  });

  final String message;
  final String? buttonText;
  final Widget? label;
  final void Function()? onButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          label ?? Text(message),
          TextButton(onPressed: onButtonPressed, child: Text(buttonText ?? "click to retry")),
          //
        ],
      ),
    );
  }
}
