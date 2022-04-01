import 'package:base_lib/src/util/screen.dart';
import 'package:base_lib/util.dart';
import 'package:flutter/material.dart';

/*
 * 当前支持的平台
 */
enum AdaptPlatform {
  phone, // 手机-竖屏
  phoneLandscape, // 手机-横屏
  padPortrait, // Pad-竖屏
  padLandscape, // Pad-横屏
  web, // Web 浏览器
}

/*
 * 适配层- widget
 */
abstract class AdapterWidget {
  /*
   * 屏幕宽高
   */
  double? _screenWidth;
  double? _screenHeight;

  final Map<String, WidgetBuilder> _allAdapters = {};

  Widget buildAdapter(BuildContext context) {
    initRpx(context);
    initSize(context);
    initAdapter();
    return _allAdapters[platform(context).toString()]?.call(context) ??
        Container();
  }

  Widget buildPhone(BuildContext context);

  Widget buildPhoneLandscape(BuildContext context) {
    return buildPhone(context);
  }

  Widget buildPadPortrait(BuildContext context) {
    return buildPhone(context);
  }

  Widget buildPadLandscape(BuildContext context) {
    return buildPhone(context);
  }

  Widget buildWeb(BuildContext context) {
    return buildPadLandscape(context);
  }

  Widget _buildWebToFixed(BuildContext context) {
    return Container(
        color: bgColorToWeb(),
        alignment: Alignment.topCenter,
        child: buildWeb(context));
  }

  void addAdapter(String platformType, WidgetBuilder builder) {
    if (_allAdapters.containsKey(platformType)) {
      return;
    }
    _allAdapters[platformType] = builder;
  }

  /*
   * 屏幕宽高
   */
  void initSize(BuildContext context) {
    _screenWidth = SizeTool.getWidth(context);
    _screenHeight = SizeTool.getHeight(context);
  }

  /*
   * 适配配置
   */
  void initRpx(BuildContext context, {double platformWidth = 375}) {
    AdaptPlatform adaptPlatform = platform(context);
    switch (adaptPlatform) {
      case AdaptPlatform.phone:
        platformWidth = 375;
        break;

      case AdaptPlatform.padLandscape:
        platformWidth = 1024;
        break;

      case AdaptPlatform.web:
        platformWidth = 1920;
        break;

      default:
        platformWidth = 375;
    }

    ScreenUtil.initialize(context,
        platformWidth: platformWidth, platform: adaptPlatform);
  }

  /*
   * 布局适配
   */
  void initAdapter() {
    addAdapter(AdaptPlatform.phone.toString(), buildPhone);
    addAdapter(AdaptPlatform.phoneLandscape.toString(), buildPhoneLandscape);
    addAdapter(AdaptPlatform.padPortrait.toString(), buildPadPortrait);
    addAdapter(AdaptPlatform.padLandscape.toString(), buildPadLandscape);
    addAdapter(AdaptPlatform.web.toString(), _buildWebToFixed);
  }

  /*
   * 当前平台
   */
  AdaptPlatform platform(BuildContext context) {
    switch (PlatformTools.getDevices(context)) {
      case PlatformType.Mobile:
        return AdaptPlatform.phone;

      case PlatformType.Pad:
        return AdaptPlatform.padLandscape;

      case PlatformType.Web:
        return AdaptPlatform.web;

      default:
        return AdaptPlatform.phone;
    }
  }

  double toRpx(double size) {
    return ScreenUtil.setRpx(size);
  }

  double get screenHeight => _screenHeight ?? 0;

  double get screenWidth => _screenWidth ?? 0;

  Color? bgColorToWeb() {
    return null;
  }

  /*
   * 适配web布局
   */
  Widget adapterWeb(Widget body,
      {bool autoRollVertical = false, double left = 360, double right = 360}) {
    if (autoRollVertical) {
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: _buildScale(body, left: left, right: right),
      );
    } else {
      return _buildScale(body, left: left, right: right);
    }
  }

  /*
   * 比例划分
   */
  Widget _buildScale(Widget body, {double left = 360, double right = 360}) {
    return Flex(
      direction: Axis.horizontal,
      children: [
        SizedBox(
          width: toRpx(left),
        ),
        Expanded(child: body),
        SizedBox(
          width: toRpx(right),
        ),
      ],
    );
  }
}
