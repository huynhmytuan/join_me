import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:join_me/app/bloc/app_bloc.dart';

import 'package:join_me/config/router/router.dart';

class RootWrapperPage extends StatelessWidget {
  const RootWrapperPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return AutoRouter.declarative(
          routes: (context) {
            switch (state.status) {
              case AppStatus.authenticated:
                return [
                  const MainWrapperRouter(),
                ];

              case AppStatus.unauthenticated:
                return [
                  const AuthenticateRouter(),
                ];
            }
          },
        );
      },
    );
  }
}
