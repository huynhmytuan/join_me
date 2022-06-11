import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:join_me/app/bloc/app_bloc.dart';
import 'package:join_me/data/models/models.dart';
import 'package:join_me/generated/locale_keys.g.dart';
import 'package:join_me/user/cubit/search_user_cubit.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:join_me/widgets/widgets.dart';

class AddUserDialog extends StatelessWidget {
  const AddUserDialog({this.withoutUsers, Key? key}) : super(key: key);
  final List<AppUser>? withoutUsers;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: kBorderRadiusShape,
      child: RoundedContainer(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              LocaleKeys.dialog_addMember.tr(),
            ),
            const SizedBox(
              height: 10,
            ),
            const _SearchInput(),
            const _SearchResults(),
          ],
        ),
      ),
    );
  }
}

class _SearchInput extends StatelessWidget {
  const _SearchInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchUserCubit, SearchUserState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.light
                ? kTextFieldLightColor
                : kTextFieldDarkColor,
            borderRadius: BorderRadius.circular(kDefaultRadius),
          ),
          child: Row(
            children: [
              const Icon(
                Ionicons.search,
                color: kTextColorGrey,
              ),
              const SizedBox(width: 5),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    hintText: LocaleKeys.textField_searchForUser.tr(),
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      context.read<SearchUserCubit>().searchUsers(value);
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SearchResults extends StatelessWidget {
  const _SearchResults({this.withoutUsers, Key? key}) : super(key: key);
  final List<AppUser>? withoutUsers;

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AppBloc>().state.user;
    return BlocBuilder<SearchUserCubit, SearchUserState>(
      builder: (context, state) {
        return SizedBox(
          height: 280,
          child: state.results.isEmpty
              ? const SizedBox.shrink()
              : Scrollbar(
                  child: ListView.separated(
                    itemBuilder: (context, index) =>
                        isNotShowResult(state.results[index], currentUser)
                            ? const SizedBox()
                            : ListTile(
                                onTap: () {
                                  AutoRouter.of(context)
                                      .pop(state.results[index]);
                                },
                                leading: CircleAvatarWidget(
                                  imageUrl: state.results[index].photoUrl,
                                  size: 40,
                                ),
                                title: Text(
                                  state.results[index].name,
                                ),
                                subtitle: Text(
                                  state.results[index].email,
                                ),
                              ),
                    separatorBuilder: (context, index) =>
                        isNotShowResult(state.results[index], currentUser)
                            ? const SizedBox()
                            : const Divider(),
                    itemCount: state.results.length,
                  ),
                ),
        );
      },
    );
  }

  bool isNotShowResult(AppUser user, AppUser currentUser) {
    return currentUser.id == user.id ||
        (withoutUsers != null &&
            withoutUsers!.map((e) => e.id).contains(user.id));
  }
}
