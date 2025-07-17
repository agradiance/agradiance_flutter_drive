import 'package:flutter/material.dart';

class CAppBar extends PreferredSize {
  CAppBar({super.key, this.actions, this.automaticallyImplyLeading = true, this.leading, this.title, this.centerTitle})
    : super(preferredSize: Size.fromHeight(kToolbarHeight), child: SizedBox.shrink());

  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final Widget? title;
  final bool? centerTitle;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading,
      centerTitle: true,
      automaticallyImplyLeading: automaticallyImplyLeading,
      title: FittedBox(alignment: Alignment.centerLeft, child: title),
      actions: actions,
    );
  }
}
