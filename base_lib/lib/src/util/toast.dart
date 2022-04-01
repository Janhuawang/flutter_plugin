import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/*
 * 弹窗工具类
 */
class ToastTools {
  /*
   * 初始化
   */
  static TransitionBuilder initToast() {
    return BotToastInit();
  }

  /*
   * 导航观察者
   */
  static NavigatorObserver buildNavigatorObserver() {
    return BotToastNavigatorObserver();
  }

  /*
   * 弹出一个Toast 默认底部剧中效果
   */
  static void toast(String content,
      {int second = 2,
      Alignment align =
          kIsWeb ? Alignment.topCenter : const Alignment(0.0, 0.8)}) {
    BotToast.showText(
      text: content,
      duration: Duration(seconds: second),
      align: align,
      textStyle: TextStyle(
          color: Colors.white, fontWeight: FontWeight.w400, fontSize: 16),
      contentColor: Colors.black,
      borderRadius: BorderRadius.circular(25.0),
      contentPadding: EdgeInsets.only(left: 24, right: 24, top: 12, bottom: 12),
    );
  }
}
