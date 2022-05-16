import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:join_me/config/router/router.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/data/dummy_data.dart' as dummy_data;
import 'package:join_me/data/models/models.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:timeago/timeago.dart' as timeago;

class ConversationCard extends StatelessWidget {
  const ConversationCard({
    required this.conversation,
    Key? key,
  }) : super(key: key);
  final Conversation conversation;

  @override
  Widget build(BuildContext context) {
    //Get current user
    const _user = dummy_data.currentUser;
    final sender = dummy_data.usersData.firstWhere(
      (user) =>
          user.id == (conversation.members.firstWhere((u) => u != _user.id)),
    );
    final sortedMessage = dummy_data.messagesData
        .where((element) => element.conversationId == conversation.id)
        .toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    final lastMessage = sortedMessage.isEmpty ? null : sortedMessage.first;

    return InkWell(
      onTap: () {
        AutoRouter.of(context).push(ChatRoute(conversationId: conversation.id));
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: CachedNetworkImage(
                imageUrl: sender.photoUrl,
                errorWidget: (context, url, dynamic error) =>
                    const Icon(Icons.error),
                fit: BoxFit.cover,
                height: 50,
                width: 50,
              ),
            ),
            const SizedBox(width: kDefaultPadding),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sender.name,
                    style: CustomTextStyle.bodyLarge(context),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    lastMessage == null
                        ? 'Say something to ${sender.name}'
                        : lastMessage.content,
                    style: CustomTextStyle.bodySmall(context)
                        .copyWith(color: kTextColorGrey),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            //Check message is read and fill
            if (lastMessage != null)
              Text(
                timeago.format(lastMessage.createdAt),
                style: CustomTextStyle.subText(context),
              ),
          ],
        ),
      ),
    );
  }
}
