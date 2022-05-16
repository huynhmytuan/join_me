// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

part of 'app_router.dart';

class _$AppRouter extends RootStackRouter {
  _$AppRouter([GlobalKey<NavigatorState>? navigatorKey]) : super(navigatorKey);

  @override
  final Map<String, PageFactory> pagesMap = {
    HomeRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const HomePage());
    },
    SingleProjectRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<SingleProjectRouteArgs>(
          orElse: () => SingleProjectRouteArgs(
              projectId: pathParams.getString('projectId')));
      return MaterialPageX<dynamic>(
          routeData: routeData,
          child: SingleProjectPage(projectId: args.projectId, key: args.key));
    },
    PostDetailRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<PostDetailRouteArgs>(
          orElse: () =>
              PostDetailRouteArgs(postId: pathParams.getString('postId')));
      return MaterialPageX<dynamic>(
          routeData: routeData,
          child: PostDetailPage(postId: args.postId, key: args.key));
    },
    NewPostRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const NewPostPage());
    },
    TextEditingRoute.name: (routeData) {
      final args = routeData.argsAs<TextEditingRouteArgs>();
      return MaterialPageX<dynamic>(
          routeData: routeData,
          child: TextEditingPage(
              initialText: args.initialText,
              hintText: args.hintText,
              key: args.key));
    },
    SingleTaskRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<SingleTaskRouteArgs>(
          orElse: () =>
              SingleTaskRouteArgs(taskId: pathParams.getString('taskId')));
      return MaterialPageX<dynamic>(
          routeData: routeData,
          child: SingleTaskPage(taskId: args.taskId, key: args.key));
    },
    LoginRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const LoginPage());
    },
    RegisterRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const RegisterPage());
    },
    ChatRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ChatRouteArgs>(
          orElse: () => ChatRouteArgs(
              conversationId: pathParams.getString('conversationId')));
      return MaterialPageX<dynamic>(
          routeData: routeData,
          child: ChatPage(conversationId: args.conversationId, key: args.key));
    },
    LanguageSettingRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const LanguageSettingPage());
    },
    ThemeSettingRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const ThemeSettingPage());
    },
    AboutUsRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const AboutUsPage());
    },
    UserInfoRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<UserInfoRouteArgs>(
          orElse: () =>
              UserInfoRouteArgs(userId: pathParams.getString('userId')));
      return MaterialPageX<dynamic>(
          routeData: routeData,
          child: UserInfoPage(userId: args.userId, key: args.key));
    },
    PostsRouter.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const EmptyRouterPage());
    },
    MessagesRouter.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const MessagesPage());
    },
    ProjectsRouter.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const EmptyRouterPage());
    },
    NotificationRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const NotificationPage());
    },
    MenuRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const MenuPage());
    },
    PostsRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const PostsPage());
    },
    ProjectsRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const ProjectsPage());
    },
    ProjectDashboardRoute.name: (routeData) {
      final args = routeData.argsAs<ProjectDashboardRouteArgs>();
      return MaterialPageX<dynamic>(
          routeData: routeData,
          child:
              ProjectDashboardPage(projectId: args.projectId, key: args.key));
    },
    ProjectTaskListRoute.name: (routeData) {
      final args = routeData.argsAs<ProjectTaskListRouteArgs>();
      return MaterialPageX<dynamic>(
          routeData: routeData,
          child: ProjectTaskListPage(projectId: args.projectId, key: args.key));
    },
    ProjectCalendarRoute.name: (routeData) {
      final args = routeData.argsAs<ProjectCalendarRouteArgs>();
      return MaterialPageX<dynamic>(
          routeData: routeData,
          child: ProjectCalendarPage(projectId: args.projectId, key: args.key));
    }
  };

  @override
  List<RouteConfig> get routes => [
        RouteConfig(HomeRoute.name, path: '/', children: [
          RouteConfig(PostsRouter.name,
              path: 'posts',
              parent: HomeRoute.name,
              children: [
                RouteConfig(PostsRoute.name, path: '', parent: PostsRouter.name)
              ]),
          RouteConfig(MessagesRouter.name,
              path: 'messages', parent: HomeRoute.name),
          RouteConfig(ProjectsRouter.name,
              path: 'projects',
              parent: HomeRoute.name,
              children: [
                RouteConfig(ProjectsRoute.name,
                    path: '', parent: ProjectsRouter.name)
              ]),
          RouteConfig(NotificationRoute.name,
              path: 'notification', parent: HomeRoute.name),
          RouteConfig(MenuRoute.name, path: 'menu', parent: HomeRoute.name)
        ]),
        RouteConfig(SingleProjectRoute.name, path: ':projectId', children: [
          RouteConfig(ProjectDashboardRoute.name,
              path: 'dashboard', parent: SingleProjectRoute.name),
          RouteConfig(ProjectTaskListRoute.name,
              path: 'task-list', parent: SingleProjectRoute.name),
          RouteConfig(ProjectCalendarRoute.name,
              path: 'task-by-calendar', parent: SingleProjectRoute.name)
        ]),
        RouteConfig(PostDetailRoute.name, path: ':postId'),
        RouteConfig(NewPostRoute.name, path: 'new-post'),
        RouteConfig(TextEditingRoute.name, path: 'editing'),
        RouteConfig(SingleTaskRoute.name, path: ':taskId'),
        RouteConfig(LoginRoute.name, path: 'login'),
        RouteConfig(RegisterRoute.name, path: 'register'),
        RouteConfig(ChatRoute.name, path: ':conversationId'),
        RouteConfig(LanguageSettingRoute.name, path: 'language-setting'),
        RouteConfig(ThemeSettingRoute.name, path: 'theme-setting'),
        RouteConfig(AboutUsRoute.name, path: 'about-us'),
        RouteConfig(UserInfoRoute.name, path: 'user-info/:userId')
      ];
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(HomeRoute.name, path: '/', initialChildren: children);

  static const String name = 'HomeRoute';
}

/// generated route for
/// [SingleProjectPage]
class SingleProjectRoute extends PageRouteInfo<SingleProjectRouteArgs> {
  SingleProjectRoute(
      {required String projectId, Key? key, List<PageRouteInfo>? children})
      : super(SingleProjectRoute.name,
            path: ':projectId',
            args: SingleProjectRouteArgs(projectId: projectId, key: key),
            rawPathParams: <String, dynamic>{'projectId': projectId},
            initialChildren: children);

  static const String name = 'SingleProjectRoute';
}

class SingleProjectRouteArgs {
  const SingleProjectRouteArgs({required this.projectId, this.key});

  final String projectId;

  final Key? key;

  @override
  String toString() {
    return 'SingleProjectRouteArgs{projectId: $projectId, key: $key}';
  }
}

/// generated route for
/// [PostDetailPage]
class PostDetailRoute extends PageRouteInfo<PostDetailRouteArgs> {
  PostDetailRoute({required String postId, Key? key})
      : super(PostDetailRoute.name,
            path: ':postId',
            args: PostDetailRouteArgs(postId: postId, key: key),
            rawPathParams: <String, dynamic>{'postId': postId});

  static const String name = 'PostDetailRoute';
}

class PostDetailRouteArgs {
  const PostDetailRouteArgs({required this.postId, this.key});

  final String postId;

  final Key? key;

  @override
  String toString() {
    return 'PostDetailRouteArgs{postId: $postId, key: $key}';
  }
}

/// generated route for
/// [NewPostPage]
class NewPostRoute extends PageRouteInfo<void> {
  const NewPostRoute() : super(NewPostRoute.name, path: 'new-post');

  static const String name = 'NewPostRoute';
}

/// generated route for
/// [TextEditingPage]
class TextEditingRoute extends PageRouteInfo<TextEditingRouteArgs> {
  TextEditingRoute(
      {required String initialText, required String hintText, Key? key})
      : super(TextEditingRoute.name,
            path: 'editing',
            args: TextEditingRouteArgs(
                initialText: initialText, hintText: hintText, key: key));

  static const String name = 'TextEditingRoute';
}

class TextEditingRouteArgs {
  const TextEditingRouteArgs(
      {required this.initialText, required this.hintText, this.key});

  final String initialText;

  final String hintText;

  final Key? key;

  @override
  String toString() {
    return 'TextEditingRouteArgs{initialText: $initialText, hintText: $hintText, key: $key}';
  }
}

/// generated route for
/// [SingleTaskPage]
class SingleTaskRoute extends PageRouteInfo<SingleTaskRouteArgs> {
  SingleTaskRoute({required String taskId, Key? key})
      : super(SingleTaskRoute.name,
            path: ':taskId',
            args: SingleTaskRouteArgs(taskId: taskId, key: key),
            rawPathParams: <String, dynamic>{'taskId': taskId});

  static const String name = 'SingleTaskRoute';
}

class SingleTaskRouteArgs {
  const SingleTaskRouteArgs({required this.taskId, this.key});

  final String taskId;

  final Key? key;

  @override
  String toString() {
    return 'SingleTaskRouteArgs{taskId: $taskId, key: $key}';
  }
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute() : super(LoginRoute.name, path: 'login');

  static const String name = 'LoginRoute';
}

/// generated route for
/// [RegisterPage]
class RegisterRoute extends PageRouteInfo<void> {
  const RegisterRoute() : super(RegisterRoute.name, path: 'register');

  static const String name = 'RegisterRoute';
}

/// generated route for
/// [ChatPage]
class ChatRoute extends PageRouteInfo<ChatRouteArgs> {
  ChatRoute({required String conversationId, Key? key})
      : super(ChatRoute.name,
            path: ':conversationId',
            args: ChatRouteArgs(conversationId: conversationId, key: key),
            rawPathParams: <String, dynamic>{'conversationId': conversationId});

  static const String name = 'ChatRoute';
}

class ChatRouteArgs {
  const ChatRouteArgs({required this.conversationId, this.key});

  final String conversationId;

  final Key? key;

  @override
  String toString() {
    return 'ChatRouteArgs{conversationId: $conversationId, key: $key}';
  }
}

/// generated route for
/// [LanguageSettingPage]
class LanguageSettingRoute extends PageRouteInfo<void> {
  const LanguageSettingRoute()
      : super(LanguageSettingRoute.name, path: 'language-setting');

  static const String name = 'LanguageSettingRoute';
}

/// generated route for
/// [ThemeSettingPage]
class ThemeSettingRoute extends PageRouteInfo<void> {
  const ThemeSettingRoute()
      : super(ThemeSettingRoute.name, path: 'theme-setting');

  static const String name = 'ThemeSettingRoute';
}

/// generated route for
/// [AboutUsPage]
class AboutUsRoute extends PageRouteInfo<void> {
  const AboutUsRoute() : super(AboutUsRoute.name, path: 'about-us');

  static const String name = 'AboutUsRoute';
}

/// generated route for
/// [UserInfoPage]
class UserInfoRoute extends PageRouteInfo<UserInfoRouteArgs> {
  UserInfoRoute({required String userId, Key? key})
      : super(UserInfoRoute.name,
            path: 'user-info/:userId',
            args: UserInfoRouteArgs(userId: userId, key: key),
            rawPathParams: <String, dynamic>{'userId': userId});

  static const String name = 'UserInfoRoute';
}

class UserInfoRouteArgs {
  const UserInfoRouteArgs({required this.userId, this.key});

  final String userId;

  final Key? key;

  @override
  String toString() {
    return 'UserInfoRouteArgs{userId: $userId, key: $key}';
  }
}

/// generated route for
/// [EmptyRouterPage]
class PostsRouter extends PageRouteInfo<void> {
  const PostsRouter({List<PageRouteInfo>? children})
      : super(PostsRouter.name, path: 'posts', initialChildren: children);

  static const String name = 'PostsRouter';
}

/// generated route for
/// [MessagesPage]
class MessagesRouter extends PageRouteInfo<void> {
  const MessagesRouter() : super(MessagesRouter.name, path: 'messages');

  static const String name = 'MessagesRouter';
}

/// generated route for
/// [EmptyRouterPage]
class ProjectsRouter extends PageRouteInfo<void> {
  const ProjectsRouter({List<PageRouteInfo>? children})
      : super(ProjectsRouter.name, path: 'projects', initialChildren: children);

  static const String name = 'ProjectsRouter';
}

/// generated route for
/// [NotificationPage]
class NotificationRoute extends PageRouteInfo<void> {
  const NotificationRoute()
      : super(NotificationRoute.name, path: 'notification');

  static const String name = 'NotificationRoute';
}

/// generated route for
/// [MenuPage]
class MenuRoute extends PageRouteInfo<void> {
  const MenuRoute() : super(MenuRoute.name, path: 'menu');

  static const String name = 'MenuRoute';
}

/// generated route for
/// [PostsPage]
class PostsRoute extends PageRouteInfo<void> {
  const PostsRoute() : super(PostsRoute.name, path: '');

  static const String name = 'PostsRoute';
}

/// generated route for
/// [ProjectsPage]
class ProjectsRoute extends PageRouteInfo<void> {
  const ProjectsRoute() : super(ProjectsRoute.name, path: '');

  static const String name = 'ProjectsRoute';
}

/// generated route for
/// [ProjectDashboardPage]
class ProjectDashboardRoute extends PageRouteInfo<ProjectDashboardRouteArgs> {
  ProjectDashboardRoute({required String projectId, Key? key})
      : super(ProjectDashboardRoute.name,
            path: 'dashboard',
            args: ProjectDashboardRouteArgs(projectId: projectId, key: key));

  static const String name = 'ProjectDashboardRoute';
}

class ProjectDashboardRouteArgs {
  const ProjectDashboardRouteArgs({required this.projectId, this.key});

  final String projectId;

  final Key? key;

  @override
  String toString() {
    return 'ProjectDashboardRouteArgs{projectId: $projectId, key: $key}';
  }
}

/// generated route for
/// [ProjectTaskListPage]
class ProjectTaskListRoute extends PageRouteInfo<ProjectTaskListRouteArgs> {
  ProjectTaskListRoute({required String projectId, Key? key})
      : super(ProjectTaskListRoute.name,
            path: 'task-list',
            args: ProjectTaskListRouteArgs(projectId: projectId, key: key));

  static const String name = 'ProjectTaskListRoute';
}

class ProjectTaskListRouteArgs {
  const ProjectTaskListRouteArgs({required this.projectId, this.key});

  final String projectId;

  final Key? key;

  @override
  String toString() {
    return 'ProjectTaskListRouteArgs{projectId: $projectId, key: $key}';
  }
}

/// generated route for
/// [ProjectCalendarPage]
class ProjectCalendarRoute extends PageRouteInfo<ProjectCalendarRouteArgs> {
  ProjectCalendarRoute({required String projectId, Key? key})
      : super(ProjectCalendarRoute.name,
            path: 'task-by-calendar',
            args: ProjectCalendarRouteArgs(projectId: projectId, key: key));

  static const String name = 'ProjectCalendarRoute';
}

class ProjectCalendarRouteArgs {
  const ProjectCalendarRouteArgs({required this.projectId, this.key});

  final String projectId;

  final Key? key;

  @override
  String toString() {
    return 'ProjectCalendarRouteArgs{projectId: $projectId, key: $key}';
  }
}
