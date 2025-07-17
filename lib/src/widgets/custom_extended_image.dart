import 'dart:typed_data';

import 'package:agradiance_flutter_drive/src/logs/debub_print.dart';
import 'package:agradiance_flutter_drive/src/mixins/button_state_mixin.dart';
import 'package:agradiance_flutter_drive/src/widgets/failed_state_button.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:extended_image/extended_image.dart';

// Mobile/Desktop Only

class CustomExtendedImage extends StatefulWidget {
  final String imageUrl;
  // final String fileName;

  const CustomExtendedImage({
    super.key,
    required this.imageUrl,
    // required this.fileName,
  });

  @override
  State<CustomExtendedImage> createState() => _CustomExtendedImageState();
}

class _CustomExtendedImageState extends State<CustomExtendedImage> with ButtonStateMixin {
  Uint8List? _imageBytes;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _downloadAndSave();
  }

  // Download the image and save it locally (mobile/desktop only)
  Future<void> _downloadAndSave() async {
    try {
      final response = await Dio().get(widget.imageUrl, options: Options(responseType: ResponseType.bytes));
      // _restApiService.download(
      //   widget.imageUrl,
      //   "test.png",
      //   options: Options(responseType: ResponseType.bytes),
      // );

      // dprint(await (response.data));

      final bytes = Uint8List.fromList(response.data!);

      // _savedPath = await _saveToFile(bytes, widget.fileName);

      setState(() {
        _imageBytes = bytes;
        _loading = false;
      });
    } catch (e) {
      dprint("Error: $e");
      setState(() => _loading = false);
    }
  }

  // // Save image locally
  // Future<String> _saveToFile(Uint8List bytes, String filename) async {
  //   final dir = await getApplicationDocumentsDirectory();
  //   final file = io.File('${dir.path}/$filename');
  //   await file.writeAsBytes(bytes);
  //   return file.path;
  // }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_imageBytes == null) {
      return FailedStateWidget(
        message: "Failed to load image",
        onButtonPressed: () {
          runButton(() {
            return _downloadAndSave();
          });
        },
      );
    }

    return ExtendedImage.memory(_imageBytes!, fit: BoxFit.cover);
  }
}
