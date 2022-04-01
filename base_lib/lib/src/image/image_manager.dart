import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef ImageMsgCallback = void Function(int w, int h);

/*
 * 图片加载库
 */
class ImageTools {
  /*
   * ImageProvider - 标准的
   */
  static ImageProvider toImageProvider(String? imageUrl) {
    return CachedNetworkImageProvider(imageUrl ?? "");
  }

  /*
   * Image - 占位 - 标准的
   */
  static Widget toImageStandard(String? imageUrl,
      {BorderRadius? borderRadius,
      BoxFit boxFit = BoxFit.contain,
      FilterQuality filterQuality = FilterQuality.low,
      ProgressIndicatorBuilder? progressIndicatorBuilder,
      double? width,
      double? height}) {
    return toImage(
      imageUrl,
      Image.asset("assets/images/image_placeholder.png"),
      Image.asset("assets/images/image_placeholder.png"),
      boxFit: boxFit,
      borderRadius: borderRadius,
      filterQuality: filterQuality,
      width: width,
      height: height,
    );
  }

  /*
   * Image - 占位 - 进度
   */
  static Widget toImageProgress(String? imageUrl,
      {BorderRadius? borderRadius,
      BoxFit boxFit = BoxFit.contain,
      FilterQuality filterQuality = FilterQuality.low,
      double? width,
      double? height}) {
    return toImage(
        imageUrl,
        Image.asset("assets/images/image_placeholder.png", fit: BoxFit.contain),
        Image.asset("assets/images/image_placeholder.png"),
        boxFit: boxFit,
        width: width,
        height: height,
        filterQuality: filterQuality,
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            CircularProgressIndicator(value: downloadProgress.progress));
  }

  /*
   * Image - 占位
   */
  static Widget toImage(
    String? imageUrl,
    Widget? placeholder,
    Widget? errorWidget, {
    BorderRadius? borderRadius,
    ProgressIndicatorBuilder? progressIndicatorBuilder,
    BoxFit boxFit = BoxFit.contain,
    FilterQuality filterQuality = FilterQuality.low,
    double? width,
    double? height,
  }) {
    return CachedNetworkImage(
      imageUrl: imageUrl ?? "",
      imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
        borderRadius: borderRadius,
        image: DecorationImage(
          image: imageProvider,
          fit: boxFit,
        ),
      )),
      width: width,
      height: height,
      filterQuality: filterQuality,
      progressIndicatorBuilder: progressIndicatorBuilder,
      placeholder: (context, url) => placeholder ?? Container(),
      errorWidget: (context, url, error) => errorWidget ?? Container(),
    );
  }

  /*
   * 获取网络图片宽高
   */
  static void getImageNetMsg(
      String path, ImageMsgCallback imageMsgCallback) async {
    await toImageProvider(path).resolve(new ImageConfiguration())
      ..addListener(new ImageStreamListener((ImageInfo info, bool b) {
        if (info != null && info.image != null) {
          imageMsgCallback(info.image.width, info.image.height);
        } else {
          imageMsgCallback(0, 0);
        }
      }));
  }
}
