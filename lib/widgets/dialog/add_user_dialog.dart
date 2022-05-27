// ignore_for_file: avoid_dynamic_calls

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'package:join_me/config/theme.dart';
import 'package:join_me/data/models/models.dart';
import 'package:join_me/data/repositories/user_repository.dart';
import 'package:join_me/user/bloc/users_search_bloc.dart';
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
  late UsersSearchBloc _userBloc;
  @override
  void initState() {
    _userBloc = UsersSearchBloc(userRepository: UserRepository());
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
        color: kBackgroundPostLight,
        borderRadius: BorderRadius.circular(kDefaultRadius),
        border: Border.all(
          color: kDividerColor,
        ),
      ),
      child: BlocBuilder<UsersSearchBloc, UsersSearchState>(
        bloc: _userBloc,
        builder: (context, state) {
          return TypeAheadField<AppUser>(
            hideSuggestionsOnKeyboardHide: false,
            hideOnLoading: true,
            textFieldConfiguration: const TextFieldConfiguration(
              autofocus: true,
              decoration: InputDecoration(
                isDense: true,
                hintText: 'Search for username or email',
                border: InputBorder.none,
              ),
            ),
            suggestionsCallback: (pattern) {
              if (pattern.isEmpty) {
                return [];
              }
              var returnData = <AppUser>[];

              //Check if search data is null
              if (widget.searchData != null) {
                returnData = widget.searchData!
                    .where(
                      (user) =>
                          user.name
                              .toLowerCase()
                              .contains(pattern.toLowerCase()) ||
                          user.email.toLowerCase().contains(
                                pattern.toLowerCase(),
                              ),
                    )
                    .toList();
              } else {
                //Search User by UserBloc
                _userBloc.add(
                  SearchUserByName(searchString: pattern),
                );
                if (state is UserSearchResult) {
                  returnData = state.searchResults;
                  returnData = List.from(
                    Set<AppUser>.from(returnData).difference(
                      Set<AppUser>.from(selectedUser),
                    ),
                  );
                }
              }
              if (widget.withoutUsers.isNotEmpty) {
                for (final user in widget.withoutUsers) {
                  returnData.remove(user);
                }
              }
              return returnData;
            },
            noItemsFoundBuilder: (context) => const ListTile(
              title: Text('No user found.'),
            ),
            itemBuilder: (context, userSuggestion) {
              return ListTile(
                leading: CircleAvatarWidget(
                  imageUrl: userSuggestion.photoUrl,
                ),
                title: Text(userSuggestion.name),
                subtitle: Text(userSuggestion.email),
              );
            },
            onSuggestionSelected: (userSuggestion) {
              setState(() {
                selectedUser.add(userSuggestion);
              });
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
    _userBloc.close();
    searchTextController.dispose();
    super.dispose();
  }
}
