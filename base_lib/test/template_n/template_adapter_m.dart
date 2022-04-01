import 'package:base_lib/http.dart';

import '../network/api.dart';
import 'template_adapter_p.dart';
import 'template_adapter_state.dart';

/*
 * 不同平台适配模版 - 数据请求层
 * todo 描述与注意，声明名字也可。
 */
class TemplateAdapterMImp implements TemplateAdapterM {
  @override
  Future<TemplateDataModel> loadData(String id) async {
    ResultData resultData =
        await new Request().request(HttpApi.getTemplateState, {"id": id});
    TemplateDataModel templateDataModel = new TemplateDataModel();
    templateDataModel.fromJson(resultData.response());
    return templateDataModel;
  }
}
