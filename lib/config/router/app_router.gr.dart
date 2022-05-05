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
      return MaterialPageX<MaterialPageRoute<dynamic>>(
          routeData: routeData, child: const HomePage());
    },
    LoginRoute.name: (routeData) {
      return MaterialPageX<MaterialPageRoute<dynamic>>(
          routeData: routeData, child: const LoginPage());
    },
    RegisterRoute.name: (routeData) {
      return MaterialPageX<MaterialPageRoute<dynamic>>(
          routeData: routeData, child: const RegisterPage());
    },
    PostsRouter.name: (routeData) {
      return MaterialPageX<MaterialPageRoute<dynamic>>(
          routeData: routeData, child: const EmptyRouterPage());
    },
    ConversationRoute.name: (routeData) {
      return MaterialPageX<MaterialPageRoute<dynamic>>(
          routeData: routeData, child: const ConversationPage());
    },
    ProjectsRouter.name: (routeData) {
      return MaterialPageX<MaterialPageRoute<dynamic>>(
          routeData: routeData, child: const EmptyRouterPage());
    },
    NotificationRoute.name: (routeData) {
      return MaterialPageX<MaterialPageRoute<dynamic>>(
          routeData: routeData, child: const NotificationPage());
    },
    MenuRoute.name: (routeData) {
      return MaterialPageX<MaterialPageRoute<dynamic>>(
          routeData: routeData, child: const MenuPage());
    },
    PostsRoute.name: (routeData) {
      return MaterialPageX<MaterialPageRoute<dynamic>>(
          routeData: routeData, child: const PostsPage());
    },
    PostDetailRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<PostDetailRouteArgs>(
          orElse: () =>
              PostDetailRouteArgs(postId: pathParams.getString('postId')));
      return MaterialPageX<MaterialPageRoute<dynamic>>(
          routeData: routeData,
          child: PostDetailPage(postId: args.postId, key: args.key));
    },
    ProjectRoute.name: (routeData) {
      return MaterialPageX<MaterialPageRoute<dynamic>>(
          routeData: routeData, child: const ProjectPage());
    }
  };

  @override
  List<RouteConfig> get routes => [
        RouteConfig(HomeRoute.name, path: '/', children: [
          RouteConfig(PostsRouter.name,
              path: 'posts',
              parent: HomeRoute.name,
              children: [
                RouteConfig(PostsRoute.name,
                    path: '', parent: PostsRouter.name),
                RouteConfig(PostDetailRoute.name,
                    path: ':postId', parent: PostsRouter.name)
              ]),
          RouteConfig(ConversationRoute.name,
              path: 'messages', parent: HomeRoute.name),
          RouteConfig(ProjectsRouter.name,
              path: 'projects',
              parent: HomeRoute.name,
              children: [
                RouteConfig(ProjectRoute.name,
                    path: '', parent: ProjectsRouter.name)
              ]),
          RouteConfig(NotificationRoute.name,
              path: 'notification', parent: HomeRoute.name),
          RouteConfig(MenuRoute.name, path: 'menu', parent: HomeRoute.name)
        ]),
        RouteConfig(LoginRoute.name, path: 'login'),
        RouteConfig(RegisterRoute.name, path: 'register')
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
/// [EmptyRouterPage]
class PostsRouter extends PageRouteInfo<void> {
  const PostsRouter({List<PageRouteInfo>? children})
      : super(PostsRouter.name, path: 'posts', initialChildren: children);

  static const String name = 'PostsRouter';
}

/// generated route for
/// [ConversationPage]
class ConversationRoute extends PageRouteInfo<void> {
  const ConversationRoute() : super(ConversationRoute.name, path: 'messages');

  static const String name = 'ConversationRoute';
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
/// [ProjectPage]
class ProjectRoute extends PageRouteInfo<void> {
  const ProjectRoute() : super(ProjectRoute.name, path: '');

  static const String name = 'ProjectRoute';
}
