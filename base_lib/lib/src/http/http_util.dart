import 'package:base_lib/src/util/print.dart';
import 'package:dio/dio.dart';

class HttpTools {
  /*
   * 打印curl
   */
  static void printDio2curl(RequestOptions requestOption) {
    var curl = '';

    // Add PATH + REQUEST_METHOD
    curl += 'curl --request ${requestOption.method} \'${requestOption.uri}\'';

    // Include headers
    for (var key in requestOption.headers.keys) {
      curl += ' -H \'$key: ${requestOption.headers[key]}\'';
    }

    // Include data if there is data
    if (requestOption.data != null) {
      curl += ' --data-binary \'${requestOption.data}\'';
    }

    curl += ' --insecure'; //bypass https verification

    PrintTools.printLog(
        "\n================== 请求curl地址 ==========================");
    PrintTools.printLog("===Start  ${curl}  ===End");
  }
}
