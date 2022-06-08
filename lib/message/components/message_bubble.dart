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
    this.onTap,
    Key? key,
  }) : super(key: key);
  final Message message;
  final AppUser author;
  final bool isNotFirstMessage;
  final bool isNotLastMessage;
  final bool isSender;
  final bool isGroupChat;
  final Function()? onTap;

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
                      boxShadow: [kDefaultBoxShadow],
                    ),
                    child: GestureDetector(
                      onTap: onTap,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding / 2,
                          vertical: 5,
                        ),
                        child: Text(
                          message.content,
                          style: TextStyle(
                            color: isSender ? Colors.white : null,
                          ),
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
