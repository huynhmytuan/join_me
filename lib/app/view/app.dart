import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:join_me/app/blocs/app_bloc.dart';
import 'package:join_me/config/router/router.dart';

import 'package:join_me/config/theme.dart';

import 'package:join_me/data/repositories/media_repository.dart';
import 'package:join_me/data/repositories/post_repository.dart';
import 'package:join_me/data/repositories/repositories.dart';
import 'package:join_me/l10n/l10n.dart';
import 'package:join_me/project/bloc/project_bloc/project_bloc.dart';
import 'package:join_me/project/bloc/project_overview_bloc/project_overview_bloc.dart';
import 'package:join_me/task/bloc/tasks_overview_bloc.dart';
import 'package:join_me/user/bloc/users_search_bloc.dart';

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
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AppBloc(
              authenticationRepository: _authenticationRepository,
            ),
          ),
          BlocProvider(
            create: (context) => ProjectOverviewBloc(
              projectRepository: ProjectRepository(),
              taskRepository: context.read<TaskRepository>(),
              userRepository: context.read<UserRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => UsersSearchBloc(
              userRepository: UserRepository(),
            ),
          ),
          BlocProvider(
            create: (context) => ProjectBloc(
              projectRepository: context.read<ProjectRepository>(),
              userRepository: context.read<UserRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => TasksOverviewBloc(
              taskRepository: context.read<TaskRepository>(),
              userRepository: context.read<UserRepository>(),
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
