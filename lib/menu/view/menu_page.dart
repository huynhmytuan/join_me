import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:join_me/app/bloc/app_bloc.dart';

import 'package:join_me/config/router/app_router.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/generated/locale_keys.g.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:join_me/widgets/widgets.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? kBackgroundPostLight
          : null,
      appBar: AppBar(
        elevation: 0,
        title: Text(LocaleKeys.bottomBarLabel_menu.tr()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          children: [
            const _ProfileViewCard(),
            const SizedBox(
              height: kDefaultPadding,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSettingCard(
                  context: context,
                  onTap: () => AutoRouter.of(context).push(
                    const LanguageSettingRoute(),
                  ),
                  iconData: Ionicons.globe_outline,
                  iconColor: kSecondaryBlue,
                  title: LocaleKeys.menu_language.tr(),
                ),
                const SizedBox(
                  height: kDefaultPadding,
                ),
                _buildSettingCard(
                  context: context,
                  onTap: () => AutoRouter.of(context).push(
                    const ThemeSettingRoute(),
                  ),
                  iconData: Ionicons.sunny_outline,
                  iconColor: kSecondaryYellow,
                  title: LocaleKeys.menu_theme.tr(),
                ),
                const SizedBox(
                  height: kDefaultPadding,
                ),
                _buildSettingCard(
                  context: context,
                  onTap: () => AutoRouter.of(context).push(
                    const AboutUsRoute(),
                  ),
                  iconData: Ionicons.information_circle_outline,
                  iconColor: kTextColorGrey,
                  title: LocaleKeys.menu_aboutUs.tr(),
                ),
                const SizedBox(
                  height: kDefaultPadding,
                ),
                _buildSettingCard(
                  context: context,
                  onTap: () {
                    showDialog<bool>(
                      context: context,
                      builder: (context) => CustomAlertDialog(
                        title: LocaleKeys.dialog_logOut_title.tr(),
                        content: LocaleKeys.dialog_logOut_content.tr(),
                        submitButtonColor: Theme.of(context).errorColor,
                        submitLabel: LocaleKeys.menu_logOut.tr(),
                        onCancel: () => AutoRouter.of(context).pop(false),
                        onSubmit: () => AutoRouter.of(context).pop(true),
                      ),
                    ).then((choice) {
                      if (choice != null && choice) {
                        context.read<AppBloc>().add(AppLogoutRequested());
                      }
                    });
                  },
                  iconData: Ionicons.log_out_outline,
                  iconColor: kSecondaryRed,
                  title: LocaleKeys.menu_logOut.tr(),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  GestureDetector _buildSettingCard({
    required BuildContext context,
    required VoidCallback onTap,
    required IconData iconData,
    required Color iconColor,
    required String title,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: RoundedContainer(
        color: Theme.of(context).cardColor,
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            RoundedContainer(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(10),
              color: iconColor.withOpacity(.4),
              child: Icon(
                iconData,
                color: iconColor,
                size: 24,
              ),
            ),
            Text(
              title,
              style: CustomTextStyle.heading3(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileViewCard extends StatelessWidget {
  const _ProfileViewCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () =>
              AutoRouter.of(context).push(UserInfoRoute(userId: state.user.id)),
          child: RoundedContainer(
            padding: const EdgeInsets.symmetric(
              vertical: kDefaultPadding * 2,
            ),
            color: Theme.of(context).cardColor,
            child: Center(
              child: Column(
                children: [
                  RoundedContainer(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.all(10),
                    color: kIconColorGrey,
                    child: CircleAvatarWidget(
                      imageUrl: state.user.photoUrl,
                      size: 40,
                    ),
                  ),
                  Text(
                    state.user.name,
                    style: CustomTextStyle.heading3(context),
                  ),
                  Text(
                    LocaleKeys.button_viewUserPage.tr(),
                    style: CustomTextStyle.subText(context),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
