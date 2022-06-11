import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:join_me/generated/locale_keys.g.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:join_me/widgets/widgets.dart';

class LanguageSettingPage extends StatelessWidget {
  const LanguageSettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                context.setLocale(const Locale('en', 'US'));
                break;
              case 1:
                context.setLocale(const Locale('vi', 'VI'));

                break;
              default:
            }
          },
          selectionTitles: [
            LocaleKeys.language_en.tr(),
            LocaleKeys.language_vi.tr(),
          ],
        ),
      ),
    );
  }
}
