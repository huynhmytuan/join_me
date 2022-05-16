// ignore_for_file: avoid_dynamic_calls

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/data/dummy_data.dart' as dummy_data;
import 'package:join_me/data/models/models.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:join_me/widgets/avatar_circle_widget.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class AddUserDialog extends StatefulWidget {
  const AddUserDialog({
    required this.initialUserList,
    this.onSubmit,
    this.onCancel,
    this.title,
    this.withoutCurrentUser = false,
    Key? key,
  }) : super(key: key);
  final List<AppUser> initialUserList;
  final Function? onCancel;
  final Function? onSubmit;
  final String? title;
  final bool withoutCurrentUser;

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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: kBackgroundPostLight,
                    borderRadius: BorderRadius.circular(kDefaultRadius),
                    border: Border.all(
                      color: kDividerColor,
                    ),
                  ),
                  child: TypeAheadField<AppUser>(
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
                    suggestionsCallback: (pattern) async {
                      if (pattern.isEmpty) {
                        return [];
                      }
                      final returnData = dummy_data.usersData
                          .where(
                            (user) =>
                                (user.name
                                        .toLowerCase()
                                        .contains(pattern.toLowerCase()) ||
                                    user.email
                                        .toLowerCase()
                                        .contains(pattern.toLowerCase())) &&
                                !selectedUser.contains(user),
                          )
                          .toList();
                      if (widget.withoutCurrentUser) {
                        returnData.remove(dummy_data.currentUser);
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
                  ),
                ),
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
