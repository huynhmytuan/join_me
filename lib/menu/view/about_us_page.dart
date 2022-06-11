import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:join_me/generated/locale_keys.g.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(LocaleKeys.menu_aboutUs.tr()),
      ),
      body: const Text('data'),
    );
  }
}
