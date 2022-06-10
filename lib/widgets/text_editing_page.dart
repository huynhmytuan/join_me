import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:join_me/widgets/widgets.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class TextEditingPage extends StatefulWidget {
  const TextEditingPage({
    required this.initialText,
    required this.hintText,
    Key? key,
  }) : super(key: key);
  final String initialText;
  final String hintText;
  @override
  State<TextEditingPage> createState() => _TextEditingPageState();
}

class _TextEditingPageState extends State<TextEditingPage> {
  final textEditController = TextEditingController();
  String get text => textEditController.text;
  @override
  void initState() {
    textEditController.text = widget.initialText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      // ignore: prefer_const_literals_to_create_immutables
      gestures: [
        GestureType.onTap,
      ],
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: Align(
            child: GestureDetector(
              onTap: () {
                log('Tap called');
                if (text.compareTo(widget.initialText) == 0) {
                  AutoRouter.of(context).pop();
                  return;
                }
                showDialog<bool>(
                  useRootNavigator: true,
                  barrierDismissible: true,
                  context: context,
                  builder: (ctx) {
                    log('BUILD DIALOG');
                    return CustomAlertDialog(
                      title: 'Discard all changes?',
                      content: 'Everything which edited will be discard.',
                      submitLabel: 'Discard Changes',
                      submitButtonColor: kSecondaryRed,
                      onCancel: () {
                        AutoRouter.of(ctx).pop(false);
                      },
                      onSubmit: () {
                        AutoRouter.of(ctx).pop(true);
                      },
                    );
                  },
                ).then((value) {
                  if (value != null && value) {
                    AutoRouter.of(context).pop();
                  }
                });
              },
              child: const Text(
                'Cancel',
                textAlign: TextAlign.center,
              ),
            ),
          ),
          title: Text(
            widget.hintText,
            style: CustomTextStyle.heading3(context),
          ),
          actions: [
            TextButton(
              onPressed: text.trim().isEmpty
                  ? null
                  : () {
                      AutoRouter.of(context).pop(text);
                    },
              child: const Text('Save'),
            )
          ],
        ),
        body: Container(
          margin: const EdgeInsets.only(bottom: 40),
          child: Scrollbar(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    TextField(
                      controller: textEditController,
                      autofocus: true,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      maxLines: null,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: widget.hintText,
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    textEditController.dispose();
    super.dispose();
  }
}
