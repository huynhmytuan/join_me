import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/sign_up/cubit/sign_up_cubit.dart';
import 'package:join_me/sign_up/cubit/sign_up_state.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:join_me/widgets/widgets.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({
    Key? key,
    required this.screenSize,
  }) : super(key: key);

  final Size screenSize;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(
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
            Text(
              'Sign Up',
              style: CustomTextStyle.heading1(context),
            ),
            Text(
              'Please fill all inputs bellow here',
              style: CustomTextStyle.bodyMedium(context),
            ),
            const Spacer(),
            _NameInput(screenSize: screenSize),
            const SizedBox(
              height: kDefaultPadding,
            ),
            _EmailInput(screenSize: screenSize),
            const SizedBox(
              height: kDefaultPadding,
            ),
            _PasswordInput(screenSize: screenSize),
            const SizedBox(
              height: kDefaultPadding,
            ),
            _ConfirmedPasswordInput(screenSize: screenSize),
            const Spacer(),
            const _SignUpButton(),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account?',
                  style: CustomTextStyle.heading4(context)
                      .copyWith(color: kTextColorGrey),
                ),
                TextButton(
                  onPressed: () {
                    context.router.pop();
                  },
                  child: Text(
                    'Sign In',
                    style: CustomTextStyle.heading4(context)
                        .copyWith(color: Theme.of(context).primaryColor),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NameInput extends StatelessWidget {
  const _NameInput({
    Key? key,
    required this.screenSize,
  }) : super(key: key);

  final Size screenSize;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      builder: (context, state) {
        return RoundedTextField(
          screenSize: screenSize,
          onChanged: (value) => context.read<SignUpCubit>().nameChanged(value),
          hintText: 'Full Name',
          errorText: state.name.invalid ? "Name can't be empty" : null,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          prefixIcon: const Icon(Icons.person),
        );
      },
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
    return BlocBuilder<SignUpCubit, SignUpState>(
      builder: (context, state) {
        return RoundedTextField(
          screenSize: screenSize,
          onChanged: (value) => context.read<SignUpCubit>().emailChanged(value),
          hintText: 'Email',
          errorText: state.email.invalid ? 'Email invalid' : null,
          keyboardType: TextInputType.emailAddress,
          prefixIcon: const Icon(Icons.email_rounded),
          textInputAction: TextInputAction.next,
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
    return BlocBuilder<SignUpCubit, SignUpState>(
      builder: (context, state) {
        return RoundedTextField(
          screenSize: screenSize,
          onChanged: (value) =>
              context.read<SignUpCubit>().passwordChanged(value),
          hintText: 'Password',
          errorText: state.password.invalid ? 'Password invalid' : null,
          obscureText: true,
          textInputAction: TextInputAction.next,
          prefixIcon: const Icon(Icons.lock),
        );
      },
    );
  }
}

class _ConfirmedPasswordInput extends StatelessWidget {
  const _ConfirmedPasswordInput({
    Key? key,
    required this.screenSize,
  }) : super(key: key);

  final Size screenSize;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) =>
          previous.password != current.password ||
          previous.confirmedPassword != current.confirmedPassword,
      builder: (context, state) {
        return RoundedTextField(
          screenSize: screenSize,
          onChanged: (value) =>
              context.read<SignUpCubit>().confirmPasswordChanged(value),
          hintText: 'Confirm Password',
          errorText: state.confirmedPassword.invalid
              ? "Confirmed password doesn't match."
              : null,
          obscureText: true,
          textInputAction: TextInputAction.done,
          prefixIcon: const Icon(Icons.lock),
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
    return BlocBuilder<SignUpCubit, SignUpState>(
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : RoundedButton(
                onPressed: state.status.isValidated
                    ? () => context.read<SignUpCubit>().signUpWithCredentials()
                    : null,
                child: Text(
                  'Sign Up',
                  style: CustomTextStyle.heading3(context).copyWith(
                    color: Colors.white,
                  ),
                ),
              );
      },
    );
  }
}
