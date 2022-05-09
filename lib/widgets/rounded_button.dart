import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    required this.child,
    required this.onPressed,
    this.height,
    this.minWidth,
    this.color,
    Key? key,
  }) : super(key: key);
  final Widget child;
  final VoidCallback? onPressed;
  final double? minWidth;
  final double? height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: minWidth ?? 180,
      height: height ?? 44,
      color: color ?? Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      // textColor: Colors.white,
      onPressed: onPressed,
      child: child,
    );
  }
}
