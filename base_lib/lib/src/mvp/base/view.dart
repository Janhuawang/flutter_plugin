import 'package:base_lib/src/mvp/base/presenter.dart';
import 'package:base_lib/src/mvp/mvp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/*
 * Widget - 基类
 */
abstract class BaseWidget extends AbstractWidget {
  BaseWidget({Key? key}) : super(key: key);
}

/*
 * 状态层 - 基层
 */
abstract class BaseState<P extends BasePresenter, W extends BaseWidget>
    extends State<W> with WidgetsBindingObserver implements BaseView {
  late P presenter;

  P createPresenter();

  /*
   * 当前页面是否已经销毁
   */
  bool _isDispose = false;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance?.addPostFrameCallback(onAfterRendering);
    presenter = createPresenter();
    presenter.attachView(this);
    presenter.initState();
    WidgetsBinding.instance?.addObserver(this);
    _init();
    loadData();
  }

  /*
   * 当这个[State]对象的依赖项发生变化时调用。
   */
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  /*
   * 渲染完成，只会调用一次
   */
  void onAfterRendering(Duration duration) {
    initBusiness();
  }

  /*
   * 组件状态改变 横竖屏切换时
   */
  @override
  void didUpdateWidget(covariant W oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _isDispose = true;
    clearData();
    presenter.detachView();
    presenter.dispose();
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    /*
     * app生命周期
     * 切后台会执行：inactive、paused
     * 切前台会执行：resumed
     */
    switch (state) {
      case AppLifecycleState.resumed: // 切换到前台回调
        print("app生命周期-------resumed");
        resumed();
        break;

      case AppLifecycleState.inactive: // 切换到后台回调
        print("app生命周期-------inactive");
        inactive();
        break;

      case AppLifecycleState.paused: // 切换到后台回调
        print("app生命周期-------paused");
        paused();
        break;

      case AppLifecycleState.detached: // 为什么没调？
        print("app生命周期-------detached");
        detached();
        break;
    }
  }

  void _init() {
    initData();
  }

  void initData() {}

  void initBusiness() {} // 初始化业务

  void clearData() {}

  void loadData() {}

  void resumed() {}

  void inactive() {}

  void paused() {}

  void detached() {}

  void updateState() {
    if (!_isDispose) {
      setState(() {});
    }
  }

  @override
  BuildContext getBuildContext() {
    return context;
  }

  bool get isDispose => _isDispose;
}
