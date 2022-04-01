import 'dart:math';

import 'package:flutter/material.dart';

import '../../mvp.dart';
import '../../util.dart';

/*
 * 屏幕
 */
class ScreenUtil {
  /*
   * web适配方式：固定大小 ，不会随浏览器大小改变而变化。1024:768
   */
  static final double WEB_FIXED_WIDTH = 1920;
  static final double WEB_FIXED_HEIGHT = 1699;
  static final double WEB_MIN_WIDTH = 600;
  static double webWidth = WEB_FIXED_WIDTH;
  static double webHeight = WEB_FIXED_HEIGHT;

  static MediaQueryData? _mediaQueryData;
  static double screenWidth = 0;
  static double screenHeight = 0;
  static double topSafeHeight = 0;
  static double bottomSafeHeight = 0;
  static double rpx = 0;

  static void initialize(BuildContext context,
      {double platformWidth = 375,
      AdaptPlatform platform = AdaptPlatform.phone}) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData?.size.width ?? 0;
    screenHeight = _mediaQueryData?.size.height ?? 0;
    topSafeHeight = _mediaQueryData?.padding.top ?? 0;
    bottomSafeHeight = _mediaQueryData?.padding.bottom ?? 0;

    webWidth = max(screenWidth, WEB_MIN_WIDTH);
    webHeight = screenHeight;

    if (platform == AdaptPlatform.web) {
      rpx = webWidth / platformWidth;
    } else {
      rpx = screenWidth / platformWidth;
    }
  }

  static double setRpx(double size) {
    return ScreenUtil.rpx * size;
  }
}

/*
 * 尺寸工具类
 */
class SizeTool {
  static double getWidthGlobal() {
    return ScreenUtil.screenWidth;
  }

  static double getWidthWeb() {
    return ScreenUtil.webWidth;
  }

  static double getWidth(BuildContext context) {
    return PlatformTools.getDevices(context) == PlatformType.Web
        ? ScreenUtil.webWidth
        : MediaQuery.of(context).size.width;
  }

  static double getHeight(BuildContext context) {
    return PlatformTools.getDevices(context) == PlatformType.Web
        ? ScreenUtil.webHeight
        : MediaQuery.of(context).size.height;
  }

  static double getTop(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  static double getBottom(BuildContext context) {
    return MediaQuery.of(context).padding.bottom;
  }

  static double setRpx(double size) {
    return ScreenUtil.setRpx(size);
  }
}
