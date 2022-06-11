import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:join_me/data/repositories/authentication_repository.dart';

import 'package:join_me/login/bloc/login_cubit.dart';
import 'package:join_me/login/view/view.dart';
import 'package:join_me/utilities/constant.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) => LoginCubit(context.read<AuthenticationRepository>()),
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: kDefaultPadding * 1.5,
                vertical: kDefaultPadding,
              ),
              height: screenSize.height,
              width: screenSize.width,
              child: LoginForm(screenSize: screenSize),
            ),
          ),
        ),
      ),
    );
  }
}
