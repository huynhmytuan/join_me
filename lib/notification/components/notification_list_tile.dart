import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:join_me/config/router/app_router.dart';
import 'package:join_me/config/theme.dart';

import 'package:join_me/data/models/notification.dart';
import 'package:join_me/generated/locale_keys.g.dart';
import 'package:join_me/notification/bloc/notification_bloc.dart';

import 'package:join_me/project/bloc/project_overview_bloc.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:join_me/widgets/widgets.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationListTile extends StatelessWidget {
  const NotificationListTile({required this.notificationViewModel, Key? key})
      : super(key: key);
  final NotificationViewModel notificationViewModel;

  void _onTapHandle(
    NotificationViewModel notificationViewModel,
    BuildContext context,
  ) {
    if (!notificationViewModel.notificationData.isRead) {
      context.read<NotificationBloc>().add(
            MarkAsRead(
              notificationViewModel.notificationData.id,
              notificationViewModel.notificationData.notifierId,
            ),
          );
    }
    switch (notificationViewModel.notificationData.notificationType) {
      case NotificationType.likePost:
        AutoRouter.of(context).push(
          PostDetailRoute(
            postId: notificationViewModel.notificationData.targetId,
          ),
        );
        break;
      case NotificationType.likeComment:
        AutoRouter.of(context).push(
          PostDetailRoute(
            postId:
                notificationViewModel.notificationData.targetId.split('/')[0],
          ),
        );
        break;
      case NotificationType.comment:
        AutoRouter.of(context).push(
          PostDetailRoute(
            postId:
                notificationViewModel.notificationData.targetId.split('/')[0],
          ),
        );
        break;
      case NotificationType.invite:
        AutoRouter.of(context).push(
          SingleProjectRoute(
            projectId: notificationViewModel.notificationData.targetId,
          ),
        );
        break;

      case NotificationType.assign:
        AutoRouter.of(context).push(
          SingleTaskRoute(
            taskId: notificationViewModel.notificationData.targetId,
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      color: notificationViewModel.notificationData.isRead
          ? null
          : Theme.of(context).primaryColor.withOpacity(.1),
      child: Dismissible(
        key: Key(notificationViewModel.notificationData.id),
        onDismissed: (direction) {
          if (direction == DismissDirection.endToStart) {
            context.read<NotificationBloc>().add(
                  DeleteNotification(notificationViewModel.notificationData),
                );
          }
        },
        background: _buildSwipeActionLeft(),
        secondaryBackground: _buildSwipeActionRight(),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            if (!notificationViewModel.notificationData.isRead) {
              context.read<NotificationBloc>().add(
                    MarkAsRead(
                      notificationViewModel.notificationData.id,
                      notificationViewModel.notificationData.notifierId,
                    ),
                  );
            }
            return false;
          } else {
            return true;
          }
        },
        child: Column(
          children: [
            ListTile(
              onTap: () => _onTapHandle(notificationViewModel, context),
              leading: CircleAvatarWidget(
                imageUrl: notificationViewModel.actor.photoUrl,
                size: 60,
                overlay: _buildOverLay(notificationViewModel),
              ),
              title: getTitle(notificationViewModel, context),
              subtitle: getSubTile(notificationViewModel, context),
            ),
            if (notificationViewModel.notificationData.notificationType ==
                NotificationType.invite)
              _InvitationActions(notificationViewModel: notificationViewModel)
          ],
        ),
      ),
    );
  }

  Widget _buildSwipeActionLeft() => Container(
        alignment: Alignment.centerLeft,
        color: kSecondaryGreen,
        padding: const EdgeInsets.all(20),
        child: const Icon(
          Ionicons.eye,
          color: Colors.white,
        ),
      );
  Widget _buildSwipeActionRight() => Container(
        alignment: Alignment.centerRight,
        color: kSecondaryRed,
        padding: const EdgeInsets.all(20),
        child: const Icon(
          Ionicons.close_circle,
          color: Colors.white,
        ),
      );

  Widget _buildOverLay(
    NotificationViewModel notificationViewModel,
  ) {
    var iconData = Icons.abc;
    var color = Colors.white;
    switch (notificationViewModel.notificationData.notificationType) {
      case NotificationType.likePost:
        iconData = Ionicons.heart;
        color = kSecondaryRed;
        break;
      case NotificationType.likeComment:
        iconData = Ionicons.heart;
        color = kSecondaryRed;
        break;
      case NotificationType.comment:
        iconData = Ionicons.chatbubble;
        color = kSecondaryGreen;
        break;
      case NotificationType.invite:
        iconData = Ionicons.people;
        color = kSecondaryBlue;
        break;
      case NotificationType.assign:
        iconData = Ionicons.book;
        color = kSecondaryYellow;
        break;
    }
    return Container(
      alignment: Alignment.bottomRight,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Icon(
          iconData,
          color: Colors.white,
          size: 15,
        ),
      ),
    );
  }

  Widget getTitle(
    NotificationViewModel notificationViewModel,
    BuildContext context,
  ) {
    var text = '';
    TextSpan? targetName;
    switch (notificationViewModel.notificationData.notificationType) {
      case NotificationType.likePost:
        text = LocaleKeys.notifications_likePost.tr();
        break;
      case NotificationType.likeComment:
        text = LocaleKeys.notifications_likeComment.tr();
        break;
      case NotificationType.comment:
        text = LocaleKeys.notifications_comment.tr();
        break;
      case NotificationType.invite:
        text = LocaleKeys.notifications_invite.tr();
        targetName = TextSpan(
          text: notificationViewModel.project!.name,
          style: CustomTextStyle.heading3(context),
        );
        break;

      case NotificationType.assign:
        text = LocaleKeys.notifications_assign.tr();
        targetName = TextSpan(
          text: notificationViewModel.task!.name,
          style: CustomTextStyle.heading3(context),
        );
        break;
    }
    return Text.rich(
      TextSpan(
        children: <InlineSpan>[
          TextSpan(
            text: notificationViewModel.actor.name,
            style: CustomTextStyle.heading3(context),
          ),
          TextSpan(
            text: text,
          ),
          if (targetName != null) targetName
        ],
      ),
    );
  }

  Widget getSubTile(
    NotificationViewModel notificationViewModel,
    BuildContext context,
  ) {
    final appLocale = Localizations.localeOf(context);
    var text = '';
    if (notificationViewModel.notificationData.notificationType ==
            NotificationType.likeComment ||
        notificationViewModel.notificationData.notificationType ==
            NotificationType.comment) {
      text = ' - "${notificationViewModel.comment!.content}"';
    }
    return Text.rich(
      TextSpan(
        children: <InlineSpan>[
          TextSpan(
            text: timeago.format(
              notificationViewModel.notificationData.createdAt,
              locale: appLocale.languageCode,
            ),
            style: CustomTextStyle.subText(context),
          ),
          TextSpan(
            text: text,
            style: CustomTextStyle.subText(context),
          ),
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _InvitationActions extends StatelessWidget {
  const _InvitationActions({
    required this.notificationViewModel,
    Key? key,
  }) : super(key: key);

  final NotificationViewModel notificationViewModel;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        RoundedButton(
          minWidth: 150,
          onPressed: () {
            context.read<NotificationBloc>().add(
                  DeleteNotification(notificationViewModel.notificationData),
                );
          },
          color: kIconColorGrey,
          elevation: 0,
          height: 30,
          child: Text(
            LocaleKeys.button_request_decline.tr(),
            style: const TextStyle(color: Colors.black),
          ),
        ),
        RoundedButton(
          minWidth: 150,
          onPressed: () {
            //Check if user already join the project
            if (!notificationViewModel.project!.members.contains(
              notificationViewModel.notificationData.notifierId,
            )) {
              context.read<ProjectOverviewBloc>().add(
                    AddUserToProject(
                      notificationViewModel.project!,
                      notificationViewModel.notificationData.notifierId,
                    ),
                  );
            }
            context.read<NotificationBloc>().add(
                  DeleteNotification(notificationViewModel.notificationData),
                );
          },
          elevation: 0,
          height: 30,
          child: Text(LocaleKeys.button_request_accept.tr()),
        ),
      ],
    );
  }
}
