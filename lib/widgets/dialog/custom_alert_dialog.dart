import 'package:flutter/material.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/utilities/constant.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({
    required this.title,
    required this.content,
    this.cancelLabel = 'Cancel',
    this.submitLabel = 'Submit',
    this.submitButtonColor,
    required this.onCancel,
    required this.onSubmit,
    Key? key,
  }) : super(key: key);
  final String title;
  final String content;
  final String submitLabel;
  final String cancelLabel;
  final VoidCallback onCancel;
  final VoidCallback onSubmit;
  final Color? submitButtonColor;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Text(
        title,
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 5),
          Text(
            content,
            textAlign: TextAlign.center,
            style: CustomTextStyle.bodyMedium(context),
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
                cancelLabel,
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
                submitLabel,
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
