import 'package:flutter/material.dart';
import 'package:join_me/config/theme.dart';

class CountBadge extends StatelessWidget {
  const CountBadge({required this.count, Key? key}) : super(key: key);
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      width: 20,
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
