import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/utilities/extensions/extensions.dart';
import 'package:join_me/data/dummy_data.dart' as dummy_data;
import 'package:join_me/data/models/models.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:join_me/widgets/widgets.dart';

class NewTaskDialog extends StatefulWidget {
  const NewTaskDialog({
    required this.project,
    this.parentTask,
    Key? key,
  }) : super(key: key);

  ///If this is sub-task this must not be null;
  final Task? parentTask;

  ///Project which this task belong to;
  final Project project;
  @override
  State<NewTaskDialog> createState() => NewTaskDialogState();
}

class NewTaskDialogState extends State<NewTaskDialog> {
  Task _task = Task.empty();
  List<AppUser> _assignees = [];
  final _formKey = GlobalKey<FormState>();
  bool _isBUttonActive = false;

  @override
  void initState() {
    super.initState();
  }

  void _showMembersEditDialog() {
    showDialog<List<AppUser>>(
      context: context,
      builder: (context) => AddUserDialog(
        initialUserList: _assignees,
      ),
    ).then((selectedUser) {
      if (selectedUser == null) {
        return;
      }
      setState(() {
        _assignees = selectedUser;
        _task = _task.copyWith(assignee: _assignees.map((e) => e.id).toList());
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
            // TODO(tuan): save to sever
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
                TextFormField(
                  autofocus: true,
                  style: CustomTextStyle.heading4(context),
                  decoration: const InputDecoration(
                    hintText: 'Task name',
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
                  },
                ),
                const Divider(),
                TextFormField(
                  style: CustomTextStyle.bodyMedium(context),
                  decoration: const InputDecoration(
                    hintText: 'Description',
                    border: InputBorder.none,
                  ),
                  maxLines: null,
                  textInputAction: TextInputAction.newline,
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildAssignees(context),
                    _buildDueDate(context),
                  ],
                ),
                const Divider(),
                GestureDetector(
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
                    onPressed: _isBUttonActive ? () {} : null,
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
                  StackImage(
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
