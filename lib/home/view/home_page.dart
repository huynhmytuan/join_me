import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:join_me/app/bloc/app_bloc.dart';
import 'package:join_me/app/cubit/app_message_cubit.dart';
import 'package:join_me/config/router/router.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/generated/locale_keys.g.dart';
import 'package:join_me/message/bloc/conversations_bloc.dart';

import 'package:join_me/notification/bloc/notification_bloc.dart';

import 'package:join_me/project/bloc/project_overview_bloc.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:join_me/widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    final currentUser = context.read<AppBloc>().state.user;
    context.read<ConversationsBloc>().add(FetchConversations(currentUser.id));
    context.read<ProjectOverviewBloc>().add(LoadProjects(currentUser.id));
    context.read<NotificationBloc>().add(LoadNotifications(currentUser.id));
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      final messageData = event.data;
      final targetId = messageData['targetId'] as String;
      if (messageData['type'] as String != 'message') {
        context.read<NotificationBloc>().add(
              MarkAsRead(
                messageData['notificationId'] as String,
                messageData['notifierId'] as String,
              ),
            );
      }
      switch (messageData['type'] as String) {
        case 'message':
          AutoRouter.of(context).push(ChatRoute(conversationId: targetId));
          break;
        case 'likeComment':
          AutoRouter.of(context)
              .push(PostDetailRoute(postId: targetId.split('/')[0]));
          break;
        case 'comment':
          AutoRouter.of(context)
              .push(PostDetailRoute(postId: targetId.split('/')[0]));
          break;
        case 'likePost':
          AutoRouter.of(context).push(PostDetailRoute(postId: targetId));
          break;
        case 'invite':
          AutoRouter.of(context).push(SingleProjectRoute(projectId: targetId));
          break;
        case 'assign':
          AutoRouter.of(context).push(SingleTaskRoute(taskId: targetId));
          break;
        default:
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppMessageCubit, AppMessageState>(
      listener: (context, state) {
        if (state.messageStatus == AppMessageStatus.none) {
          return;
        }
        final message = state.message;
        var iconData = Icons.info_outline;
        Color? backgroundColor;
        if (state.messageStatus == AppMessageStatus.successful) {
          iconData = Icons.check_circle_outline;
          backgroundColor = Theme.of(context).primaryColor;
        }
        if (state.messageStatus == AppMessageStatus.errorMessage) {
          iconData = Icons.error_outline;
          backgroundColor = Theme.of(context).errorColor;
        }
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              backgroundColor: backgroundColor,
              content: Row(
                children: [
                  Icon(
                    iconData,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    message,
                    style: CustomTextStyle.heading4(context).copyWith(
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              behavior: SnackBarBehavior.floating,
            ),
          );
      },
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: AutoTabsScaffold(
          routes: const [
            PostsRoute(),
            MessagesRouter(),
            ProjectsRoute(),
            NotificationRoute(),
            MenuRoute(),
          ],
          bottomNavigationBuilder:
              (BuildContext context, TabsRouter tabsRouter) => _BottomBar(
            tabsRouter: tabsRouter,
          ),
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.tabsRouter, Key? key}) : super(key: key);
  final TabsRouter tabsRouter;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Theme.of(context).cardColor,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedFontSize: 10,
      unselectedFontSize: 10,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: kTextColorGrey,
      currentIndex: tabsRouter.activeIndex,
      onTap: tabsRouter.setActiveIndex,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Ionicons.home_outline),
          activeIcon: const Icon(Ionicons.home),
          label: LocaleKeys.bottomBarLabel_home.tr(),
        ),
        _buildMessageTabIcon(),
        BottomNavigationBarItem(
          icon: const Icon(Ionicons.folder_outline),
          activeIcon: const Icon(Ionicons.folder),
          label: LocaleKeys.bottomBarLabel_project.tr(),
        ),
        _buildNotificationTabIcon(),
        BottomNavigationBarItem(
          icon: const Icon(Ionicons.menu_outline),
          activeIcon: const Icon(Ionicons.menu),
          label: LocaleKeys.bottomBarLabel_menu.tr(),
        )
      ],
    );
  }

  BottomNavigationBarItem _buildMessageTabIcon() {
    final countBadge = Positioned(
      top: -5,
      right: -10,
      child: BlocBuilder<ConversationsBloc, ConversationsState>(
        builder: (context, state) {
          final currentUser = context.read<AppBloc>().state.user;
          if (state.conversations.isNotEmpty) {
            final unseenMessageCount = state.conversations
                .where(
                  (e) =>
                      e.lastMessage != null &&
                      !e.lastMessage!.seenBy.contains(currentUser.id),
                )
                .length;
            if (unseenMessageCount == 0) {
              return const SizedBox.shrink();
            }
            return CountBadge(
              count: unseenMessageCount,
              size: 18,
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
    return BottomNavigationBarItem(
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          const Icon(Ionicons.chatbubbles_outline),
          countBadge,
        ],
      ),
      activeIcon: Stack(
        clipBehavior: Clip.none,
        children: [
          const Icon(Ionicons.chatbubbles),
          countBadge,
        ],
      ),
      label: LocaleKeys.bottomBarLabel_message.tr(),
    );
  }

  BottomNavigationBarItem _buildNotificationTabIcon() {
    final countBadge = Positioned(
      top: -5,
      right: -10,
      child: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state.notifications.isNotEmpty) {
            final unseenNotificationsCount = state.notifications
                .where(
                  (e) => !e.notificationData.isRead,
                )
                .length;
            if (unseenNotificationsCount == 0) {
              return const SizedBox.shrink();
            }
            return CountBadge(
              count: unseenNotificationsCount,
              size: 18,
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
    return BottomNavigationBarItem(
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          const Icon(Ionicons.notifications_outline),
          countBadge,
        ],
      ),
      activeIcon: Stack(
        clipBehavior: Clip.none,
        children: [
          const Icon(Ionicons.notifications),
          countBadge,
        ],
      ),
      label: LocaleKeys.bottomBarLabel_notifications.tr(),
    );
  }
}
