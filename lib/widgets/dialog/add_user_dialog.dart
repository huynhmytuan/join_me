// ignore_for_file: avoid_dynamic_calls

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'package:join_me/config/theme.dart';
import 'package:join_me/data/models/models.dart';
import 'package:join_me/user/cubit/search_user_cubit.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:join_me/widgets/avatar_circle_widget.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class AddUserDialog extends StatefulWidget {
  const AddUserDialog({
    this.initialUserList = const [],
    this.onSubmit,
    this.onCancel,
    this.title,
    this.withoutUsers = const [],
    this.searchData,
    Key? key,
  }) : super(key: key);
  final List<AppUser> initialUserList;
  final Function? onCancel;
  final Function? onSubmit;
  final String? title;
  final List<AppUser> withoutUsers;
  final List<AppUser>? searchData;

  @override
  State<AddUserDialog> createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  List<AppUser> selectedUser = [];
  final searchTextController = TextEditingController();

  @override
  void initState() {
    selectedUser.addAll(widget.initialUserList);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: kBorderRadiusShape,
      child: KeyboardDismisser(
        // ignore: avoid_redundant_argument_values
        gestures: const [GestureType.onTap],
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        widget.onCancel?.call();
                        AutoRouter.of(context).pop();
                      },
                      child: Text(
                        'Cancel',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    Text(
                      widget.title ?? 'Edit Members',
                      style: CustomTextStyle.heading3(context),
                    ),
                    TextButton(
                      onPressed: () {
                        widget.onSubmit?.call();
                        AutoRouter.of(context).pop(selectedUser);
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
                _buildSearchField(),
                SizedBox(
                  height: 250,
                  child: _buildSelectionView(selectedUser),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container _buildSearchField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? kTextFieldLightColor
            : kTextFieldDarkColor,
        borderRadius: BorderRadius.circular(kDefaultRadius),
      ),
      child: BlocBuilder<SearchUserCubit, SearchUserState>(
        builder: (context, state) {
          return TypeAheadFormField<AppUser?>(
            textFieldConfiguration: const TextFieldConfiguration(
              autofocus: true,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
            ),
            itemBuilder: (BuildContext context, user) {
              if (widget.withoutUsers.contains(user)) {
                return const SizedBox();
              }
              return ListTile(
                leading: CircleAvatarWidget(imageUrl: user!.photoUrl),
                title: Text(user.name),
              );
            },
            suggestionsBoxDecoration: SuggestionsBoxDecoration(
              color: Theme.of(context).cardColor,
              shape: kBorderRadiusShape,
            ),
            hideOnError: true,
            hideOnLoading: true,
            onSuggestionSelected: (AppUser? user) {
              setState(() {
                selectedUser.add(user!);
              });
            },
            suggestionsCallback: (String pattern) {
              if (widget.searchData != null) {
                return widget.searchData!.where(
                  (element) => element.name.toLowerCase().contains(
                        pattern.toLowerCase(),
                      ),
                );
              }
              return context.read<SearchUserCubit>().searchUsers(pattern);
            },
          );
        },
      ),
    );
  }

  Widget _buildSelectionView(List<AppUser> selectedUser) {
    return (selectedUser.isEmpty)
        ? const Center(
            child: Text('No user selected.'),
          )
        : SingleChildScrollView(
            child: Wrap(
              children: selectedUser
                  .map(
                    (user) => Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 2,
                      ),
                      child: Chip(
                        avatar: CircleAvatarWidget(
                          imageUrl: user.photoUrl,
                        ),
                        label: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 100,
                          ),
                          child: Text(
                            user.name,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        onDeleted: () {
                          setState(() {
                            selectedUser.remove(user);
                          });
                        },
                      ),
                    ),
                  )
                  .toList(),
            ),
          );
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }
}
