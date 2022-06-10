import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:join_me/app/bloc/app_bloc.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/data/models/models.dart';
import 'package:join_me/project/bloc/project_overview_bloc.dart';

import 'package:join_me/utilities/constant.dart';
import 'package:join_me/widgets/widgets.dart';

class NewProjectDialog extends StatefulWidget {
  const NewProjectDialog({Key? key}) : super(key: key);

  @override
  State<NewProjectDialog> createState() => NewProjectDialogState();
}

class NewProjectDialogState extends State<NewProjectDialog> {
  List<AppUser> _members = [];
  final _formKey = GlobalKey<FormState>();
  bool _isBUttonActive = false;
  late TextEditingController _projectNameTextController;
  late TextEditingController _descriptionTextController;
  late AppUser _currentUser;

  @override
  void initState() {
    _projectNameTextController = TextEditingController();
    _descriptionTextController = TextEditingController();
    super.initState();
  }

  void _showMembersEditDialog() {
    showDialog<List<AppUser>>(
      context: context,
      builder: (context) => EditUserDialog(
        title: 'Add Members',
        initialUserList: _members,
        withoutUsers: [context.read<AppBloc>().state.user],
      ),
    ).then((selectedUser) {
      if (selectedUser == null) {
        return;
      }
      setState(() {
        _members = selectedUser;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _currentUser = context.read<AppBloc>().state.user;
    return Dialog(
      shape: kBorderRadiusShape,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _projectNameTextController,
                  autofocus: true,
                  style: CustomTextStyle.heading3(context),
                  decoration: const InputDecoration(
                    hintText: 'Project Name',
                    border: InputBorder.none,
                  ),
                  textInputAction: TextInputAction.next,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      WidgetsBinding.instance!.addPostFrameCallback((_) {
                        setState(() {
                          _isBUttonActive = false;
                        });
                      });
                    } else {
                      WidgetsBinding.instance!.addPostFrameCallback((_) {
                        setState(() {
                          _isBUttonActive = true;
                        });
                      });
                    }
                    return null;
                  },
                ),
                const Divider(),
                TextFormField(
                  controller: _descriptionTextController,
                  style: CustomTextStyle.bodyMedium(context),
                  decoration: const InputDecoration(
                    hintText: 'Description',
                    border: InputBorder.none,
                  ),
                  maxLines: null,
                  textInputAction: TextInputAction.newline,
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: GestureDetector(
                    onTap: _showMembersEditDialog,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Icon(
                          Ionicons.people_outline,
                          color: kTextColorGrey,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        if (_members.isEmpty)
                          Text(
                            'No Member Added',
                            style: CustomTextStyle.bodyMedium(context).copyWith(
                              color: kTextColorGrey,
                            ),
                          )
                        else
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Members',
                                style:
                                    CustomTextStyle.subText(context).copyWith(
                                  color: kTextColorGrey,
                                ),
                              ),
                              StackedImages(
                                imageUrlList:
                                    _members.map((e) => e.photoUrl).toList(),
                                totalCount: _members.length,
                                imageSize: 24,
                              ),
                            ],
                          ),
                        const SizedBox(
                          width: 5,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: kDefaultPadding,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    style: ButtonStyle(
                      textStyle: MaterialStateTextStyle.resolveWith(
                        (states) {
                          if (states.contains(MaterialState.disabled)) {
                            return CustomTextStyle.bodyLarge(context);
                          }
                          return CustomTextStyle.bodyLarge(context);
                        },
                      ),
                    ),
                    onPressed: _isBUttonActive
                        ? () async {
                            final newProject = Project(
                              id: '',
                              name: _projectNameTextController.value.text,
                              createdAt: DateTime.now(),
                              owner: _currentUser.id,
                              description:
                                  _descriptionTextController.value.text,
                              members:
                                  _members.map((member) => member.id).toList()
                                    ..add(_currentUser.id),
                              categories: kDefaultTaskCategories,
                              viewType: ProjectViewType.dashBoard,
                              requests: const [],
                            );
                            context
                                .read<ProjectOverviewBloc>()
                                .add(AddProject(newProject));
                            await AutoRouter.of(context).pop();
                            // await context.
                          }
                        : null,
                    child: const Text(
                      'Create',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _projectNameTextController.dispose();
    _descriptionTextController.dispose();
    super.dispose();
  }
}
