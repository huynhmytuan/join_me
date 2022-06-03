import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:join_me/config/router/root_wrapper_page.dart';
import 'package:join_me/config/router/route_guard/project_check_member.dart';
import 'package:join_me/home/view/view.dart';
import 'package:join_me/images_picker/view/albums_list_page.dart';
import 'package:join_me/images_picker/view/images_picker_page.dart';
import 'package:join_me/images_picker/view/media_grid_page.dart';
import 'package:join_me/login/view/view.dart';
import 'package:join_me/menu/view/view.dart';
import 'package:join_me/message/view/view.dart';
import 'package:join_me/notification/view/view.dart';
import 'package:join_me/post/view/view.dart';
import 'package:join_me/project/bloc/project_bloc.dart';
import 'package:join_me/project/view/view.dart';
import 'package:join_me/sign_up/view/view.dart';
import 'package:join_me/task/view/view.dart';
import 'package:join_me/user/view/view.dart';
import 'package:join_me/widgets/widgets.dart';
import 'package:photo_manager/photo_manager.dart';

part 'app_router.gr.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute<dynamic>(
      initial: true,
      path: '/',
      page: RootWrapperPage,
      children: [
        AutoRoute<dynamic>(
          path: 'authenticate',
          name: 'AuthenticateRouter',
          page: EmptyRouterPage,
          children: [
            AutoRoute<dynamic>(
              initial: true,
              path: 'login',
              page: LoginPage,
            ),
            AutoRoute<dynamic>(
              path: 'register',
              page: SignUpPage,
            ),
          ],
        ),
        AutoRoute<dynamic>(
          path: 'main',
          name: 'MainWrapperRouter',
          page: EmptyRouterPage,
          children: [
            AutoRoute<dynamic>(
              initial: true,
              path: '',
              page: HomePage,
              children: [
                AutoRoute<dynamic>(
                  path: 'posts',
                  page: PostsPage,
                ),
                AutoRoute<dynamic>(
                  path: 'messages',
                  name: 'MessagesRouter',
                  page: MessagesPage,
                ),
                AutoRoute<dynamic>(
                  path: 'projects',
                  page: ProjectsPage,
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
              path: 'pick-image',
              page: ImagesPickerPage,
              children: [
                AutoRoute<dynamic>(
                  path: 'images',
                  page: MediaGridPage,
                ),
                CustomRoute<dynamic>(
                  path: 'albums',
                  page: AlbumsListPage,
                  transitionsBuilder: TransitionsBuilders.slideTop,
                )
              ],
            ),
            AutoRoute<dynamic>(
              path: ':projectId',
              guards: [CheckIsProjectMember],
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
              path: ':projectId/guest-view',
              page: SingleProjectGuestViewPage,
            ),
            AutoRoute<dynamic>(
              path: 'members',
              page: ProjectMembersPage,
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
      ],
    ),
  ],
)
class AppRouter extends _$AppRouter {
  AppRouter({required CheckIsProjectMember checkIsProjectMember})
      : super(checkIsProjectMember: checkIsProjectMember);
}
