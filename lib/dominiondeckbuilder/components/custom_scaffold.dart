import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Color? backgroundColor;
  final Widget? body;

  const CustomScaffold({super.key,
    this.appBar,
    this.backgroundColor,
    this.body,});

  @override
  Widget build(BuildContext context) {
    return SelectionArea(child: Scaffold(body: body, appBar: appBar,backgroundColor: backgroundColor,));
  }
}
