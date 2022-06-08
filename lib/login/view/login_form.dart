import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formz/formz.dart';
import 'package:ionicons/ionicons.dart';
import 'package:join_me/config/router/app_router.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/l10n/l10n.dart';
import 'package:join_me/login/bloc/login_cubit.dart';
import 'package:join_me/login/bloc/login_state.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:join_me/widgets/widgets.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    Key? key,
    required this.l10n,
    required this.screenSize,
  }) : super(key: key);

  final AppLocalizations l10n;
  final Size screenSize;

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: Theme.of(context).errorColor,
                content: Text(state.errorMessage ?? 'Authentication Failure'),
              ),
            );
        }
      },
      child: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),
            Stack(
              children: [
                Image.asset(kLogoBackgroundDir),
                Image.asset(
                  Theme.of(context).brightness == Brightness.light
                      ? kLogoLightDir
                      : kLogoDarkDir,
                ),
              ],
            ),
            Text(
              l10n.welcomeBackTitle,
              style: CustomTextStyle.heading2(context),
            ),
            Text(
              'Please sign in to continue.',
              style: CustomTextStyle.bodyMedium(context)
                  .copyWith(color: kTextColorGrey),
            ),
            const Spacer(flex: 2),
            _EmailInput(screenSize: screenSize),
            const SizedBox(
              height: 10,
            ),
            _PasswordInput(screenSize: screenSize),
            const Spacer(flex: 2),
            const _SignInButton(),
            const Spacer(flex: 2),
            Text(
              'or sign in with',
              style: CustomTextStyle.heading4(context)
                  .copyWith(color: kTextColorGrey),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [_FacebookSignInButton(), _GoogleSignInButton()],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account?",
                  style: CustomTextStyle.heading4(context)
                      .copyWith(color: kTextColorGrey),
                ),
                const _SignUpButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  const _EmailInput({
    Key? key,
    required this.screenSize,
  }) : super(key: key);

  final Size screenSize;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return Column(
          key: const Key('login_form_email_input'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RoundedTextField(
              screenSize: screenSize,
              hintText: 'Email',
              prefixIcon: const Icon(Ionicons.mail_outline),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              onChanged: (email) =>
                  context.read<LoginCubit>().emailChanged(email),
              errorText: state.email.invalid ? 'Invalid Email' : null,
            ),
          ],
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  const _PasswordInput({
    Key? key,
    required this.screenSize,
  }) : super(key: key);

  final Size screenSize;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return Column(
          key: const Key('login_form_password_input'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RoundedTextField(
              screenSize: screenSize,
              hintText: 'Password',
              onChanged: (password) =>
                  context.read<LoginCubit>().passwordChanged(password),
              prefixIcon: const Icon(Ionicons.lock_closed_outline),
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.done,
              errorText: state.password.invalid ? 'Invalid Password' : null,
            ),
          ],
        );
      },
    );
  }
}

class _SignInButton extends StatelessWidget {
  const _SignInButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : RoundedButton(
                onPressed: state.status.isValidated
                    ? () => context.read<LoginCubit>().logInWithCredentials()
                    : null,
                child: Text(
                  'Sign In',
                  style: CustomTextStyle.heading3(context)
                      .copyWith(color: Colors.white),
                ),
              );
      },
    );
  }
}

class _FacebookSignInButton extends StatelessWidget {
  const _FacebookSignInButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: Image.asset(
        '$kIconDir/facebook_icon.png',
      ),
    );
  }
}

class _GoogleSignInButton extends StatelessWidget {
  const _GoogleSignInButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return IconButton(
          onPressed: () => context.read<LoginCubit>().loginWithGoogle(),
          icon: Image.asset(
            '$kIconDir/google_icon.png',
          ),
        );
      },
    );
  }
}

class _SignUpButton extends StatelessWidget {
  const _SignUpButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        AutoRouter.of(context).push(const SignUpRoute());
      },
      child: Text(
        'Sign Up',
        style: CustomTextStyle.heading4(context)
            .copyWith(color: Theme.of(context).primaryColor),
      ),
    );
  }
}
