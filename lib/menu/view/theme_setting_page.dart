import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:join_me/config/cubit/theme_cubit.dart';
import 'package:join_me/generated/locale_keys.g.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:join_me/widgets/widgets.dart';

class ThemeSettingPage extends StatelessWidget {
  const ThemeSettingPage({Key? key}) : super(key: key);

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
        title: Text(LocaleKeys.menu_theme.tr()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            return SelectedListWidget(
              initIndex: state.themeMode.index,
              onSelection: (index, title) {
                switch (index) {
                  case 0:
                    context.read<ThemeCubit>().setSystem();
                    break;
                  case 1:
                    context.read<ThemeCubit>().setLightTheme();
                    break;
                  case 2:
                    context.read<ThemeCubit>().setDarkTheme();
                    break;
                  default:
                    context.read<ThemeCubit>().setSystem();
                    break;
                }
              },
              selectionTitles: [
                LocaleKeys.theme_system.tr(),
                LocaleKeys.theme_light.tr(),
                LocaleKeys.theme_dark.tr(),
              ],
            );
          },
        ),
      ),
    );
  }
}
