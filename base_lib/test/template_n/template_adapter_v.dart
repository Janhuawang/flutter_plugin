import 'package:base_lib/mvp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'template_adapter_p.dart';
import 'template_adapter_page.dart';
import 'template_adapter_state.dart';

/*
 * 不同平台适配模版 - View实现层
 * todo 描述与注意，声明名字也可。
 */
class TemplateAdapterVImp
    extends NAdapterState<TemplateAdapterP, TemplateAdapterWidget>
    implements TemplateAdapterV {
  Map<String, dynamic> arguments;

  TemplateAdapterVImp(this.arguments);

  @override
  TemplateAdapterP createPresenter() {
    return TemplateAdapterPImp();
  }

  @override
  void initData() {
    super.initData();
    presenter.setPageArguments(this.arguments);
  }

  @override
  void loadData() async {
    super.loadData();
    await presenter.loadData();
  }

  @override
  Widget buildPlatform(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView.builder(
        itemBuilder: getItem,
        itemCount: getItemCount(),
      ),
    );
  }

  /// 列表适配widget
  Widget getItem(BuildContext context, int index) {
    MessageData messageData = presenter.getMessageList()[index];
    return Padding(
      padding: EdgeInsets.symmetric(vertical: toRpx(10), horizontal: toRpx(16)),
      child: Text(
        messageData.messageTitle ?? "",
        style: TextStyle(color: Colors.black87, fontSize: toRpx(16)),
      ),
    );
  }

  /// 列表数据量
  int getItemCount() {
    return presenter.getMessageList().length ?? 0;
  }
}
