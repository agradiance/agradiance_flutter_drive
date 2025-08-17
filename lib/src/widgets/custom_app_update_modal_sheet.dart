import 'package:agradiance_flutter_drive/gen/assets.gen.dart';
import 'package:agradiance_flutter_drive/src/extensions/build_context_extension.dart';
import 'package:agradiance_flutter_drive/src/extensions/text_extension.dart';
import 'package:agradiance_flutter_drive/src/services/app_update_service.dart';
import 'package:agradiance_flutter_drive/src/widgets/custom_button.dart';
import 'package:agradiance_flutter_drive/src/widgets/failed_state_button.dart';
import 'package:agradiance_flutter_drive/src/widgets/loading_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:flutter_svg/svg.dart';
import 'package:readmore/readmore.dart';

class CustomAppUpdateModalSheet extends StatefulWidget {
  const CustomAppUpdateModalSheet({super.key, this.versionStatus});

  final VersionStatus? versionStatus;

  @override
  State<CustomAppUpdateModalSheet> createState() => _CustomAppUpdateModalSheetState();
}

class _CustomAppUpdateModalSheetState extends State<CustomAppUpdateModalSheet> {
  bool checking = false;
  VersionStatus? versionStatus;

  bool get canUpdate => (versionStatus?.canUpdate ?? false);

  Future<void> checkUpdate() async {
    setState(() {
      checking = true;
    });

    try {
      final newVersion = await AppUpdateService.instance.checkSS();

      versionStatus = await AppUpdateService.instance.getVersionStatus(newVersion);
    } catch (e) {
      //
    } finally {}

    setState(() {
      checking = false;
    });

    // if (canUpdate || showWhenUptodate) {}
  }

  @override
  void initState() {
    if (widget.versionStatus != null) {
      versionStatus = widget.versionStatus;
    } else {
      checkUpdate();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.tightFor(height: 300),
      child: Builder(
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        spacing: 10,
                        children: [
                          // Icon(FontAwesomeIcons.googlePlay),
                          SvgPicture.asset(
                            Assets.images.icon.googlePlay50,
                            // colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcIn),
                            width: 30,
                            height: 30,
                            semanticsLabel: 'Store',
                          ),
                          Text("Play Store"),
                        ],
                      ),
                    ),
                    CloseButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      if (checking) {
                        return LoadingStateWidget();
                      }
                      if (versionStatus == null) {
                        return FailedStateWidget(
                          message: "Try again",
                          onButtonPressed: () {
                            //
                            checkUpdate();
                          },
                        );
                      }
                      return Column(
                        spacing: 10,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Builder(
                              builder: (context) {
                                if (canUpdate) {
                                  return Text("Update available").bold.sp17;
                                } else {
                                  return Text("Update not available").bold.sp17;
                                }
                              },
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Builder(
                              builder: (context) {
                                if (canUpdate) {
                                  return Text(
                                    "New version (${versionStatus?.storeVersion}) is currently available on the store, your app current version is ${versionStatus?.localVersion}. update to get the latest features",
                                  ).bold.sp10;
                                } else {
                                  return Text(
                                    "The latest version on the store is (${versionStatus?.storeVersion}), your current version is ${versionStatus?.localVersion}",
                                  ).bold.sp10;
                                }
                              },
                            ),
                          ),

                          // AnimatedTextKit(
                          //   key: UniqueKey(),
                          //   totalRepeatCount: 1,
                          //   repeatForever: false,
                          //   isRepeatingAnimation: false,

                          //   animatedTexts: [
                          //     TyperAnimatedText(
                          //       '',
                          //       textStyle: const TextStyle(fontWeight: FontWeight.w500),
                          //       speed: 80.milliseconds,
                          //     ),
                          //   ],
                          // ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: ExpansionTile(
                                initiallyExpanded: true,
                                title: Text("What's new").bold,
                                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                                expandedAlignment: Alignment.topCenter,
                                minTileHeight: 0,
                                tilePadding: EdgeInsets.zero,
                                subtitle: Text(versionStatus?.storeVersion ?? ""),
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: ReadMoreText(
                                      versionStatus?.releaseNotes ?? "",
                                      trimMode: TrimMode.Line,
                                      trimLines: 3,
                                      colorClickableText: context.colorScheme.primary,
                                      trimCollapsedText: 'Read more',
                                      trimExpandedText: 'Show less',
                                      moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Row(
                            spacing: 20,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: CButton(
                                  minHeight: 36,
                                  enable: canUpdate,
                                  backgroundColor: context.colorScheme.surface,
                                  text: "Update later",
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),

                              Expanded(
                                child: CButton(
                                  minHeight: 36,
                                  enable: canUpdate,
                                  text: "Update now",
                                  onPressed: () async {
                                    if (versionStatus?.appStoreLink != null) {
                                      AppUpdateService.instance.launch(appStoreLink: versionStatus!.appStoreLink);
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
