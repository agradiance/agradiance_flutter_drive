import 'package:flutter/material.dart';

class CListTile extends StatelessWidget {
  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isThreeLine;
  final bool dense;
  final EdgeInsetsGeometry? contentPadding;
  final bool enabled;

  const CListTile({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.isThreeLine = false,
    this.dense = true,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      onTap: onTap,
      isThreeLine: isThreeLine,
      dense: dense,
      contentPadding: contentPadding,
      enabled: enabled,
    );
  }
}
