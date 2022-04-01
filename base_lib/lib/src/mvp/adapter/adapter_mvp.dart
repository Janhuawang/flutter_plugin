import 'package:base_lib/src/mvp/adapter/adapter_widget.dart';
import 'package:base_lib/src/mvp/base/model.dart';
import 'package:base_lib/src/mvp/base/presenter.dart';
import 'package:base_lib/src/mvp/base/view.dart';
import 'package:flutter/material.dart';

import '../../../mvp.dart';
import '../data.dart';

/*
 * MVP - P
 */
abstract class NP<V extends NV, M extends NM, D extends NDataModel>
    extends BasePresenter {}

/*
 * MVP - V
 */
abstract class NV extends BaseView {}

/*
 * MVP - M
 */
abstract class NM extends BaseModel {}

/*
 * 数据模型
 */
abstract class NDataModel with IState {}

/*
 * Entry - 页面入口
 */
abstract class NAdapterEntry extends StatelessWidget with AdapterWidget {
  @protected
  Widget build(BuildContext context) {
    return buildAdapter(context);
  }
}

/*
 * Widget - 用来与State绑定
 */
abstract class NAdapterWidget extends BaseWidget {
  NAdapterWidget({Key? key}) : super(key: key);
}

/*
 * State
 */
abstract class NAdapterState<P extends NP, W extends NAdapterWidget>
    extends BaseState<P, W> with AdapterWidget {
  /*
   * 增加这个方法的目的是 业务模块在适配平台时更直观，保留buildPhone方法即为保留适配那一整套，对后期扩展有较大好处，例如：适配屏幕旋转等。
   */
  Widget buildPlatform(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return buildAdapter(context);
  }

  @override
  Widget buildPhone(BuildContext context) {
    return buildPlatform(context);
  }

  /*
   * 获取当前平台
   */
  AdaptPlatform getPlatform() {
    return platform(context);
  }
}
