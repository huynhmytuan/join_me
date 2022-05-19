import 'package:flutter/material.dart';
import 'package:join_me/utilities/constant.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    required this.child,
    required this.onPressed,
    this.height,
    this.minWidth,
    this.color,
    this.elevation,
    this.textColor,
    Key? key,
  }) : super(key: key);
  final Widget child;
  final VoidCallback? onPressed;
  final double? minWidth;
  final double? height;
  final double? elevation;
  final Color? color;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: minWidth ?? 180,
      height: height ?? 44,
      color: color ?? Theme.of(context).primaryColor,
      elevation: elevation ?? 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      disabledColor: kIconColorGrey,
      textColor: textColor ?? Colors.white,
      onPressed: onPressed,
      child: child,
    );
  }
}
