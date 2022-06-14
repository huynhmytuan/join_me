import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:ionicons/ionicons.dart';
import 'package:join_me/config/router/app_router.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/generated/locale_keys.g.dart';
import 'package:join_me/login/bloc/login_cubit.dart';
import 'package:join_me/login/bloc/login_state.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:join_me/widgets/widgets.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    Key? key,
    required this.screenSize,
  }) : super(key: key);

  final Size screenSize;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: Theme.of(context).errorColor,
                content: Text(
                  state.errorMessage ??
                      LocaleKeys.errorMessage_authenticationFailure.tr(),
                ),
              ),
            );
        }
      },
      builder: (context, state) => state.status.isSubmissionInProgress
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    LocaleKeys.button_signIn.tr(),
                    style: CustomTextStyle.heading3(context),
                  ),
                  const SizedBox(
                    height: kDefaultPadding,
                  ),
                  const CircularProgressIndicator.adaptive(),
                ],
              ),
            )
          : SafeArea(
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
                    LocaleKeys.welcomeBackTitle.tr(),
                    style: CustomTextStyle.heading2(context),
                  ),
                  Text(
                    LocaleKeys.pleaseSignIn.tr(),
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
                    LocaleKeys.orSignInWith.tr(),
                    style: CustomTextStyle.heading4(context)
                        .copyWith(color: kTextColorGrey),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      _FacebookSignInButton(),
                      SizedBox(width: kDefaultPadding),
                      _GoogleSignInButton()
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        LocaleKeys.dontHaveAnAccount.tr(),
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
              hintText: LocaleKeys.textField_email.tr(),
              prefixIcon: const Icon(Ionicons.mail_outline),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              onChanged: (email) =>
                  context.read<LoginCubit>().emailChanged(email),
              errorText: state.email.invalid
                  ? LocaleKeys.errorMessage_invalidEmail.tr()
                  : null,
            ),
          ],
        );
      },
    );
  }
}

class _PasswordInput extends StatefulWidget {
  const _PasswordInput({
    Key? key,
    required this.screenSize,
  }) : super(key: key);

  final Size screenSize;

  @override
  State<_PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<_PasswordInput> {
  bool isShowPassword = false;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return Column(
          key: const Key('login_form_password_input'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RoundedTextField(
              screenSize: widget.screenSize,
              hintText: LocaleKeys.textField_password.tr(),
              onChanged: (password) =>
                  context.read<LoginCubit>().passwordChanged(password),
              prefixIcon: const Icon(Ionicons.lock_closed_outline),
              obscureText: !isShowPassword,
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.done,
              errorText: state.password.invalid
                  ? LocaleKeys.errorMessage_invalidPassword.tr()
                  : null,
              trailing: InkWell(
                radius: 24,
                onTap: () {
                  setState(() {
                    isShowPassword = !isShowPassword;
                  });
                },
                child: Icon(
                  isShowPassword ? Ionicons.eye_off : Ionicons.eye,
                  color: kTextColorGrey,
                ),
              ),
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
        return RoundedButton(
          onPressed: state.status.isValid
              ? () => context.read<LoginCubit>().logInWithCredentials()
              : null,
          child: Text(
            LocaleKeys.button_signIn.tr(),
            style:
                CustomTextStyle.heading3(context).copyWith(color: Colors.white),
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
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return IconButton(
          iconSize: 40,
          onPressed: () => context.read<LoginCubit>().loginWithFacebook(),
          icon: Image.asset(
            '$kIconDir/facebook_icon.png',
          ),
        );
      },
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
          iconSize: 40,
          onPressed: () => context.read<LoginCubit>().loginWithGoogle(),
          icon: Image.asset(
            '$kIconDir/google_icon.png',
            scale: 2,
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
        LocaleKeys.button_signUp.tr(),
        style: CustomTextStyle.heading4(context)
            .copyWith(color: Theme.of(context).primaryColor),
      ),
    );
  }
}
