import 'package:flutter/material.dart';
import 'package:join_me/config/theme.dart';

class CountBadge extends StatelessWidget {
  const CountBadge({required this.count, this.size, Key? key})
      : super(key: key);
  final int count;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size ?? 20,
      width: size ?? 20,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
      child: FittedBox(
        child: Text(
          count > 99 ? '99+' : count.toString(),
          style:
              CustomTextStyle.heading4(context).copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
