import 'package:flutter/material.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/data/dummy_data.dart' as dummy_data;
import 'package:join_me/data/models/models.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:join_me/widgets/widgets.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    required this.message,
    required this.isGroupMessage,
    Key? key,
  }) : super(key: key);
  final Message message;
  final bool isGroupMessage;
  @override
  Widget build(BuildContext context) {
    const currentUser = dummy_data.currentUser;
    final author =
        dummy_data.usersData.firstWhere((user) => user.id == message.authorId);
    final isSender = currentUser.id == author.id;
    return Row(
      mainAxisAlignment:
          isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Stack(
          children: [
            if (!isGroupMessage && !isSender)
              Positioned(
                left: 5,
                bottom: 1,
                child: CircleAvatarWidget(
                  imageUrl: author.photoUrl,
                  size: 25,
                ),
              ),
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * .75,
              ),
              margin: const EdgeInsets.only(right: 10, left: 40, top: 8),
              padding: const EdgeInsets.all(kDefaultPadding / 2),
              decoration: BoxDecoration(
                color: isSender
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(kDefaultRadius),
                boxShadow: [kDefaultBoxShadow],
              ),
              child: Text(
                message.content,
                style: TextStyle(
                  color: isSender ? Colors.white : null,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
