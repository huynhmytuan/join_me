import 'package:flutter/material.dart';

import 'package:join_me/utilities/constant.dart';

class RoundedIconButton extends StatelessWidget {
  const RoundedIconButton({
    required this.icon,
    required this.onTap,
    this.backgroundColor,
    Key? key,
  }) : super(key: key);
  final Icon icon;
  final Function() onTap;
  final Color? backgroundColor;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kDefaultRadius),
            color: backgroundColor ?? Colors.white.withOpacity(.4),
          ),
          child: icon,
        ),
      ),
    );
  }
}
