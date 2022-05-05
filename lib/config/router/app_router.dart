import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:join_me/home/view/home_page.dart';
import 'package:join_me/login/login.dart';
import 'package:join_me/menu/view/menu_page.dart';
import 'package:join_me/message/message.dart';
import 'package:join_me/notification/view/notification_page.dart';
import 'package:join_me/post/post.dart';
import 'package:join_me/post/view/post_detail_page.dart';
import 'package:join_me/project/view/project_page.dart';
import 'package:join_me/register/view/register_page.dart';

part 'app_router.gr.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute<MaterialPageRoute>(
      path: '/',
      page: HomePage,
      initial: true,
      children: [
        AutoRoute<MaterialPageRoute>(
          path: 'posts',
          name: 'PostsRouter',
          page: EmptyRouterPage,
          children: [
            AutoRoute<MaterialPageRoute>(
              path: '',
              page: PostsPage,
            ),
            AutoRoute<MaterialPageRoute>(
              path: ':postId',
              page: PostDetailPage,
            ),
          ],
        ),
        AutoRoute<MaterialPageRoute>(
          path: 'messages',
          page: ConversationPage,
        ),
        AutoRoute<MaterialPageRoute>(
          path: 'projects',
          name: 'ProjectsRouter',
          page: EmptyRouterPage,
          children: [
            AutoRoute<MaterialPageRoute>(
              path: '',
              page: ProjectPage,
            ),
          ],
        ),
        AutoRoute<MaterialPageRoute>(
          path: 'notification',
          page: NotificationPage,
        ),
        AutoRoute<MaterialPageRoute>(
          path: 'menu',
          page: MenuPage,
        ),
      ],
    ),
    AutoRoute<MaterialPageRoute>(
      path: 'login',
      page: LoginPage,
    ),
    AutoRoute<MaterialPageRoute>(
      path: 'register',
      page: RegisterPage,
    ),
  ],
)
class AppRouter extends _$AppRouter {}
