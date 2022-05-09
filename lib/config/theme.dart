import 'package:flutter/material.dart';
import 'package:join_me/utilities/constant.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    fontFamily: kFontFamily,
    primaryColor: kPrimaryLightColor,
    splashColor: kSecondaryGreen.withOpacity(.3),
    colorScheme: ThemeData().colorScheme.copyWith(
          brightness: Brightness.light,
          primary: kPrimaryLightColor,
        ),
    highlightColor: kSecondaryGreen.withOpacity(.2),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 1,
      foregroundColor: kTextColorPrimaryLight,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: kTextColorPrimaryLight,
      ),
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: kFontFamily,
    primaryColor: kPrimaryLightColor,
    splashColor: kSecondaryGreen.withOpacity(.3),
    highlightColor: kSecondaryGreen.withOpacity(.2),
    colorScheme: ThemeData().colorScheme.copyWith(
          brightness: Brightness.dark,
          primary: kPrimaryLightColor,
        ),
    appBarTheme: const AppBarTheme(
      backgroundColor: kBackgroundDarkColor,
      elevation: 1,
      foregroundColor: kTextColorPrimaryDark,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: kTextColorPrimaryDark,
      ),
    ),
  );
}

class CustomTextStyle {
  static TextStyle heading1(BuildContext context) {
    return Theme.of(context).textTheme.headline1!.copyWith(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: kTextColorPrimaryLight,
        );
  }

  static TextStyle heading2(BuildContext context) {
    return Theme.of(context).textTheme.headline2!.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: kTextColorPrimaryLight,
        );
  }

  static TextStyle heading3(BuildContext context) {
    return Theme.of(context).textTheme.headline3!.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: kTextColorPrimaryLight,
        );
  }

  static TextStyle heading4(BuildContext context) {
    return Theme.of(context).textTheme.headline4!.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: kTextColorPrimaryLight,
        );
  }

  static TextStyle bodyLarge(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge!.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: kTextColorPrimaryLight,
        );
  }

  static TextStyle bodyMedium(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: kTextColorPrimaryLight,
        );
  }

  static TextStyle bodySmall(BuildContext context) {
    return Theme.of(context).textTheme.bodySmall!.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: kTextColorPrimaryLight,
        );
  }

  static TextStyle subText(BuildContext context) {
    return Theme.of(context).textTheme.subtitle1!.copyWith(
          fontSize: 10,
          fontWeight: FontWeight.normal,
          color: kTextColorGrey,
        );
  }
}
