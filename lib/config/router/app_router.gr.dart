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
  _$AppRouter(
      {GlobalKey<NavigatorState>? navigatorKey,
      required this.checkIsProjectMember,
      required this.checkIfPostExists})
      : super(navigatorKey);

  final CheckIsProjectMember checkIsProjectMember;

  final CheckIfPostExists checkIfPostExists;

  @override
  final Map<String, PageFactory> pagesMap = {
    RootWrapperRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const RootWrapperPage());
    },
    AuthenticateRouter.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const EmptyRouterPage());
    },
    MainWrapperRouter.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const EmptyRouterPage());
    },
    LoginRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const LoginPage());
    },
    SignUpRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const SignUpPage());
    },
    HomeRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const HomePage());
    },
    ImagesPickerRoute.name: (routeData) {
      final args = routeData.argsAs<ImagesPickerRouteArgs>(
          orElse: () => const ImagesPickerRouteArgs());
      return MaterialPageX<dynamic>(
          routeData: routeData,
          child: ImagesPickerPage(
              initialMedias: args.initialMedias,
              limit: args.limit,
              type: args.type,
              key: args.key));
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
    NotFoundRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const NotFoundPage());
    },
    SingleProjectGuestViewRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<SingleProjectGuestViewRouteArgs>(
          orElse: () => SingleProjectGuestViewRouteArgs(
              projectId: pathParams.getString('projectId')));
      return MaterialPageX<dynamic>(
          routeData: routeData,
          child: SingleProjectGuestViewPage(
              projectId: args.projectId, key: args.key));
    },
    RequestsRoute.name: (routeData) {
      final args = routeData.argsAs<RequestsRouteArgs>();
      return MaterialPageX<dynamic>(
          routeData: routeData,
          child: RequestsPage(projectId: args.projectId, key: args.key));
    },
    ProjectMembersRoute.name: (routeData) {
      final args = routeData.argsAs<ProjectMembersRouteArgs>();
      return MaterialPageX<dynamic>(
          routeData: routeData,
          child:
              ProjectMembersPage(key: args.key, projectBloc: args.projectBloc));
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
    ChatRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ChatRouteArgs>(
          orElse: () => ChatRouteArgs(
              conversationId: pathParams.getString('conversationId')));
      return MaterialPageX<dynamic>(
          routeData: routeData,
          child: ChatPage(conversationId: args.conversationId, key: args.key));
    },
    ConversationInfoRoute.name: (routeData) {
      final args = routeData.argsAs<ConversationInfoRouteArgs>();
      return MaterialPageX<dynamic>(
          routeData: routeData,
          child: ConversationInfoPage(chatBloc: args.chatBloc, key: args.key));
    },
    ConversationMembersRoute.name: (routeData) {
      final args = routeData.argsAs<ConversationMembersRouteArgs>();
      return MaterialPageX<dynamic>(
          routeData: routeData,
          child:
              ConversationMembersPage(chatBloc: args.chatBloc, key: args.key));
    },
    NewChatRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const NewChatPage());
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
    EditProfileRoute.name: (routeData) {
      final args = routeData.argsAs<EditProfileRouteArgs>();
      return MaterialPageX<dynamic>(
          routeData: routeData,
          child: EditProfilePage(userBloc: args.userBloc, key: args.key));
    },
    PostsRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const PostsPage());
    },
    MessagesRouter.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const ConversationsPage());
    },
    ProjectsRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const ProjectsPage());
    },
    NotificationRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const NotificationPage());
    },
    MenuRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const MenuPage());
    },
    MediaGridRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const MediaGridPage());
    },
    AlbumsListRoute.name: (routeData) {
      return CustomPage<dynamic>(
          routeData: routeData,
          child: const AlbumsListPage(),
          transitionsBuilder: TransitionsBuilders.slideTop,
          opaque: true,
          barrierDismissible: false);
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
        RouteConfig(RootWrapperRoute.name, path: '/', children: [
          RouteConfig(AuthenticateRouter.name,
              path: 'authenticate',
              parent: RootWrapperRoute.name,
              children: [
                RouteConfig('#redirect',
                    path: '',
                    parent: AuthenticateRouter.name,
                    redirectTo: 'login',
                    fullMatch: true),
                RouteConfig(LoginRoute.name,
                    path: 'login', parent: AuthenticateRouter.name),
                RouteConfig(SignUpRoute.name,
                    path: 'register', parent: AuthenticateRouter.name)
              ]),
          RouteConfig(MainWrapperRouter.name,
              path: 'main',
              parent: RootWrapperRoute.name,
              children: [
                RouteConfig(HomeRoute.name,
                    path: '',
                    parent: MainWrapperRouter.name,
                    children: [
                      RouteConfig(PostsRoute.name,
                          path: 'posts', parent: HomeRoute.name),
                      RouteConfig(MessagesRouter.name,
                          path: 'messages', parent: HomeRoute.name),
                      RouteConfig(ProjectsRoute.name,
                          path: 'projects', parent: HomeRoute.name),
                      RouteConfig(NotificationRoute.name,
                          path: 'notification', parent: HomeRoute.name),
                      RouteConfig(MenuRoute.name,
                          path: 'menu', parent: HomeRoute.name)
                    ]),
                RouteConfig(ImagesPickerRoute.name,
                    path: 'pick-image',
                    parent: MainWrapperRouter.name,
                    children: [
                      RouteConfig(MediaGridRoute.name,
                          path: 'images', parent: ImagesPickerRoute.name),
                      RouteConfig(AlbumsListRoute.name,
                          path: 'albums', parent: ImagesPickerRoute.name)
                    ]),
                RouteConfig(SingleProjectRoute.name,
                    path: ':projectId',
                    parent: MainWrapperRouter.name,
                    guards: [
                      checkIsProjectMember
                    ],
                    children: [
                      RouteConfig(ProjectDashboardRoute.name,
                          path: 'dashboard', parent: SingleProjectRoute.name),
                      RouteConfig(ProjectTaskListRoute.name,
                          path: 'task-list', parent: SingleProjectRoute.name),
                      RouteConfig(ProjectCalendarRoute.name,
                          path: 'task-by-calendar',
                          parent: SingleProjectRoute.name)
                    ]),
                RouteConfig(NotFoundRoute.name,
                    path: 'page-not-found', parent: MainWrapperRouter.name),
                RouteConfig(SingleProjectGuestViewRoute.name,
                    path: ':projectId/guest-view',
                    parent: MainWrapperRouter.name),
                RouteConfig(RequestsRoute.name,
                    path: ':projectId/requests',
                    parent: MainWrapperRouter.name),
                RouteConfig(ProjectMembersRoute.name,
                    path: 'project-members', parent: MainWrapperRouter.name),
                RouteConfig(PostDetailRoute.name,
                    path: ':postId',
                    parent: MainWrapperRouter.name,
                    guards: [checkIfPostExists]),
                RouteConfig(NewPostRoute.name,
                    path: 'new-post', parent: MainWrapperRouter.name),
                RouteConfig(TextEditingRoute.name,
                    path: 'editing', parent: MainWrapperRouter.name),
                RouteConfig(SingleTaskRoute.name,
                    path: ':taskId', parent: MainWrapperRouter.name),
                RouteConfig(ChatRoute.name,
                    path: ':conversationId', parent: MainWrapperRouter.name),
                RouteConfig(ConversationInfoRoute.name,
                    path: 'conversation-info', parent: MainWrapperRouter.name),
                RouteConfig(ConversationMembersRoute.name,
                    path: 'conversation-members',
                    parent: MainWrapperRouter.name),
                RouteConfig(NewChatRoute.name,
                    path: 'new-chat', parent: MainWrapperRouter.name),
                RouteConfig(LanguageSettingRoute.name,
                    path: 'language-setting', parent: MainWrapperRouter.name),
                RouteConfig(ThemeSettingRoute.name,
                    path: 'theme-setting', parent: MainWrapperRouter.name),
                RouteConfig(AboutUsRoute.name,
                    path: 'about-us', parent: MainWrapperRouter.name),
                RouteConfig(UserInfoRoute.name,
                    path: 'user-info/:userId', parent: MainWrapperRouter.name),
                RouteConfig(EditProfileRoute.name,
                    path: 'edit-profile', parent: MainWrapperRouter.name)
              ])
        ])
      ];
}

/// generated route for
/// [RootWrapperPage]
class RootWrapperRoute extends PageRouteInfo<void> {
  const RootWrapperRoute({List<PageRouteInfo>? children})
      : super(RootWrapperRoute.name, path: '/', initialChildren: children);

  static const String name = 'RootWrapperRoute';
}

/// generated route for
/// [EmptyRouterPage]
class AuthenticateRouter extends PageRouteInfo<void> {
  const AuthenticateRouter({List<PageRouteInfo>? children})
      : super(AuthenticateRouter.name,
            path: 'authenticate', initialChildren: children);

  static const String name = 'AuthenticateRouter';
}

/// generated route for
/// [EmptyRouterPage]
class MainWrapperRouter extends PageRouteInfo<void> {
  const MainWrapperRouter({List<PageRouteInfo>? children})
      : super(MainWrapperRouter.name, path: 'main', initialChildren: children);

  static const String name = 'MainWrapperRouter';
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute() : super(LoginRoute.name, path: 'login');

  static const String name = 'LoginRoute';
}

/// generated route for
/// [SignUpPage]
class SignUpRoute extends PageRouteInfo<void> {
  const SignUpRoute() : super(SignUpRoute.name, path: 'register');

  static const String name = 'SignUpRoute';
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(HomeRoute.name, path: '', initialChildren: children);

  static const String name = 'HomeRoute';
}

/// generated route for
/// [ImagesPickerPage]
class ImagesPickerRoute extends PageRouteInfo<ImagesPickerRouteArgs> {
  ImagesPickerRoute(
      {List<AssetEntity> initialMedias = const [],
      int? limit,
      RequestType? type,
      Key? key,
      List<PageRouteInfo>? children})
      : super(ImagesPickerRoute.name,
            path: 'pick-image',
            args: ImagesPickerRouteArgs(
                initialMedias: initialMedias,
                limit: limit,
                type: type,
                key: key),
            initialChildren: children);

  static const String name = 'ImagesPickerRoute';
}

class ImagesPickerRouteArgs {
  const ImagesPickerRouteArgs(
      {this.initialMedias = const [], this.limit, this.type, this.key});

  final List<AssetEntity> initialMedias;

  final int? limit;

  final RequestType? type;

  final Key? key;

  @override
  String toString() {
    return 'ImagesPickerRouteArgs{initialMedias: $initialMedias, limit: $limit, type: $type, key: $key}';
  }
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
/// [NotFoundPage]
class NotFoundRoute extends PageRouteInfo<void> {
  const NotFoundRoute() : super(NotFoundRoute.name, path: 'page-not-found');

  static const String name = 'NotFoundRoute';
}

/// generated route for
/// [SingleProjectGuestViewPage]
class SingleProjectGuestViewRoute
    extends PageRouteInfo<SingleProjectGuestViewRouteArgs> {
  SingleProjectGuestViewRoute({required String projectId, Key? key})
      : super(SingleProjectGuestViewRoute.name,
            path: ':projectId/guest-view',
            args:
                SingleProjectGuestViewRouteArgs(projectId: projectId, key: key),
            rawPathParams: <String, dynamic>{'projectId': projectId});

  static const String name = 'SingleProjectGuestViewRoute';
}

class SingleProjectGuestViewRouteArgs {
  const SingleProjectGuestViewRouteArgs({required this.projectId, this.key});

  final String projectId;

  final Key? key;

  @override
  String toString() {
    return 'SingleProjectGuestViewRouteArgs{projectId: $projectId, key: $key}';
  }
}

/// generated route for
/// [RequestsPage]
class RequestsRoute extends PageRouteInfo<RequestsRouteArgs> {
  RequestsRoute({required String projectId, Key? key})
      : super(RequestsRoute.name,
            path: ':projectId/requests',
            args: RequestsRouteArgs(projectId: projectId, key: key));

  static const String name = 'RequestsRoute';
}

class RequestsRouteArgs {
  const RequestsRouteArgs({required this.projectId, this.key});

  final String projectId;

  final Key? key;

  @override
  String toString() {
    return 'RequestsRouteArgs{projectId: $projectId, key: $key}';
  }
}

/// generated route for
/// [ProjectMembersPage]
class ProjectMembersRoute extends PageRouteInfo<ProjectMembersRouteArgs> {
  ProjectMembersRoute({Key? key, required ProjectBloc projectBloc})
      : super(ProjectMembersRoute.name,
            path: 'project-members',
            args: ProjectMembersRouteArgs(key: key, projectBloc: projectBloc));

  static const String name = 'ProjectMembersRoute';
}

class ProjectMembersRouteArgs {
  const ProjectMembersRouteArgs({this.key, required this.projectBloc});

  final Key? key;

  final ProjectBloc projectBloc;

  @override
  String toString() {
    return 'ProjectMembersRouteArgs{key: $key, projectBloc: $projectBloc}';
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
/// [ConversationInfoPage]
class ConversationInfoRoute extends PageRouteInfo<ConversationInfoRouteArgs> {
  ConversationInfoRoute({required ChatBloc chatBloc, Key? key})
      : super(ConversationInfoRoute.name,
            path: 'conversation-info',
            args: ConversationInfoRouteArgs(chatBloc: chatBloc, key: key));

  static const String name = 'ConversationInfoRoute';
}

class ConversationInfoRouteArgs {
  const ConversationInfoRouteArgs({required this.chatBloc, this.key});

  final ChatBloc chatBloc;

  final Key? key;

  @override
  String toString() {
    return 'ConversationInfoRouteArgs{chatBloc: $chatBloc, key: $key}';
  }
}

/// generated route for
/// [ConversationMembersPage]
class ConversationMembersRoute
    extends PageRouteInfo<ConversationMembersRouteArgs> {
  ConversationMembersRoute({required ChatBloc chatBloc, Key? key})
      : super(ConversationMembersRoute.name,
            path: 'conversation-members',
            args: ConversationMembersRouteArgs(chatBloc: chatBloc, key: key));

  static const String name = 'ConversationMembersRoute';
}

class ConversationMembersRouteArgs {
  const ConversationMembersRouteArgs({required this.chatBloc, this.key});

  final ChatBloc chatBloc;

  final Key? key;

  @override
  String toString() {
    return 'ConversationMembersRouteArgs{chatBloc: $chatBloc, key: $key}';
  }
}

/// generated route for
/// [NewChatPage]
class NewChatRoute extends PageRouteInfo<void> {
  const NewChatRoute() : super(NewChatRoute.name, path: 'new-chat');

  static const String name = 'NewChatRoute';
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
/// [EditProfilePage]
class EditProfileRoute extends PageRouteInfo<EditProfileRouteArgs> {
  EditProfileRoute({required UserBloc userBloc, Key? key})
      : super(EditProfileRoute.name,
            path: 'edit-profile',
            args: EditProfileRouteArgs(userBloc: userBloc, key: key));

  static const String name = 'EditProfileRoute';
}

class EditProfileRouteArgs {
  const EditProfileRouteArgs({required this.userBloc, this.key});

  final UserBloc userBloc;

  final Key? key;

  @override
  String toString() {
    return 'EditProfileRouteArgs{userBloc: $userBloc, key: $key}';
  }
}

/// generated route for
/// [PostsPage]
class PostsRoute extends PageRouteInfo<void> {
  const PostsRoute() : super(PostsRoute.name, path: 'posts');

  static const String name = 'PostsRoute';
}

/// generated route for
/// [ConversationsPage]
class MessagesRouter extends PageRouteInfo<void> {
  const MessagesRouter() : super(MessagesRouter.name, path: 'messages');

  static const String name = 'MessagesRouter';
}

/// generated route for
/// [ProjectsPage]
class ProjectsRoute extends PageRouteInfo<void> {
  const ProjectsRoute() : super(ProjectsRoute.name, path: 'projects');

  static const String name = 'ProjectsRoute';
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
/// [MediaGridPage]
class MediaGridRoute extends PageRouteInfo<void> {
  const MediaGridRoute() : super(MediaGridRoute.name, path: 'images');

  static const String name = 'MediaGridRoute';
}

/// generated route for
/// [AlbumsListPage]
class AlbumsListRoute extends PageRouteInfo<void> {
  const AlbumsListRoute() : super(AlbumsListRoute.name, path: 'albums');

  static const String name = 'AlbumsListRoute';
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
