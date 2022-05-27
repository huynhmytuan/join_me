import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:join_me/app/blocs/app_bloc.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/data/dummy_data.dart';
import 'package:join_me/data/models/models.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:join_me/utilities/extensions/extensions.dart';
import 'package:join_me/widgets/widgets.dart';

class NewTaskDialog extends StatefulWidget {
  const NewTaskDialog({
    required this.project,
    required this.members,
    this.parentTask,
    Key? key,
  }) : super(key: key);

  ///If this is sub-task this must not be null;
  final Task? parentTask;

  ///Project which this task belong to;
  final Project project;

  final List<AppUser> members;
  @override
  State<NewTaskDialog> createState() => NewTaskDialogState();
}

class NewTaskDialogState extends State<NewTaskDialog> {
  var _task = Task.empty();
  List<AppUser> _assignees = [];
  final _formKey = GlobalKey<FormState>();
  final _taskNameEditController = TextEditingController();
  final _taskDescriptionEditController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void _showMembersEditDialog() {
    showDialog<List<AppUser>>(
      context: context,
      builder: (context) => AddUserDialog(
        initialUserList: _assignees,
        searchData: widget.members,
        title: 'Assign to',
      ),
    ).then((selectedUser) {
      if (selectedUser == null) {
        return;
      }
      setState(() {
        _assignees = selectedUser;
      });
    });
  }

  void _showDatePicker() {
    showDialog<dynamic>(
      context: context,
      builder: (_) => CustomDatePicker(
        initialDay: _task.dueDate,
      ),
    ).then((dynamic selectedDay) {
      if (selectedDay != null && selectedDay.runtimeType != DateTime) {
        return;
      }
      final dueDate = selectedDay == null ? null : selectedDay as DateTime;
      setState(() {
        _task = _task.copyWith(dueDate: dueDate);
      });
    });
  }

  void _showPriorityPickerSheet() {
    _showBottomSheet(
      builder: (context) {
        final priorityList = TaskPriority.values
            .takeWhile((a) => a != TaskPriority.unknown)
            .toList();
        return CupertinoPickerBottomSheet(
          onSubmit: (index) {
            setState(() {
              _task = _task.copyWith(priority: priorityList[index]);
            });
          },
          itemExtent: CustomTextStyle.heading4(context).fontSize! + 20,
          childCount: priorityList.length,
          initialIndex: priorityList.indexOf(_task.priority),
          itemBuilder: (context, index) => Container(
            decoration: BoxDecoration(
              color: priorityList[index].getColor(),
              borderRadius: BorderRadius.circular(kDefaultRadius),
            ),
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.symmetric(
              vertical: 2,
              horizontal: 10,
            ),
            child: Text(
              priorityList[index].toTitle(),
              style: CustomTextStyle.bodyMedium(context)
                  .copyWith(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  void _showBottomSheet({
    required Widget Function(BuildContext) builder,
  }) {
    showModalBottomSheet<dynamic>(
      context: context,
      shape: kTopBorderRadiusShape,
      useRootNavigator: true,
      barrierColor: Colors.black.withOpacity(0.5),
      isScrollControlled: true,
      builder: builder,
    );
  }

  @override
  Widget build(BuildContext context) {
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
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    'Add Task',
                    style: CustomTextStyle.heading3(context),
                  ),
                ),
                _buildNameInput(context),
                const Divider(),
                _buildDescriptionInput(context),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildAssignees(context),
                    _buildDueDate(context),
                  ],
                ),
                const Divider(),
                _buildPriority(context),
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
                    onPressed: _taskNameEditController.text.isNotEmpty
                        ? () {
                            AutoRouter.of(context).pop(
                              _task.copyWith(
                                createdAt: DateTime.now(),
                                createdBy:
                                    context.read<AppBloc>().state.user.id,
                                projectId: widget.project.id,
                                name: _taskNameEditController.text,
                                description:
                                    _taskDescriptionEditController.text,
                                assignee:
                                    _assignees.map((user) => user.id).toList(),
                              ),
                            );
                          }
                        : null,
                    child: const Text(
                      'Create',
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField _buildDescriptionInput(BuildContext context) {
    return TextFormField(
      controller: _taskDescriptionEditController,
      style: CustomTextStyle.bodyMedium(context),
      decoration: const InputDecoration(
        hintText: 'Description',
        border: InputBorder.none,
      ),
      maxLines: null,
      textInputAction: TextInputAction.newline,
    );
  }

  TextFormField _buildNameInput(BuildContext context) {
    return TextFormField(
      controller: _taskNameEditController,
      autofocus: true,
      style: CustomTextStyle.heading4(context),
      decoration: const InputDecoration(
        hintText: 'Task name',
        border: InputBorder.none,
      ),
      textInputAction: TextInputAction.next,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (value) {
        setState(() {});
      },
    );
  }

  GestureDetector _buildPriority(BuildContext context) {
    return GestureDetector(
      onTap: _showPriorityPickerSheet,
      child: Row(
        children: [
          const Icon(
            Ionicons.warning_outline,
            color: kTextColorGrey,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            'Priority',
            style: CustomTextStyle.bodyMedium(context)
                .copyWith(color: kTextColorGrey),
          ),
          const SizedBox(
            width: kDefaultPadding,
          ),
          Chip(
            visualDensity: VisualDensity.compact,
            backgroundColor: _task.priority.getColor(),
            label: Text(
              _task.priority.toTitle(),
              style: CustomTextStyle.bodySmall(context)
                  .copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Padding _buildAssignees(BuildContext context) {
    return Padding(
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
            if (_assignees.isEmpty)
              Text(
                'Unassigned ',
                style: CustomTextStyle.bodyMedium(context).copyWith(
                  color: kTextColorGrey,
                ),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Assignees',
                    style: CustomTextStyle.subText(context).copyWith(
                      color: kTextColorGrey,
                    ),
                  ),
                  StackedImages(
                    imageUrlList: _assignees.map((e) => e.photoUrl).toList(),
                    totalCount: _assignees.length,
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
    );
  }

  Padding _buildDueDate(BuildContext context) {
    final appLocale = Localizations.localeOf(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: GestureDetector(
        onTap: _showDatePicker,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Icon(
              Ionicons.calendar_number_outline,
              color: kTextColorGrey,
            ),
            const SizedBox(
              width: 5,
            ),
            if (_task.dueDate == null)
              Text(
                'No Due Date',
                style: CustomTextStyle.bodyMedium(context).copyWith(
                  color: kTextColorGrey,
                ),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Due to',
                    style: CustomTextStyle.subText(context).copyWith(
                      color: kTextColorGrey,
                    ),
                  ),
                  Text(
                    DateFormat.yMMMd(appLocale.languageCode)
                        .format(_task.dueDate!),
                  ),
                ],
              ),
            const SizedBox(
              width: 5,
            ),
          ],
        ),
      ),
    );
  }
}
