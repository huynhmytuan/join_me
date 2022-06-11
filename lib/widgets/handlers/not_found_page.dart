import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/generated/locale_keys.g.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:join_me/widgets/rounded_button.dart';
import 'package:join_me/widgets/rounded_icon_button.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: RoundedIconButton(
          icon: const Icon(Ionicons.chevron_back),
          onTap: () => AutoRouter.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          const Spacer(),
          Image.asset(
            kNotFoundPicDir,
            width: screenSize.width * .70,
          ),
          Center(
            child: Text(
              LocaleKeys.errorMessage_wrong.tr(),
              textAlign: TextAlign.center,
              style: CustomTextStyle.heading2(context),
            ),
          ),
          RoundedButton(
            child: Text(LocaleKeys.button_backToHome.tr()),
            onPressed: () {
              AutoRouter.of(context).popUntilRoot();
            },
          ),
          const Spacer(
            flex: 2,
          ),
        ],
      ),
    );
  }
}
