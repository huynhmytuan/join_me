import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:join_me/app/bloc/app_bloc.dart';
import 'package:join_me/app/cubit/app_message_cubit.dart';
import 'package:join_me/config/router/router.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/message/bloc/conversations_bloc.dart';
import 'package:join_me/message/bloc/messages_bloc.dart';
import 'package:join_me/notification/bloc/notification_bloc.dart';
import 'package:join_me/post/bloc/posts_bloc.dart';
import 'package:join_me/project/bloc/project_overview_bloc.dart';
import 'package:join_me/utilities/constant.dart';

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
                  ),
                ],
              ),
              behavior: SnackBarBehavior.floating,
            ),
          );
      },
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SafeArea(
          child: AutoTabsScaffold(
            routes: const [
              PostsRoute(),
              MessagesRouter(),
              ProjectsRoute(),
              NotificationRoute(),
              MenuRoute(),
            ],
            bottomNavigationBuilder: _buildBottomBar,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, TabsRouter tabsRouter) {
    return BottomNavigationBar(
      backgroundColor: Theme.of(context).cardColor,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedFontSize: 12,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: kTextColorGrey,
      currentIndex: tabsRouter.activeIndex,
      onTap: tabsRouter.setActiveIndex,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Ionicons.home_outline),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Ionicons.paper_plane_outline),
          label: 'Message',
        ),
        BottomNavigationBarItem(
          icon: Icon(Ionicons.folder_outline),
          label: 'Project',
        ),
        BottomNavigationBarItem(
          icon: Icon(Ionicons.notifications_outline),
          label: 'Notification',
        ),
        BottomNavigationBarItem(
          icon: Icon(Ionicons.menu_outline),
          label: 'Menu',
        )
      ],
    );
  }
}
