import 'package:flutter/material.dart';

/*
 * 抽象层
 */
abstract class AbstractP<V extends AbstractView> {
  void attachView(V view); // 绑定
  void detachView(); // 分离
}

abstract class AbstractM {}

abstract class AbstractWidget extends StatefulWidget {
  AbstractWidget({Key? key}) : super(key: key);
}

abstract class AbstractView {
  BuildContext getBuildContext();

  void updateState();

  double toRpx(double size);
}
