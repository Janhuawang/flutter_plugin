import 'package:base_lib/src/util/print.dart';
import 'package:base_lib/src/util/toast.dart';
import 'package:dio/dio.dart';

import 'http_abstract.dart';
import 'http_request.dart';
import 'http_result.dart';
import 'http_util.dart';

/*
 * dio实现
 */
class HttpDio extends HttpAbstract {
  factory HttpDio() => getInstance();
  static HttpDio? _instance;

  static HttpDio getInstance() {
    if (_instance == null) {
      _instance = new HttpDio.internal();
    }
    return _instance!;
  }

  final Dio dio = new Dio();

  Options? options;
  String? baseUrl;
  IProgressCallback? sendProgress;
  IProgressCallback? receiveProgress;

  HttpDio.internal() {
    options = new Options();
  }

  @override
  void addInterceptors() {
    dio.interceptors.add(InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
      HttpTools.printDio2curl(options);
      PrintTools.printLog(
          "\n================== 请求数据 ==========================");
      PrintTools.printLog("url = ${options.uri.toString()}");
      PrintTools.printLog("headers = ${options.headers}");
      PrintTools.printLog("params = ${options.data}");
      return handler.next(options);
    }, onResponse: (Response response, ResponseInterceptorHandler handler) {
      PrintTools.printLog(
          "\n================== 响应数据 ==========================");
      PrintTools.printLog("code = ${response.statusCode}");
      PrintTools.printLog("headers = ${response.headers}");
      PrintTools.printLog("data = ${response.data}");
      PrintTools.printLog("\n");
      return handler.next(response);
    }, onError: (DioError e, ErrorInterceptorHandler handler) {
      PrintTools.printLog("\n================== 错误响应数据 ======================");
      PrintTools.printLog("type = ${e.type}");
      PrintTools.printLog("message = ${e.message}");
      PrintTools.printLog("\n");
      return handler.next(e);
    }));
  }

  @override
  void removeInterceptors() {
    // TODO: implement removeInterceptors
  }

  @override
  void setReceiveTimeout(int? receiveTimeout) {
    if (options != null) {
      options?.receiveTimeout = receiveTimeout;
    }
  }

  @override
  void setSendTimeout(int? sendTimeout) {
    if (options != null) {
      options?.sendTimeout = sendTimeout;
    }
  }

  @override
  void setHeaders(Map<String, dynamic>? headers) {
    if (options != null) {
      options?.headers = headers;
    }
  }

  ///设置代理
  void setupProxy() async {
    // final settings = await FlutterProxy.proxySetting;
    // bool enabled = settings.enabled;
    // String proxySetting = 'PROXY ${settings.host}:${settings.port}';
    // if (enabled) {
    //   (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //       (client) {
    //     client.findProxy = (uri) {
    //       PrintTools.printLog("proxySetting===:" + proxySetting);
    //       return proxySetting;
    //     };
    //     client.badCertificateCallback =
    //         (X509Certificate cert, String host, int port) => true;
    //   };
    // }
  }

  @override
  Future<ResultData> get(String? url, Map<String, dynamic>? body) async {
    try {
      var response = await dio.get(url ?? "",
          queryParameters: body,
          options: options,
          onReceiveProgress: receiveProgress);

      return handlerResponse(response, null);
    } on DioError catch (e) {
      return handlerResponse(e.response, e);
    }
  }

  @override
  Future<ResultData> post(String? url, Map<String, dynamic>? body) async {
    try {
      var response = await dio.post(url ?? "",
          queryParameters: body,
          options: options,
          onSendProgress: sendProgress,
          onReceiveProgress: receiveProgress);

      return handlerResponse(response, null);
    } on DioError catch (e) {
      return handlerResponse(e.response, e);
    }
  }

  @override
  Future<ResultData> postN(String? url, dynamic? body) async {
    try {
      var response = await dio.post(url ?? "",
          data: body,
          options: options,
          onSendProgress: sendProgress,
          onReceiveProgress: receiveProgress);

      return handlerResponse(response, null);
    } on DioError catch (e) {
      return handlerResponse(e.response, e);
    }
  }

  @override
  void setBaseUrl(String? url) {
    this.baseUrl = url ?? "";
  }

  @override
  void setContentType(String? contentType) {
    if (options != null) {
      options?.contentType = contentType ?? Headers.jsonContentType;
    }
  }

  /*
   * 处理数据响应
   */
  Future<ResultData> handlerResponse(Response? response, DioError? dioError) {
    ResultData? resultData;

    if (response != null && response.data != null) {
      if (response.statusCode == 200) {
        Map<String, dynamic> checkMap = response.data;
        if (checkMap != null && "0" != checkMap["code"].toString()) {
          // Channel.getInstance().toast("接口错误日志：${checkMap["msg"].toString()}");
        }

        resultData = new ResultData(response.data);
      } else {
        if (response.data is Map) {
          // 打印 {timestamp: 2020-10-30 15:51:16, status: 404, error: Not Found, message: No message available, path: /uc/v1/user/infod}
          // Channel.getInstance().toast("接口错误日志：${response.data?.toString()}");

          resultData = new ResultData(response.data,
              code: response.data["status"],
              msg: response.data["message"],
              headers: response.headers);
        }
      }
    } else {
      if (dioError != null) {
        // 一般是本地api用到的问题或域名有问题 Unsupported scheme 'httpd' in URI httpd://dev.esread.com/uc/v1/user/infod}
        ToastTools.toast("请检查您的网络！");

        if (dioError.error is int && dioError.response != null) {
          resultData = new ResultData(dioError.response?.data,
              code: dioError.error,
              msg: dioError.message,
              headers: dioError.response?.headers);
        }
      }
    }

    if (resultData == null) {
      resultData = new ResultData(null, code: Code.NETWORK_REQUEST);
    }

    PrintTools.printLog("resultData = ${resultData.toString()}");

    return Future.value(resultData);
  }

  @override
  void addSendProgressCallback(sendCallback) {
    this.sendProgress = sendCallback;
  }

  @override
  void addReceiveProgressCallback(receiveCallback) {
    this.receiveProgress = receiveCallback;
  }
}
