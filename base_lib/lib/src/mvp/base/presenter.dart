import 'package:base_lib/src/mvp/base/model.dart';
import 'package:flutter/material.dart';

import '../data.dart';
import '../mvp.dart';

abstract class BaseView extends AbstractView {}

/*
 * p - 基层
 */
abstract class BasePresenter<V extends BaseView, M extends BaseModel,
    D extends IState> implements AbstractP<V> {
  M? _model;
  V? _view;

  @override
  void attachView(V view) {
    this._model = createModel();
    this._view = view;
  }

  @override
  void detachView() {
    if (_view != null) {
      _view = null;
    }
  }

  M? getModel() {
    return _model;
  }

  V? getView() {
    return _view;
  }

  M? createModel();

  D? _stateModel;

  void setStateModel(D stateModel) {
    _stateModel = stateModel;
  }

  D? getStateModel() {
    return _stateModel;
  }

  void initState() {}

  void dispose() {}

  /*
   * 返回键
   */
  void onBack() {
    Navigator.of(_view!.getBuildContext()).pop();
    // Channel.getInstance().backNative();
  }

  /*
   * 页面如入参方法
   */
  void setPageArguments(Map<String, dynamic> arguments) {}
}
