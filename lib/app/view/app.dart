import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:join_me/app/bloc/app_bloc.dart';
import 'package:join_me/app/cubit/app_message_cubit.dart';
import 'package:join_me/config/router/router.dart';

import 'package:join_me/config/theme.dart';
import 'package:join_me/data/repositories/comment_repository.dart';
import 'package:join_me/data/repositories/notification_repository.dart';
import 'package:join_me/data/repositories/repositories.dart';
import 'package:join_me/l10n/l10n.dart';
import 'package:join_me/message/bloc/chat_bloc.dart';
import 'package:join_me/message/bloc/conversations_bloc.dart';
import 'package:join_me/message/bloc/new_conversation_bloc.dart';
import 'package:join_me/notification/bloc/notification_bloc.dart';
import 'package:join_me/post/bloc/comment_bloc.dart';
import 'package:join_me/post/bloc/posts_bloc.dart';
import 'package:join_me/post/cubit/like_cubit.dart';
import 'package:join_me/project/bloc/project_bloc.dart';
import 'package:join_me/project/bloc/project_overview_bloc.dart';
import 'package:join_me/task/bloc/tasks_overview_bloc.dart';

import 'package:join_me/user/cubit/search_user_cubit.dart';

class App extends StatelessWidget {
  const App({
    required this.appRouter,
    required AuthenticationRepository authenticationRepository,
    Key? key,
  })  : _authenticationRepository = authenticationRepository,
        super(key: key);
  final AppRouter appRouter;
  final AuthenticationRepository _authenticationRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(
          value: _authenticationRepository,
        ),
        RepositoryProvider(
          create: (context) => ProjectRepository(),
        ),
        RepositoryProvider(
          create: (context) => UserRepository(),
        ),
        RepositoryProvider(
          create: (context) => TaskRepository(),
        ),
        RepositoryProvider(
          create: (context) => PostRepository(),
        ),
        RepositoryProvider(
          create: (context) => MediaRepository(),
        ),
        RepositoryProvider(
          create: (context) => CommentRepository(),
        ),
        RepositoryProvider(
          create: (context) => MessageRepository(),
        ),
        RepositoryProvider(
          create: (context) => NotificationRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AppBloc(
              authenticationRepository: _authenticationRepository,
            ),
          ),
          BlocProvider(
            create: (context) => AppMessageCubit(),
          ),
          BlocProvider(
            create: (context) => ProjectOverviewBloc(
              projectRepository: context.read<ProjectRepository>(),
              taskRepository: context.read<TaskRepository>(),
              userRepository: context.read<UserRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => SearchUserCubit(
              userRepository: context.read<UserRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => ProjectBloc(
              projectRepository: context.read<ProjectRepository>(),
              userRepository: context.read<UserRepository>(),
              appMessageCubit: context.read<AppMessageCubit>(),
            ),
          ),
          BlocProvider(
            create: (context) => TasksOverviewBloc(
              taskRepository: context.read<TaskRepository>(),
              userRepository: context.read<UserRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => PostsBloc(
              appMessageCubit: context.read<AppMessageCubit>(),
              postRepository: context.read<PostRepository>(),
              userRepository: context.read<UserRepository>(),
              projectRepository: context.read<ProjectRepository>(),
            )..add(const FetchPosts()),
          ),
          BlocProvider(
            create: (context) => LikeCubit(
              postRepository: context.read<PostRepository>(),
              commentRepository: context.read<CommentRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => CommentBloc(
              commentRepository: context.read<CommentRepository>(),
              userRepository: context.read<UserRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => ConversationsBloc(
              messageRepository: context.read<MessageRepository>(),
              userRepository: context.read<UserRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => NewConversationBloc(
              messageRepository: context.read<MessageRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => ChatBloc(
              messageRepository: context.read<MessageRepository>(),
              userRepository: context.read<UserRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => NotificationBloc(
              notificationRepository: context.read<NotificationRepository>(),
            ),
          ),
        ],
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          scrollBehavior: const ScrollBehavior(
            androidOverscrollIndicator: AndroidOverscrollIndicator.stretch,
          ),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          routerDelegate: appRouter.delegate(),
          routeInformationParser: appRouter.defaultRouteParser(),
        ),
      ),
    );
  }
}
