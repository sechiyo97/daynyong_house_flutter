import 'package:flutter/material.dart';

class RoundedContainer extends StatelessWidget {
  final Color backgroundColor;
  final double radius;
  final Widget child;
  final double? height;
  final double? width;
  final bool roundTopLeft;
  final bool roundTopRight;
  final bool roundBottomLeft;
  final bool roundBottomRight;
  final Alignment? alignment;
  final Color? borderColor;
  final double borderWidth;
  final EdgeInsetsGeometry? padding;
  final List<BoxShadow>? boxShadow;

  const RoundedContainer({
    Key? key,
    this.backgroundColor = Colors.white,
    this.radius = 16,
    this.roundBottomLeft = true,
    this.roundBottomRight = true,
    this.roundTopLeft = true,
    this.roundTopRight = true,
    this.borderWidth = 2.0,
    this.height,
    this.width,
    this.alignment,
    this.borderColor,
    this.padding,
    required this.child,
    this.boxShadow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: boxShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: roundTopLeft ? Radius.circular(radius) : Radius.zero,
          topRight: roundTopRight ? Radius.circular(radius) : Radius.zero,
          bottomLeft: roundBottomLeft ? Radius.circular(radius) : Radius.zero,
          bottomRight: roundBottomRight ? Radius.circular(radius) : Radius.zero,
        ),
        child: Container(
          height: height,
          width: width,
          alignment: alignment,
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: roundTopLeft ? Radius.circular(radius) : Radius.zero,
              topRight: roundTopRight ? Radius.circular(radius) : Radius.zero,
              bottomLeft: roundBottomLeft ? Radius.circular(radius) : Radius.zero,
              bottomRight:
              roundBottomRight ? Radius.circular(radius) : Radius.zero,
            ),
            color: backgroundColor, // 배경색 설정
            border: Border.all(
              color: borderColor ?? backgroundColor,
              width: borderWidth,
            ),
          ),
          child: child,
        ),
      ),);
  }
}
