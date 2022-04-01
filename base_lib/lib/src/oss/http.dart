part of aliyun_oss_flutter;

var _http = _DioUtils.getInstance();

class _DioUtils {
  static Dio getInstance() {
    if (_instance == null) {
      _instance = Dio(BaseOptions(
        connectTimeout: 1000 * 30,
        receiveTimeout: 1000 * 30,
      ));

      // _instance!.interceptors.add(LogInterceptor(responseBody: true)); // 调试时可以放开
    }

    return _instance!;
  }

  static Dio? _instance;
}
