import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final Color? backgroundColor;
  final PreferredSizeWidget? bottom;
  final Color? iconColor;
  final List<Widget> actions;
  final Widget? leading;

  const CustomAppBar({
    super.key,
    this.actions = const [],
    this.backgroundColor,
    this.title,
    this.bottom,
    this.leading,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    if (actions.isNotEmpty) {
      actions.last = Padding(
          padding: const EdgeInsets.only(right: 24), child: actions.last);
    }
    return AppBar(
      titleSpacing: 24,
      leading: leading,
      elevation: 0,
      iconTheme: IconThemeData(
          color: iconColor,
      ),
      centerTitle: true,
      title: title,
      actions: actions,
      backgroundColor: backgroundColor,
    );
  }

  @override
  Size get preferredSize {
    double height = kToolbarHeight; // 기존 appbar에서 사용했을 높이
    if (bottom != null) {
      height += bottom!.preferredSize.height; // bottom 위젯의 높이 추가
    }
    return Size.fromHeight(height);
  }

}
