import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:join_me/generated/locale_keys.g.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:join_me/widgets/widgets.dart';

class LanguageSettingPage extends StatelessWidget {
  const LanguageSettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? kBackgroundPostLight
          : null,
      appBar: AppBar(
        leading: RoundedIconButton(
          icon: const Icon(Ionicons.chevron_back),
          onTap: () => AutoRouter.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(LocaleKeys.menu_language.tr()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: SelectedListWidget(
          initIndex: context.supportedLocales.indexOf(context.locale),
          onSelection: (index, title) {
            log(context.supportedLocales.toString());
            log(context.locale.toString());
            switch (index) {
              case 0:
                context.resetLocale();
                break;
              case 1:
                context.setLocale(const Locale('vi', 'VN'));
                break;
              case 2:
                context.setLocale(const Locale('en', 'US'));
                break;
              default:
            }
          },
          selectionTitles: [
            LocaleKeys.language_system.tr(),
            LocaleKeys.language_vi.tr(),
            LocaleKeys.language_en.tr(),
          ],
        ),
      ),
    );
  }
}
