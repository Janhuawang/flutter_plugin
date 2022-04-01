import 'package:base_lib/mvp.dart';

/*
 * 不同平台适配模版 - 数据模型
 * todo 描述与注意，声明名字也可。
 */
class TemplateDataModel extends NDataModel {
  List<MessageData>? messageList;

  @override
  void fromJson(Map<String, dynamic> json) {
    List list = json["list"];
    messageList = mapListToObjs(list, (e) {
      MessageData messageData = new MessageData();
      messageData.fromJson(e);
      return messageData;
    });
  }

  @override
  Map<String, dynamic> toMap() {
    return {};
  }
}

/*
 *消息数据
 */
class MessageData with IState {
  String? messageTitle;

  String? messageContent;

  @override
  void fromJson(Map<String, dynamic> json) {
    messageTitle = json["title"];
    messageContent = json["content"];
  }

  @override
  Map<String, dynamic> toMap() {
    return {};
  }
}
