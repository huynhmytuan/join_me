import 'package:flutter/material.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/data/models/models.dart';
import 'package:join_me/user/cubit/send_user_message_cubit.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:join_me/widgets/avatar_circle_widget.dart';

class NewConversationDialog extends StatefulWidget {
  const NewConversationDialog({
    required this.receiver,
    required this.sendUserMessageCubit,
    required this.onSend,
    Key? key,
  }) : super(key: key);
  final AppUser receiver;
  final SendUserMessageCubit sendUserMessageCubit;
  final Function(String messageContent) onSend;

  @override
  State<NewConversationDialog> createState() => _NewConversationDialogState();
}

class _NewConversationDialogState extends State<NewConversationDialog> {
  final _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: kBorderRadiusShape,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'New Message',
              textAlign: TextAlign.center,
              style: CustomTextStyle.heading4(context),
            ),
            const SizedBox(
              height: 10,
            ),
            CircleAvatarWidget(
              imageUrl: widget.receiver.photoUrl,
              size: 40,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              widget.receiver.name,
              textAlign: TextAlign.center,
              style: CustomTextStyle.heading3(context),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 100,
              padding: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  width: .2,
                ),
              ),
              child: TextField(
                controller: _textEditingController,
                autofocus: true,
                maxLines: null,
                textInputAction: TextInputAction.newline,
                onChanged: (value) => setState(() {}),
                decoration: const InputDecoration(
                  hintText: 'Message...',
                  border: InputBorder.none,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: kTextColorGrey),
                  ),
                ),
                TextButton(
                  onPressed: _textEditingController.text.isEmpty
                      ? null
                      : () {
                          Navigator.of(context).pop();
                          widget.onSend(_textEditingController.text);
                        },
                  child: const Text(
                    'Send',
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
