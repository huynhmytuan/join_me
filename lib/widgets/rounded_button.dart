import 'package:flutter/material.dart';

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
    return Container(
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: color == null
                ? Theme.of(context).primaryColor.withOpacity(0.2)
                : color!.withOpacity(.2),
            blurRadius: height == null ? 30 : height! / 3,
            offset: Offset(0, height == null ? 5 : height! / 8),
          ),
        ],
      ),
      child: MaterialButton(
        minWidth: minWidth ?? 180,
        height: height ?? 44,
        color: color ?? Theme.of(context).primaryColor,
        elevation: elevation ?? 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        textColor: textColor ?? Colors.white,
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
