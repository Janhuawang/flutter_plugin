import 'dart:convert';
import 'dart:convert' as convert;

import 'util/string.dart';


/*
 * 数据格式转换
 */
abstract class Json {
  void fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toMap();
}

/*
 * Json 数据转换工具
 */
class JsonTools {
  static String objToJson(Object object) {
    // map
    return object == null ? "" : convert.jsonEncode(object);
  }

  static dynamic jsonToObj(String jsonStr) {
    return StringTools.isBlank(jsonStr) ? null : JsonCodec().decode(jsonStr);
  }
}
