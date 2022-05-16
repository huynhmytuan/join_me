import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:join_me/home/view/view.dart';
import 'package:join_me/login/view/view.dart';
import 'package:join_me/menu/view/user_info_page.dart';
import 'package:join_me/menu/view/view.dart';
import 'package:join_me/message/view/view.dart';
import 'package:join_me/notification/view/view.dart';
import 'package:join_me/post/view/view.dart';
import 'package:join_me/project/view/view.dart';
import 'package:join_me/register/view/view.dart';

part 'app_router.gr.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute<dynamic>(
      path: '/',
      page: HomePage,
      initial: true,
      children: [
        AutoRoute<dynamic>(
          path: 'posts',
          name: 'PostsRouter',
          page: EmptyRouterPage,
          children: [
            AutoRoute<dynamic>(
              path: '',
              page: PostsPage,
            ),
          ],
        ),
        AutoRoute<dynamic>(
          path: 'messages',
          name: 'MessagesRouter',
          page: MessagesPage,
        ),
        AutoRoute<dynamic>(
          path: 'projects',
          name: 'ProjectsRouter',
          page: EmptyRouterPage,
          children: [
            AutoRoute<dynamic>(
              path: '',
              page: ProjectsPage,
            ),
          ],
        ),
        AutoRoute<dynamic>(
          path: 'notification',
          page: NotificationPage,
        ),
        AutoRoute<dynamic>(
          path: 'menu',
          page: MenuPage,
        ),
      ],
    ),
    AutoRoute<dynamic>(
      path: ':projectId',
      page: SingleProjectPage,
      children: [
        AutoRoute<dynamic>(
          path: 'dashboard',
          page: ProjectDashboardPage,
        ),
        AutoRoute<dynamic>(
          path: 'task-list',
          page: ProjectTaskListPage,
        ),
        AutoRoute<dynamic>(
          path: 'task-by-calendar',
          page: ProjectCalendarPage,
        ),
      ],
    ),
    AutoRoute<dynamic>(
      path: ':postId',
      page: PostDetailPage,
    ),
    AutoRoute<dynamic>(
      path: 'new-post',
      page: NewPostPage,
    ),
    AutoRoute<dynamic>(
      path: 'editing',
      page: TextEditingPage,
    ),
    AutoRoute<dynamic>(
      path: ':taskId',
      page: SingleTaskPage,
    ),
    AutoRoute<dynamic>(
      path: 'login',
      page: LoginPage,
    ),
    AutoRoute<dynamic>(
      path: 'register',
      page: RegisterPage,
    ),
    AutoRoute<dynamic>(
      path: ':conversationId',
      page: ChatPage,
    ),
    AutoRoute<dynamic>(
      path: 'language-setting',
      page: LanguageSettingPage,
    ),
    AutoRoute<dynamic>(
      path: 'theme-setting',
      page: ThemeSettingPage,
    ),
    AutoRoute<dynamic>(
      path: 'about-us',
      page: AboutUsPage,
    ),
    AutoRoute<dynamic>(
      path: 'user-info/:userId',
      page: UserInfoPage,
    ),
  ],
)
class AppRouter extends _$AppRouter {}
