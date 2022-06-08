import 'package:flutter/material.dart';

//  Colors
//Light Theme
const kPrimaryLightColor = Color(0xFF2eb653);
const kBackgroundPostLight = Color(0xFFF5F5F5);
const kDividerColor = Color(0xFFF4F6FA);
const kTextFieldLightColor = Color(0xFFeff3f4);

//Dark Theme
const kPrimaryDarkColor = Color(0xFF38b0a2);
const kBackgroundDarkColor = Color(0xFF122333);
const kCardDarkColor = Color(0xFF182b3c);
const kTextFieldDarkColor = Color(0xFF21374a);

//Secondary Colors
const kSecondaryRed = Color(0xFFFF4F4F);
const kSecondaryBlue = Color(0xFF0066FF);
const kSecondaryGreen = Color(0xFF5CD4A8);
const kSecondaryYellow = Color(0xFFFFC633);

//Icon Colors
const kIconColorLight = Color(0xFFFFFFFF);
const kIconColorGrey = Color(0xFFE7E7E7);

// Text Colors
const kTextColorPrimaryLight = Color(0xFF030F2D);
const kTextColorGrey = Color(0xFFB6B5BA);
const kTextColorPrimaryDark = Color(0xFFffffff);

const kShadowColor = Color(0xFF364564);

const kDefaultPadding = 20.0;
const kDefaultRadius = 15.0;

//Text
const kFontFamily = 'Nunito';

//Asset Constant
const _kAssetImageDir = 'assets/images';
const kLogoLightDir = '$_kAssetImageDir/logo_light.png';
const kLogoDarkDir = '$_kAssetImageDir/logo_dark.png';
const kLogoBackgroundDir = '$_kAssetImageDir/logo_background.png';
const kIconDir = 'assets/icons';

//Design
final kDefaultBoxShadow = BoxShadow(
  color: kShadowColor.withOpacity(.1),
  blurRadius: 20,
  offset: const Offset(0, 10),
);

const kTopBorderRadiusShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(kDefaultRadius),
    topRight: Radius.circular(kDefaultRadius),
  ),
);
const kBorderRadiusShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.all(
    Radius.circular(kDefaultRadius),
  ),
);

const kDefaultTaskCategories = [
  'To-do',
  'In-process',
  'Complete',
];
