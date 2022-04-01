import 'package:base_lib/http.dart';

/*
 * Api 定义类
 */
class HttpApi {
  static String getBaseUrl() {
    // todo 域名
    return "https://github.com";
  }

  /// todo 业务接口
  static final getTemplateState = RequestApi(
    HttpApi.getBaseUrl() + "/v1/template/data",
    Method.GET,
  );

  static final getTemplateState2 = RequestApi(
    HttpApi.getBaseUrl() + "/v1/template/data2",
    Method.GET,
  );
}
