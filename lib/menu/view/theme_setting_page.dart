import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:join_me/generated/locale_keys.g.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:join_me/widgets/widgets.dart';

class ThemeSettingPage extends StatelessWidget {
  const ThemeSettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(LocaleKeys.menu_theme.tr()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: SelectedListWidget(
          onSelection: (index, title) {},
          selectionTitles: [
            LocaleKeys.theme_light.tr(),
            LocaleKeys.theme_dark.tr(),
            LocaleKeys.theme_system.tr(),
          ],
        ),
      ),
    );
  }
}
