import '../json.dart';

/*
 * data - 基层
 */
mixin IState implements Json {
  Map<String, dynamic> toJson() => toMap();

  List<Map> jsonListToMaps(List<Json> list) {
    return list.map((e) => e.toMap()).toList();
  }

  List<T> mapListToObjs<T>(
      List list, T Function(Map<String, dynamic> e) transform) {
    return list.map((e) => transform.call(e)).toList();
  }

  List<T> dynamicListToStrings<T>(List list, T Function(String e) transform) {
    return list.map((e) => transform.call(e.toString())).toList();
  }

  String toNull() {
    return "Null";
  }
}

/*
 * 数据克隆
 */
mixin Cloneable<T> {
  clone(T? t);
}
