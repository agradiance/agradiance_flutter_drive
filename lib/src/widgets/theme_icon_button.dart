import 'package:agradiance_flutter_drive/src/widgets/theme_dialog_widget.dart';
import 'package:elegant_theme/elegant_theme.dart';
import 'package:flutter/material.dart';

class ThemeIconButton extends StatefulWidget {
  const ThemeIconButton({super.key, this.iconSize});

  final double? iconSize;

  @override
  State<ThemeIconButton> createState() => _ThemeIconButtonState();
}

class _ThemeIconButtonState extends State<ThemeIconButton> {
  late ValueNotifier<ThemeMode> valueNotifier;

  @override
  void initState() {
    super.initState();
    valueNotifier = ValueNotifier(context.elegantThemeMode);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: valueNotifier,
      builder: (context, value, child) {
        return Tooltip(
          message: context.isSystemThemeMode
              ? "Theme mode"
              : context.isDarkThemeMode
              ? "Switch to light theme"
              : "Switch to dark theme",
          child: GestureDetector(
            onLongPress: () {
              ThemeDialogWidget.showThemeDialogOf(context);
            },
            onTap: () {
              //
              if (context.isDarkThemeMode) {
                context.switchToLightThemeMode();
                valueNotifier.value = context.elegantThemeMode;
              } else if (context.isLightThemeMode) {
                context.switchToDarkThemeMode();
                valueNotifier.value = context.elegantThemeMode;
              } else {
                context.switchThemeMode();
                valueNotifier.value = context.elegantThemeMode;
              }
            },
            child: Icon(context.isDarkThemeMode ? Icons.light_mode : Icons.dark_mode, size: widget.iconSize),
          ),
        );
      },
    );
  }
}
