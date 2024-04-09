import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget? body;

  const CustomScaffold({super.key,
    this.appBar,
    this.body,});

  @override
  Widget build(BuildContext context) {
    return SelectionArea(child: Scaffold(body: body, appBar: appBar,));
  }
}
