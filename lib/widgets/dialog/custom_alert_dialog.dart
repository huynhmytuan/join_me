import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/generated/locale_keys.g.dart';
import 'package:join_me/utilities/constant.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({
    required this.title,
    required this.content,
    this.cancelLabel,
    this.submitLabel,
    this.submitButtonColor,
    required this.onCancel,
    required this.onSubmit,
    Key? key,
  }) : super(key: key);
  final String title;
  final String content;
  final String? submitLabel;
  final String? cancelLabel;
  final Function() onCancel;
  final Function() onSubmit;
  final Color? submitButtonColor;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: CustomTextStyle.heading2(context),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 5),
          Text(
            content,
          ),
        ],
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: onCancel,
              child: Text(
                cancelLabel ?? LocaleKeys.button_cancel.tr(),
                style: const TextStyle(
                  color: kTextColorGrey,
                ),
              ),
            ),
            const SizedBox(
              width: kDefaultPadding,
            ),
            TextButton(
              onPressed: onSubmit,
              child: Text(
                submitLabel ?? LocaleKeys.button_done.tr(),
                style: CustomTextStyle.heading3(context).copyWith(
                  color: submitButtonColor ?? Theme.of(context).primaryColor,
                ),
              ),
            )
          ],
        ),
      ],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(kDefaultRadius),
        ),
      ),
    );
  }
}
