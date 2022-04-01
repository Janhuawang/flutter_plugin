export 'package:base_lib/src/http/http_request.dart';
export 'package:base_lib/src/http/http_result.dart';
export 'package:base_lib/src/oss/aliyun_oss.dart';

/*
 * 需要提前配置参数
 */
class HttpClient {
  static String? domain;
  static int? sendTimeout;
  static int? receiveTimeout;

  static void setConfig(String baseUrl,
      {int? sendTimeout = 10000, int? receiveTimeout = 60000}) {
    HttpClient.domain = baseUrl;
    HttpClient.sendTimeout = sendTimeout;
    HttpClient.receiveTimeout = receiveTimeout;
  }

  static Map<dynamic, dynamic>? headers;

  static void setHeaders(Map<dynamic, dynamic> headers) {
    HttpClient.headers = headers;
  }
}
