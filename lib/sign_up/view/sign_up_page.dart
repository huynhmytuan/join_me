import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:join_me/data/repositories/repositories.dart';
import 'package:join_me/sign_up/cubit/sign_up_cubit.dart';

import 'package:join_me/sign_up/view/sign_up_form.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => SignUpCubit(
        context.read<AuthenticationRepository>(),
      ),
      child: KeyboardDismisser(
        // ignore: prefer_const_literals_to_create_immutables
        gestures: [GestureType.onTap],
        child: Scaffold(
          extendBodyBehindAppBar: true,
          extendBody: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            foregroundColor: Theme.of(context).brightness == Brightness.light
                ? kTextColorPrimaryLight
                : kTextColorPrimaryDark,
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.fromLTRB(
                kDefaultPadding * 1.5,
                kDefaultPadding * 4,
                kDefaultPadding * 1.5,
                kDefaultPadding,
              ),
              height: screenSize.height,
              width: screenSize.width,
              child: SignUpForm(screenSize: screenSize),
            ),
          ),
        ),
      ),
    );
  }
}
