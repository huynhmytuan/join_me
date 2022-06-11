import 'package:flutter/material.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/data/models/models.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:join_me/widgets/widgets.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    required this.message,
    required this.author,
    required this.isNotFirstMessage,
    required this.isNotLastMessage,
    required this.isSender,
    required this.isGroupChat,
    required this.isSelected,
    this.onTap,
    this.onLongPress,
    Key? key,
  }) : super(key: key);
  final Message message;
  final AppUser author;
  final bool isNotFirstMessage;
  final bool isNotLastMessage;
  final bool isSender;
  final bool isGroupChat;
  final Function()? onTap;
  final Function()? onLongPress;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Stack(
          children: [
            if (!isNotLastMessage && !isSender)
              Positioned(
                left: 5,
                bottom: 1,
                child: CircleAvatarWidget(
                  imageUrl: author.photoUrl,
                  size: 25,
                ),
              ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isNotFirstMessage && isGroupChat && !isSender)
                  Padding(
                    padding: const EdgeInsets.only(left: 45),
                    child: Text(
                      author.name.split(' ')[0],
                      style: CustomTextStyle.subText(context),
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.only(
                    right: 10,
                    left: 40,
                    top: !isNotFirstMessage ? 0 : 8,
                  ),
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * .75,
                    ),
                    decoration: BoxDecoration(
                      color: isSender
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(kDefaultRadius),
                    ),
                    child: GestureDetector(
                      onTap: onTap,
                      onLongPress: onLongPress,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 8,
                        ),
                        child: Text(
                          message.content,
                          textScaleFactor: 1.06,
                          style:
                              TextStyle(color: isSender ? Colors.white : null),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}
