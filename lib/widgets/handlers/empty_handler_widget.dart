import 'package:flutter/material.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/utilities/constant.dart';

class EmptyHandlerWidget extends StatelessWidget {
  const EmptyHandlerWidget({
    required this.imageHandlerDir,
    this.titleHandler,
    this.textHandler,
    this.size,
    Key? key,
  }) : super(key: key);
  final double? size;
  final String imageHandlerDir;
  final String? titleHandler;
  final String? textHandler;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              imageHandlerDir,
              width: size ?? 60,
            ),
            if (titleHandler != null)
              const SizedBox(
                height: kDefaultPadding,
              ),
            if (titleHandler != null)
              Text(
                titleHandler!,
                textAlign: TextAlign.center,
                style: CustomTextStyle.heading2(context),
              ),
            if (textHandler != null)
              const SizedBox(
                height: 10,
              ),
            if (textHandler != null)
              Text(
                textHandler!,
                textAlign: TextAlign.center,
                style: CustomTextStyle.bodyMedium(context),
              )
          ],
        ),
      ),
    );
  }
}
