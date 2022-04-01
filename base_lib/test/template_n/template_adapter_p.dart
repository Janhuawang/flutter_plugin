import 'package:base_lib/mvp.dart';

import 'template_adapter_m.dart';
import 'template_adapter_state.dart';

/*
 * 展示层
 */
abstract class TemplateAdapterV extends NV {}

/*
 * 数据层
 */
abstract class TemplateAdapterM extends NM {
  Future<TemplateDataModel> loadData(String id);
}

/*
 * 控制层
 */
abstract class TemplateAdapterP
    extends NP<TemplateAdapterV, TemplateAdapterM, TemplateDataModel> {
  Future<void> loadData();

  List<MessageData> getMessageList();

}

/*
 * 不同平台适配模版 - 控制实现层
 * todo 描述与注意，声明名字也可。
 */
class TemplateAdapterPImp extends TemplateAdapterP {
  late String _id;

  @override
  BaseModel? createModel() {
    return TemplateAdapterMImp();
  }

  @override
  BaseView getView() {
    return super.getView()!;
  }

  @override
  TemplateAdapterMImp getModel() {
    return super.getModel() as TemplateAdapterMImp;
  }

  @override
  TemplateDataModel? getStateModel() {
    return super.getStateModel() as TemplateDataModel;
  }

  @override
  void setPageArguments(Map<String, dynamic> arguments) {
    super.setPageArguments(arguments);
    _id = arguments["id"];
  }

  @override
  List<MessageData> getMessageList() {
    return getStateModel()?.messageList ?? [];
  }

  @override
  Future<void> loadData() async {
    setStateModel(await getModel().loadData(this._id));
    getView().updateState();
  }
}
