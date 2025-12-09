import 'dart:io'; //should not be used for web

import 'package:agradiance_flutter_drive/src/extensions/build_context_extension.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

//
class CGImage<T> extends StatelessWidget {
  ///[imageSource] is required parameter for showing png,jpg,etc image
  final T? imageSource;

  final double? height;
  final bool? showForeGDeco;
  final double? width;
  final Color? color;
  final BoxFit? fit;
  final bool? isProfile;
  final Gradient? gradient;
  final Widget? placeHolderWidget;
  final Alignment? alignment;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final BoxBorder? border;
  final Uint8List? bytes;
  final bool keepLoading;
  final BoxShape boxShape;

  ///a [CGImage] it can be used for showing any type of images
  /// it will shows the placeholder image if image is not found on network image
  const CGImage({
    super.key,
    this.imageSource,
    this.height,
    this.showForeGDeco,
    this.width,
    this.color,
    this.fit = BoxFit.contain,
    this.isProfile = false,
    this.gradient,
    this.placeHolderWidget,
    this.alignment,
    this.onTap,
    this.margin,
    this.padding,
    this.borderRadius,
    this.border,
    this.bytes,
    this.keepLoading = false,
    this.boxShape = BoxShape.rectangle,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ClipRRect(
        clipBehavior: Clip.hardEdge,
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: Container(
          margin: margin,
          width: width,
          height: height,
          padding: padding,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            shape: boxShape,
            borderRadius: boxShape != BoxShape.rectangle ? null : borderRadius,
            border: border,
          ),
          child: InkWell(
            onTap: onTap,
            child: Builder(
              builder: (context) {
                return alignment != null ? Align(alignment: alignment!, child: _buildWidget()) : _buildWidget();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWidget() {
    return _buildImageView();
  }

  Widget _buildImageView() {
    if (imageSource?.toString().isEmpty ?? false) {
      return placeHolderWidget ?? Icon(Icons.broken_image_rounded);
    }

    final ext = imageSource is String ? imageSource?.toString().split(".").lastOrNull : null;
    final svgPath = ext != null && ext.isNotEmpty && ext.toLowerCase().trim() == "svg"
        ? imageSource.toString().trim()
        : null;
    if (svgPath != null) {
      return SizedBox(
        height: height,
        width: width,
        child: SvgPicture.asset(
          colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
          svgPath,
          height: height,
          width: width,
          fit: fit ?? BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return placeHolderWidget ?? Icon(Icons.broken_image_rounded);
          },
        ),
      );
    } else if (imageSource is Uint8List) {
      return Image.memory(
        imageSource as Uint8List,
        height: height,
        width: width,
        fit: fit ?? BoxFit.cover,
        color: color,
        errorBuilder: (context, error, stackTrace) {
          return placeHolderWidget ?? Icon(Icons.broken_image_rounded);
        },
      );
    } else if (imageSource != null && imageSource is String && (imageSource as String).startsWith('assets/')) {
      return Image.asset(
        imageSource as String,
        height: height,
        width: width,
        colorBlendMode: BlendMode.screen,
        fit: fit ?? BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return placeHolderWidget ?? Icon(Icons.broken_image_rounded);
        },
        // color: Colors.black,
      );
    } else if (imageSource != null &&
        (imageSource is String) &&
        imageSource.toString().replaceAll(RegExp("[\"']"), "").isNotEmpty) {
      bool isNetwork =
          Uri.tryParse(imageSource.toString())?.hasScheme == true &&
          (Uri.tryParse(imageSource.toString())?.scheme == 'http' ||
              Uri.tryParse(imageSource.toString())?.scheme == 'https');
      // return Image.network(imageSource, fit: fit);

      // if (kIsWeb) {
      //   return CustomExtendedImage(imageUrl: imageSource);
      // }
      // return CustomExtendedImage(imageUrl: imageSource);
      // return

      return isNetwork
          ? CachedNetworkImage(
              // key: ,
              key: Key(imageSource.toString()),
              cacheKey: imageSource.toString(),
              height: height,
              width: width,

              fit: fit,
              imageUrl: imageSource.toString(),
              color: color,
              placeholder: (context, url) => CustomShimmers(height: height, width: width, borderRadius: borderRadius),
              errorWidget: (context, url, error) => SizedBox(
                height: height,
                width: width,
                child: placeHolderWidget ?? Icon(!isProfile! ? Icons.broken_image_rounded : Icons.person),
              ),
            )
          : kIsWeb || kIsWasm
          ? placeHolderWidget ?? Icon(Icons.broken_image_rounded)
          : Image.file(
              File(imageSource.toString()),
              height: height,
              width: width,
              fit: fit ?? BoxFit.cover,
              color: color,
              errorBuilder: (context, error, stackTrace) {
                return placeHolderWidget ?? Icon(Icons.broken_image_rounded);
              },
            );
    }
    return keepLoading
        ? CustomShimmers(height: height, width: width, borderRadius: borderRadius)
        : SizedBox(height: height, width: width, child: placeHolderWidget ?? Icon(Icons.image));
  }
}

class CustomShimmers extends StatelessWidget {
  const CustomShimmers({super.key, this.width, this.height, this.borderRadius, this.enabled = true});

  final double? height, width;
  final bool enabled;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      containersColor: context.colorScheme.primary.withAlpha(200),

      enabled: enabled,
      child: Container(
        height: height,
        width: width,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(color: Colors.black.withAlpha((255 * 0.4).toInt()), borderRadius: borderRadius),
      ),
    );
  }
}
