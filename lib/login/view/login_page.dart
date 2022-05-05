import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:join_me/config/router/app_router.dart';

import 'package:join_me/config/theme.dart';
import 'package:join_me/l10n/l10n.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:join_me/widgets/widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final l10n = context.l10n;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        // extendBody: true,
        // extendBodyBehindAppBar: true,
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: kDefaultPadding * 1.5,
              vertical: kDefaultPadding,
            ),
            height: screenSize.height,
            width: screenSize.width,
            child: SafeArea(
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  Stack(
                    children: [
                      SvgPicture.asset(kLogoBackgroundDir),
                      SvgPicture.asset(kLogoLightDir),
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
                  RoundedTextField(
                    screenSize: screenSize,
                    label: 'Email',
                    prefixIcon: const Icon(Icons.email_rounded),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  RoundedTextField(
                    screenSize: screenSize,
                    label: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                  ),
                  const Spacer(flex: 2),
                  RoundedButton(
                    onPressed: () {},
                    child: Text(
                      'Sign In',
                      style: CustomTextStyle.heading3(context)
                          .copyWith(color: Colors.white),
                    ),
                  ),
                  const Spacer(flex: 2),
                  Text(
                    'or sign in with',
                    style: CustomTextStyle.heading4(context)
                        .copyWith(color: kTextColorGrey),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Image.asset(
                          '$kIconDir/facebook_icon.png',
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Image.asset(
                          '$kIconDir/google_icon.png',
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: CustomTextStyle.heading4(context)
                            .copyWith(color: kTextColorGrey),
                      ),
                      TextButton(
                        onPressed: () {
                          context.router.push(const RegisterRoute());
                        },
                        child: Text(
                          'Sign Up',
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
