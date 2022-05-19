import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:join_me/app/blocs/app_bloc.dart';
import 'package:join_me/config/router/router.dart';

import 'package:join_me/config/theme.dart';
import 'package:join_me/data/repositories/repositories.dart';

import 'package:join_me/l10n/l10n.dart';

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
    return RepositoryProvider.value(
      value: _authenticationRepository,
      child: BlocProvider(
        create: (context) => AppBloc(
          authenticationRepository: _authenticationRepository,
        ),
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
