import 'package:base_lib/mvp.dart';
import 'package:flutter/material.dart';

abstract class StatelessBase extends StatelessWidget with AdapterWidget {
  @override
  Widget build(BuildContext context) {
    return buildAdapter(context);
  }
}

abstract class StateBase<T extends StatefulWidget> extends State<T>
    with AdapterWidget {
  @override
  Widget build(BuildContext context) {
    return buildAdapter(context);
  }
}
