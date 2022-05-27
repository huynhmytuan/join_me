import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:join_me/app/blocs/app_bloc.dart';

import 'package:join_me/config/router/app_router.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:join_me/widgets/widgets.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _currentUser = context.read<AppBloc>().state.user;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Menu'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => AutoRouter.of(context)
                  .push(UserInfoRoute(userId: _currentUser.id)),
              child: RoundedContainer(
                padding: const EdgeInsets.symmetric(
                  vertical: kDefaultPadding * 2,
                ),
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Center(
                  child: Column(
                    children: [
                      RoundedContainer(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.all(10),
                        color: kIconColorGrey,
                        child: CircleAvatarWidget(
                          imageUrl: _currentUser.photoUrl,
                          size: 40,
                        ),
                      ),
                      Text(
                        _currentUser.name,
                        style: CustomTextStyle.heading3(context),
                      ),
                      Text(
                        'Show your profile page',
                        style: CustomTextStyle.subText(context),
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: kDefaultPadding,
            ),
            SizedBox(
              height: 170,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSettingCard(
                    context: context,
                    onTap: () => AutoRouter.of(context).push(
                      const LanguageSettingRoute(),
                    ),
                    iconData: Ionicons.globe_outline,
                    iconColor: kSecondaryBlue,
                    title: 'Language',
                  ),
                  _buildSettingCard(
                    context: context,
                    onTap: () => AutoRouter.of(context).push(
                      const ThemeSettingRoute(),
                    ),
                    iconData: Ionicons.sunny_outline,
                    iconColor: kSecondaryYellow,
                    title: 'Theme',
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: kDefaultPadding,
            ),
            SizedBox(
              height: 170,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSettingCard(
                    context: context,
                    onTap: () => AutoRouter.of(context).push(
                      const AboutUsRoute(),
                    ),
                    iconData: Ionicons.information_circle_outline,
                    iconColor: kTextColorGrey,
                    title: 'About Us',
                  ),
                  _buildSettingCard(
                    context: context,
                    onTap: () {
                      context.read<AppBloc>().add(AppLogoutRequested());
                    },
                    iconData: Ionicons.log_out_outline,
                    iconColor: kSecondaryRed,
                    title: 'Logout',
                  ),
                ],
              ),
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
      child: AspectRatio(
        aspectRatio: 1,
        child: RoundedContainer(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RoundedContainer(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.symmetric(vertical: 10),
                color: kIconColorGrey,
                child: Icon(
                  iconData,
                  color: iconColor,
                  size: 40,
                ),
              ),
              Text(
                title,
                style: CustomTextStyle.heading3(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
