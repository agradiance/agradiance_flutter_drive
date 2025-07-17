import 'package:agradiance_flutter_drive/src/extensions/text_extension.dart';
import 'package:elegant_theme/elegant_theme.dart';
import 'package:flutter/material.dart';

class ThemeDialogWidget extends StatefulWidget {
  const ThemeDialogWidget({super.key});

  static Future<T?> showThemeDialogOf<T>(BuildContext context) {
    final themes = context.elegantTheme.themes;
    if (themes != null) {
      return showModalBottomSheet<T>(
        context: context,
        shape: RoundedRectangleBorder(),
        showDragHandle: true,
        isScrollControlled: true,

        builder: (context) {
          return ThemeDialogWidget();
        },
      );
    }
    return Future.value();
  }

  @override
  State<ThemeDialogWidget> createState() => _ThemeDialogWidgetState();
}

class _ThemeDialogWidgetState extends State<ThemeDialogWidget> {
  List<ElegantThemeData>? get _themes => context.elegantTheme.themes;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            spacing: 10,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 300,
                height: 40,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    //
                    Positioned(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 5,
                        children: [Icon(Icons.color_lens), Text("THEME").bold.sp15],
                      ),
                    ),
                    Positioned(
                      right: 10,
                      child: SizedBox(
                        height: 30,
                        child: FittedBox(
                          child: CloseButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 35,
                child: Row(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            context.switchToDarkThemeMode();
                          });
                        },
                        icon: Icon(Icons.dark_mode),
                        label: Text("Dark"),
                      ),
                    ),
                    Flexible(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            context.switchToLightThemeMode();
                          });
                        },
                        icon: Icon(Icons.light_mode),
                        label: Text("Light"),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 300,
                    constraints: BoxConstraints(maxHeight: 300, maxWidth: 200),
                    child: Builder(
                      builder: (context) {
                        final themes = _themes;
                        if (themes == null) {
                          return SizedBox.shrink();
                        }

                        return ListView.builder(
                          itemCount: themes.length,
                          itemBuilder: (context, index) {
                            final theme = themes[index];

                            return Card.outlined(
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  spacing: 3,
                                  children: [
                                    CircleAvatar(
                                      radius: 6,
                                      backgroundColor:
                                          ElegantTheme.of(context).themes?[index].light.colorScheme.primary ??
                                          Colors.transparent,
                                      child: SizedBox(width: 10, height: 10),
                                    ),

                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            context.setThemeByIndex(index: index);
                                          });
                                        },
                                        child: Padding(padding: const EdgeInsets.all(3.0), child: Text(theme.name)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
