import 'package:flutter/material.dart';
import 'package:join_me/utilities/constant.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    // fontFamily: kFontFamily,
    primaryColor: kPrimaryLightColor,
    backgroundColor: kBackgroundPostLight,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ThemeData().colorScheme.copyWith(
          brightness: Brightness.light,
          primary: kPrimaryLightColor,
        ),
    highlightColor: kSecondaryGreen.withOpacity(.2),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: kTextColorPrimaryLight,
      centerTitle: false,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: kTextColorPrimaryLight,
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      shape: kTopBorderRadiusShape,
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateColor.resolveWith(
        (states) {
          if (states.contains(MaterialState.selected)) {
            return kPrimaryLightColor;
          }
          return Colors.black;
        },
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    // fontFamily: kFontFamily,
    primaryColor: kPrimaryDarkColor,
    highlightColor: kSecondaryGreen.withOpacity(.2),
    colorScheme: ThemeData().colorScheme.copyWith(
          brightness: Brightness.dark,
          primary: kPrimaryLightColor,
        ),
    scaffoldBackgroundColor: kBackgroundDarkColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: kCardDarkColor,
      foregroundColor: kTextColorPrimaryDark,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: kTextColorPrimaryDark,
      ),
    ),
    cardColor: kCardDarkColor,
    chipTheme: const ChipThemeData(
      backgroundColor: kCardDarkColor,
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: kBackgroundDarkColor,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: kCardDarkColor,
      shape: kTopBorderRadiusShape,
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateColor.resolveWith(
        (states) {
          if (states.contains(MaterialState.selected)) {
            return kPrimaryDarkColor;
          }
          return Colors.white;
        },
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
    ),
  );
}

class CustomTextStyle {
  static TextStyle heading1(BuildContext context) {
    return Theme.of(context).textTheme.bodyText1!.copyWith(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          // color: Theme.of(context).textTheme. kTextColorPrimaryLight,
        );
  }

  static TextStyle heading2(BuildContext context) {
    return Theme.of(context).textTheme.bodyText1!.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          // color: kTextColorPrimaryLight,
        );
  }

  static TextStyle heading3(BuildContext context) {
    return Theme.of(context).textTheme.bodyText1!.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          // color: kTextColorPrimaryLight,
        );
  }

  static TextStyle heading4(BuildContext context) {
    return Theme.of(context).textTheme.bodyText1!.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          // color: kTextColorPrimaryLight,
        );
  }

  static TextStyle bodyLarge(BuildContext context) {
    return Theme.of(context).textTheme.bodyText1!.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          // color: kTextColorPrimaryLight,
        );
  }

  static TextStyle bodyMedium(BuildContext context) {
    return Theme.of(context).textTheme.bodyText1!.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          // color: kTextColorPrimaryLight,
        );
  }

  static TextStyle bodySmall(BuildContext context) {
    return Theme.of(context).textTheme.bodyText1!.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          // color: kTextColorPrimaryLight,
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
