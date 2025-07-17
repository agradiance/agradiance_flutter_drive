import 'package:flutter/material.dart';

import '../../../../gen/assets.gen.dart';

class SignInExpandedLeftPane extends StatelessWidget {
  const SignInExpandedLeftPane({
    super.key,
    required this.appDescription,
    required this.appNameFull,
  });

  final String appDescription;
  final String appNameFull;

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.transparent,
            child: Assets.images.icon.acmLogo.image(),
          ),
          Text.rich(
            TextSpan(
              text: appNameFull,
              children: [TextSpan(text: "\n$appDescription")],
            ),
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
