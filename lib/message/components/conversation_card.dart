import 'package:auto_route/auto_route.dart';

import 'package:flutter/material.dart';
import 'package:join_me/config/router/router.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/data/models/app_user.dart';
import 'package:join_me/message/bloc/conversations_bloc.dart';
import 'package:join_me/message/components/conversation_avatar.dart';
import 'package:join_me/utilities/constant.dart';

import 'package:timeago/timeago.dart' as timeago;

class ConversationCard extends StatelessWidget {
  const ConversationCard({
    required this.conversationViewModel,
    required this.currentUser,
    Key? key,
  }) : super(key: key);
  final ConversationViewModel conversationViewModel;
  final AppUser currentUser;

  @override
  Widget build(BuildContext context) {
    final appLocale = Localizations.localeOf(context);
    final receivers = conversationViewModel.members
      ..removeWhere((user) => user.id == currentUser.id);
    String name;
    if (receivers.length == 1) {
      name = receivers.first.name;
    } else if (receivers.length <= 4) {
      name = conversationViewModel.members
          .map((e) => e.name.split(' ')[0])
          .toList()
          .join(', ');
    } else {
      name = receivers.map((e) => e.name.split(' ')[0]).toList().join(', ');
    }

    return InkWell(
      onTap: () {
        AutoRouter.of(context).push(
          ChatRoute(conversationId: conversationViewModel.conversation.id),
        );
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          children: [
            ConversationAvatar(
              receivers: receivers,
              size: 50,
            ),
            const SizedBox(width: kDefaultPadding),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: CustomTextStyle.bodyLarge(context),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  if (conversationViewModel.lastMessage != null)
                    Text(
                      '${conversationViewModel.lastMessage!.authorId == currentUser.id ? 'You:' : ''} ${conversationViewModel.lastMessage!.content}',
                      style: conversationViewModel.lastMessage!.seenBy
                              .contains(currentUser.id)
                          ? CustomTextStyle.bodySmall(context)
                              .copyWith(color: kTextColorGrey)
                          : CustomTextStyle.heading4(context),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    )
                  else
                    Text(
                      'No message.',
                      style: CustomTextStyle.bodySmall(context)
                          .copyWith(color: kTextColorGrey),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                ],
              ),
            ),
            //Check message is read and fill
            if (conversationViewModel.lastMessage != null)
              (conversationViewModel.lastMessage!.seenBy
                      .contains(currentUser.id))
                  ? Text(
                      timeago.format(
                        conversationViewModel.lastMessage!.createdAt,
                        locale: appLocale.languageCode,
                      ),
                      style: CustomTextStyle.subText(context),
                    )
                  : Container(
                      height: 12,
                      width: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
          ],
        ),
      ),
    );
  }
}
