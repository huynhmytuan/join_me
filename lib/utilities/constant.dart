import 'package:flutter/material.dart';

//  Colors
//Light Theme
const kPrimaryLightColor = Color(0xFF2eb653);
const kBackgroundPostLight = Color(0xFFf4f4f4);
const kDividerColor = Color(0xFFF4F6FA);
const kTextFieldLightColor = Color(0xFFeff3f4);
const kCardLightColor = Color(0xFFf5f8fe);

//Dark Theme
const kPrimaryDarkColor = Color(0xFF38b0a2);
const kBackgroundDarkColor = Color(0xFF131720);
const kCardDarkColor = Color(0xFF171e28);
const kTextFieldDarkColor = Color(0xFF161a23);

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
const kIconDir = 'assets/icons';

const kLogoLightDir = '$_kAssetImageDir/logo_light.png';
const kLogoDarkDir = '$_kAssetImageDir/logo_dark.png';
const kLogoBackgroundDir = '$_kAssetImageDir/logo_background.png';
const kNotFoundPicDir = '$_kAssetImageDir/no_data.png';
const kNoPostPicDir = '$_kAssetImageDir/no_post.png';
const kNoMessagePicDir = '$_kAssetImageDir/no_message.png';
const kNoProjectPicDir = '$_kAssetImageDir/no_project.png';
const kNoNotificationPicDir = '$_kAssetImageDir/no_notification.png';
const kNoDayTaskPicDir = '$_kAssetImageDir/no_day_task.png';

//Design
const kDefaultBoxShadow = [
  BoxShadow(
    color: Color(0xFFB6C6D4),
    spreadRadius: -8,
    blurRadius: 21.0,
    offset: Offset(10, 10),
  ),
  BoxShadow(
    color: Color.fromRGBO(255, 255, 255, 0.5),
    blurRadius: 6,
    offset: Offset(-3, -4),
  ),
];

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
