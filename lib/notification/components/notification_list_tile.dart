import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:join_me/config/router/app_router.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/data/models/notification.dart';
import 'package:join_me/notification/bloc/notification_bloc.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:join_me/widgets/avatar_circle_widget.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationListTile extends StatelessWidget {
  const NotificationListTile({required this.notificationViewModel, Key? key})
      : super(key: key);
  final NotificationViewModel notificationViewModel;

  void _onTapHandle(
    NotificationViewModel notificationViewModel,
    BuildContext context,
  ) {
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
    Widget notificationCard;
    if (notificationViewModel.notificationData.notificationType ==
        NotificationType.invite) {
      notificationCard =
          _InviteCard(notificationViewModel: notificationViewModel);
    } else {
      notificationCard = ListTile(
        onTap: () => _onTapHandle(notificationViewModel, context),
        leading: CircleAvatarWidget(
          imageUrl: notificationViewModel.actor.photoUrl,
          size: 60,
          overlay: _buildOverLay(notificationViewModel),
        ),
        title: getTitle(notificationViewModel, context),
        subtitle: getSubTile(notificationViewModel, context),
      );
    }
    return notificationCard;
  }

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
        text = ' liked your post.';
        break;
      case NotificationType.likeComment:
        text = ' liked your comment:';
        break;
      case NotificationType.comment:
        text = '  comment your post';
        break;
      case NotificationType.invite:
        text = ' has invited you to project: ';
        targetName = TextSpan(
          text: notificationViewModel.project!.name,
          style: CustomTextStyle.heading3(context),
        );
        break;

      case NotificationType.assign:
        text = ' assign you a task: ';
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

class _InviteCard extends StatelessWidget {
  const _InviteCard({required this.notificationViewModel, Key? key})
      : super(key: key);
  final NotificationViewModel notificationViewModel;
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
