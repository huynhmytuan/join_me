import 'package:flutter/material.dart';
import 'package:join_me/utilities/constant.dart';

class RoundedContainer extends StatelessWidget {
  const RoundedContainer({
    this.color,
    this.padding,
    this.margin,
    this.child,
    this.width,
    this.height,
    Key? key,
  }) : super(key: key);
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? color;
  final Widget? child;

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(kDefaultRadius),
      ),
      child: child,
    );
  }
}
