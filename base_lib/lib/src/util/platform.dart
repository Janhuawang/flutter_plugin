import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:base_lib/src/util/print.dart';
import 'package:flutter/material.dart';

enum PlatformType { Mobile, Pad, Web, Other }

/*
 * 平台工具
 */
class PlatformTools {
  static PlatformType? platformType;

  /*
   * 获取当前平台
   */
  static PlatformType getDevices(BuildContext context) {
    if (PlatformTools.platformType != null) {
      return PlatformTools.platformType!;
    }
    PrintTools.printLog("################ Device: ${defaultTargetPlatform}");

    if ((defaultTargetPlatform == TargetPlatform.iOS) ||
        (defaultTargetPlatform == TargetPlatform.android)) {
      PlatformTools.platformType =
          _isPad(context) ? PlatformType.Pad : PlatformType.Mobile;
    } else if ((defaultTargetPlatform == TargetPlatform.linux) ||
        (defaultTargetPlatform == TargetPlatform.macOS) ||
        (defaultTargetPlatform == TargetPlatform.windows)) {
      PlatformTools.platformType = PlatformType.Web;
    } else {
      PlatformTools.platformType = PlatformType.Web;
    }
    return PlatformTools.platformType ?? PlatformType.Mobile;
  }

  /*
   * 是否为一个Pad
   * 参考：https://iiro.dev/implementing-adaptive-master-detail-layouts/
   */
  static bool _isPad(BuildContext context) {
    try {
      var shortestSide = MediaQuery.of(context).size.shortestSide;
      return shortestSide >= 600;
    } catch (e) {
      print("error = PlatformTools._isPad ${e.toString()}");
      return false;
    }
  }

  /*
   * 当前是否为web平台
   */
  // static bool isWeb() {
  //   if (platformType != null) {
  //     return platformType == PlatformType.Web;
  //   } else {
  //     try {
  //       if (!Platform.isAndroid &&
  //           !Platform.isIOS &&
  //           !Platform.isWindows &&
  //           !Platform.isMacOS &&
  //           !Platform.isLinux) {
  //         return true;
  //       }
  //     } catch (e) {
  //       return true;
  //     }
  //     return false;
  //   }
  // }

  /*
   * 当前是否为web平台
   */
  static bool isWeb() {
    return kIsWeb;
  }
}
