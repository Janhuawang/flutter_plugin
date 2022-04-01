import 'package:dio/dio.dart';

import '../../http.dart';
import 'http_abstract.dart';
import 'http_factory.dart';
import 'http_result.dart';

/*
 * 发送与接受数据的进度监听器
 *
 * count 是已发送/接收的字节的长度
 * total是响应/请求正文的内容长度
 * 注意：响应数据的total需要在头里设置否则为-1,get请求只有响应数据的回调。
 */
typedef IProgressCallback = void Function(int count, int total);
typedef ResultDataCallback = void Function(ResultData resultData);

/*
 * 通信api
 */
enum Method { GET, POST, POST_N }

class RequestApi {
  String url;
  Method method;

  RequestApi(this.url, this.method);
}

/*
 * 请求
 */
class Request {
  HttpAbstract http = HttpFactory.buildHttpDio();
  HttpConfig? _httpConfig;
  IProgressCallback? _sendCallback;
  IProgressCallback? _receiveCallback;
  ResultDataCallback? _resultDataCallback;

  Request(
      {HttpConfig? httpConfig,
      IProgressCallback? sendCallback,
      IProgressCallback? receiveCallback,
      ResultDataCallback? resultDataCallback}) {
    this._httpConfig = httpConfig;
    this._sendCallback = sendCallback;
    this._receiveCallback = receiveCallback;
    init();
  }

  void addCallback(ResultDataCallback resultDataCallback) {
    this._resultDataCallback = resultDataCallback;
  }

  /*
   * 初始化配置
   */
  void init() {
    if (_httpConfig == null) {
      _httpConfig = new HttpConfig();
    }
    http.addInterceptors();
    http.setBaseUrl(_httpConfig?.baseUrl);
    http.setHeaders(_httpConfig?.headers);
    http.setContentType(_httpConfig?.contentType);
    http.setReceiveTimeout(_httpConfig?.receiveTimeout);
    http.setSendTimeout(_httpConfig?.sendTimeout);
    http.setSendTimeout(_httpConfig?.sendTimeout);
    http.addSendProgressCallback(_sendCallback);
    http.addReceiveProgressCallback(_receiveCallback);
    http.setupProxy();
  }

  /*
   * 请求获取ResultData数据
   */
  Future<ResultData> request(RequestApi requestApi, Map<String, dynamic> body,
      {dynamic bodyN}) async {
    if (requestApi != null) {
      switch (requestApi.method) {
        case Method.GET:
          return http.get(requestApi.url, body).then((value) => value);

        case Method.POST:
          return http.post(requestApi.url, body).then((value) => value);

        case Method.POST_N:
          return http
              .postN(requestApi.url, bodyN != null ? bodyN : body)
              .then((value) => value);
      }
    }
    return Future.value(new ResultData(null, code: Code.NETWORK_METHOD))
        .then((value) => value);
  }

  /*
   * 可自定义配置
   */
  void setConfig(HttpConfig httpConfig) {
    this._httpConfig = httpConfig;
  }
}

/*
 * 通信配置
 */
class HttpConfig {
  // 可参考：Headers.jsonContentType
  static const CONTENT_TYPE_JSON = "application/json";
  static const CONTENT_TYPE_FORM = "application/x-www-form-urlencoded";

  String baseUrl = HttpClient.domain ?? "";
  String contentType = Headers.jsonContentType;
  var sendTimeout = HttpClient.sendTimeout;
  var receiveTimeout = HttpClient.receiveTimeout;
  Map<String, dynamic> headers =
      new Map<String, dynamic>.from(HttpClient.headers ?? {});

  HttpConfig();
}
