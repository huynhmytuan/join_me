import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:join_me/app/bloc/app_bloc.dart';
import 'package:join_me/config/router/app_router.dart';
import 'package:join_me/generated/locale_keys.g.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:join_me/widgets/avatar_circle_widget.dart';
import 'package:join_me/widgets/rounded_container.dart';

class NewPostCard extends StatelessWidget {
  const NewPostCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return RoundedContainer(
          margin: const EdgeInsets.fromLTRB(
            kDefaultPadding / 2,
            kDefaultPadding / 2,
            kDefaultPadding / 2,
            5,
          ),
          color: Theme.of(context).cardColor,
          child: Padding(
            padding: const EdgeInsets.all(kDefaultPadding / 2),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => AutoRouter.of(context)
                      .push(UserInfoRoute(userId: state.user.id)),
                  child: CircleAvatarWidget(imageUrl: state.user.photoUrl),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        AutoRouter.of(context).push(const NewPostRoute());
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding,
                          vertical: 5,
                        ),
                        child: Text(LocaleKeys.textField_whatOnYourMind.tr()),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
