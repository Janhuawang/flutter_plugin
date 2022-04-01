import 'package:base_lib/mvp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'template_adapter_v.dart';

/*
 * 不同平台适配模版 - 入口页
 * todo 描述与注意，声明名字也可。
 */
class TemplateAdapterPage extends StatelessWidget {
  Map<String, dynamic> params;

  TemplateAdapterPage(this.params);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TemplateAdapterWidget(this.params),
    );
  }
}

class TemplateAdapterWidget extends NAdapterWidget {
  Map<String, dynamic> arguments;

  TemplateAdapterWidget(this.arguments);

  @override
  State<StatefulWidget> createState() {
    return new TemplateAdapterVImp(this.arguments);
  }
}
