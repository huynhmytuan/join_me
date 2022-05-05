import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:join_me/widgets/widgets.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return KeyboardDismisser(
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
            child: SafeArea(
              child: Column(
                children: [
                  Text(
                    'Register',
                    style: CustomTextStyle.heading1(context),
                  ),
                  Text(
                    'Please fill all inputs bellow here',
                    style: CustomTextStyle.bodyMedium(context),
                  ),
                  const Spacer(),
                  RoundedTextField(
                    screenSize: screenSize,
                    label: 'Full Name',
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    prefixIcon: const Icon(Icons.person),
                  ),
                  const SizedBox(
                    height: kDefaultPadding,
                  ),
                  RoundedTextField(
                    screenSize: screenSize,
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(Icons.email_rounded),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: kDefaultPadding,
                  ),
                  RoundedTextField(
                    screenSize: screenSize,
                    label: 'Password',
                    obscureText: true,
                    textInputAction: TextInputAction.next,
                    prefixIcon: const Icon(Icons.lock),
                  ),
                  const SizedBox(
                    height: kDefaultPadding,
                  ),
                  RoundedTextField(
                    screenSize: screenSize,
                    label: 'Confirm Password',
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    prefixIcon: const Icon(Icons.lock),
                  ),
                  const Spacer(),
                  RoundedButton(
                    onPressed: () {},
                    child: Text(
                      'Sign Up',
                      style: CustomTextStyle.heading3(context)
                          .copyWith(color: Colors.white),
                    ),
                  ),
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
          ),
        ),
      ),
    );
  }
}
