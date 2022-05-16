import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:join_me/config/router/router.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/data/dummy_data.dart' as dummy_data;
import 'package:join_me/data/models/models.dart';
import 'package:join_me/project/project.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:join_me/utilities/extensions/extensions.dart';
import 'package:join_me/widgets/widgets.dart';

class SingleTaskPage extends StatefulWidget {
  const SingleTaskPage({
    @PathParam('taskId') required this.taskId,
    Key? key,
  }) : super(key: key);
  final String taskId;

  @override
  State<SingleTaskPage> createState() => _SingleTaskPageState();
}

class _SingleTaskPageState extends State<SingleTaskPage> {
  late Task _task;
  late Project _project;
  late AppUser _createdBy;
  late List<AppUser> _assignee;
  late Task _parentTask;

  void _loadData() {
    _task = dummy_data.tasksData.firstWhere((task) => task.id == widget.taskId);
    _project = dummy_data.projectsData
        .firstWhere((project) => project.id == _task.projectId);
    _createdBy =
        dummy_data.usersData.firstWhere((user) => user.id == _task.createdBy);
    _assignee = dummy_data.usersData
        .where((user) => user.id == _task.createdBy)
        .toList();
    if (_task.type == TaskType.subTask) {
      _parentTask = _task = dummy_data.tasksData.firstWhere(
        (task) => task.subTasks.contains(widget.taskId),
      );
    }
  }

  void _showDatePicker() {
    showDialog<dynamic>(
      context: context,
      builder: (context) => CustomDatePicker(
        initialDay: _task.dueDate,
      ),
    ).then((dynamic selectedDay) {
      if (selectedDay != null && selectedDay.runtimeType != DateTime) {
        return;
      }
      final dueDate = (selectedDay == null) ? null : selectedDay as DateTime;
      setState(() {
        _task = _task.copyWith(
          dueDate: dueDate,
        );
      });
    });
  }

  void _showCategoryPickerSheet() {
    _showBottomSheet(
      builder: (context) {
        return CupertinoPickerBottomSheet(
          onSubmit: (index) {
            // TODO(tuan): save to sever
            setState(() {
              _task = _task.copyWith(category: _project.categories[index]);
            });
          },
          itemExtent: CustomTextStyle.heading4(context).fontSize! + 20,
          childCount: _project.categories.length,
          initialIndex: _project.categories.indexOf(_task.category),
          itemBuilder: (context, index) => Container(
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.symmetric(
              vertical: 2,
              horizontal: 10,
            ),
            child: Text(
              _project.categories[index],
              style: CustomTextStyle.bodyMedium(context),
            ),
          ),
        );
      },
    );
  }

  void _showAssigneeEditDialog() {
    showDialog<List<AppUser>>(
      context: context,
      useRootNavigator: true,
      builder: (context) => AddUserDialog(initialUserList: _assignee),
    ).then((selectedUser) {
      if (selectedUser == null) {
        return;
      }
      final userIds = selectedUser.map((user) => user.id).toList();
      setState(() {
        _assignee = selectedUser;
        _task = _task.copyWith(assignee: userIds);
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
  void didChangeDependencies() {
    _loadData();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final appLocale = Localizations.localeOf(context);
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (_task.type == TaskType.subTask)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('This is sub task of '),
                  GestureDetector(
                    onTap: () => AutoRouter.of(context).push(
                      SingleTaskRoute(taskId: _parentTask.id),
                    ),
                    child: Text(
                      _parentTask.name,
                      style: CustomTextStyle.heading4(context).copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _task.name,
                    style: CustomTextStyle.heading3(context),
                  ),
                  const SizedBox(
                    height: kDefaultPadding,
                  ),
                  _buildDataRow(
                    context: context,
                    iconData: Ionicons.person_outline,
                    rowTitle: 'Created by',
                    rowData: Chip(
                      avatar: CircleAvatarWidget(
                        imageUrl: _createdBy.photoUrl,
                        size: 24,
                      ),
                      label: Text(
                        _createdBy.name,
                        style: CustomTextStyle.bodySmall(context),
                      ),
                    ),
                  ),
                  const Divider(),
                  _buildDataRow(
                    context: context,
                    iconData: Ionicons.time_outline,
                    rowTitle: 'Created at',
                    rowData: Text(
                      DateFormat.yMMMMEEEEd(appLocale.languageCode)
                          .format(_task.createdAt),
                    ),
                  ),
                  const Divider(),
                  _buildDataRow(
                    context: context,
                    iconData: Ionicons.time_outline,
                    rowTitle: 'Due date',
                    rowData: GestureDetector(
                      onTap: _showDatePicker,
                      child: Text(
                        _task.dueDate == null
                            ? 'No due date'
                            : DateFormat.yMMMMEEEEd(appLocale.languageCode)
                                .format(_task.dueDate!),
                      ),
                    ),
                  ),
                  const Divider(),
                  GestureDetector(
                    onTap: _showAssigneeEditDialog,
                    child: _buildDataRow(
                      context: context,
                      iconData: Ionicons.people_outline,
                      rowTitle: 'Assigned to',
                      rowData: StackImage(
                        imageUrlList:
                            _assignee.map((user) => user.photoUrl).toList(),
                        totalCount: _assignee.length,
                        imageSize: 24,
                      ),
                    ),
                  ),
                  const Divider(),
                  GestureDetector(
                    onTap: _showPriorityPickerSheet,
                    child: _buildDataRow(
                      context: context,
                      iconData: Ionicons.warning_outline,
                      rowTitle: 'Priority',
                      rowData: Chip(
                        visualDensity: VisualDensity.compact,
                        backgroundColor: _task.priority.getColor(),
                        label: Text(
                          _task.priority.toTitle(),
                          style: CustomTextStyle.bodyMedium(context)
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const Divider(),
                  GestureDetector(
                    onTap: _showCategoryPickerSheet,
                    child: _buildDataRow(
                      context: context,
                      iconData: Ionicons.menu_outline,
                      rowTitle: 'Category',
                      rowData: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 10,
                        ),
                        child: Row(
                          children: [
                            Text(
                              _task.category,
                              style: CustomTextStyle.bodyMedium(context),
                            ),
                            const Icon(
                              Ionicons.chevron_down,
                              size: 14,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Divider(),
                  Text(
                    'Description',
                    style: CustomTextStyle.heading4(context)
                        .copyWith(color: kTextColorGrey),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () async {
                      final textEdited = await AutoRouter.of(context).push(
                        TextEditingRoute(
                          initialText: _task.description,
                          hintText: 'Edit description',
                        ),
                      );
                      if (textEdited != null) {
                        setState(() {
                          _task = _task.copyWith(
                            description: textEdited as String,
                          );
                        });
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal:
                            _task.description.isEmpty ? kDefaultPadding : 0,
                        vertical: kDefaultPadding / 2,
                      ),
                      child: (_task.description.isEmpty)
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Ionicons.add),
                                Text('Add description'),
                              ],
                            )
                          : Text(
                              _task.description,
                              style: CustomTextStyle.bodyMedium(context),
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Sub-Tasks',
                    style: CustomTextStyle.heading4(context)
                        .copyWith(color: kTextColorGrey),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (_task.subTasks.isNotEmpty)
                    Builder(
                      builder: (context) {
                        final _subTasks = dummy_data.tasksData
                            .where(
                              (task) =>
                                  _task.subTasks.contains(task.id) &&
                                  task.type == TaskType.subTask,
                            )
                            .toList();
                        return Column(
                          children: _subTasks
                              .map(
                                (task) => Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      kDefaultRadius,
                                    ),
                                    border: Border.all(color: kIconColorGrey),
                                  ),
                                  child: TaskListRow(task: task),
                                ),
                              )
                              .toList(),
                        );
                      },
                    ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(
                        horizontal: kDefaultPadding / 2,
                        vertical: kDefaultPadding / 4,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          kDefaultRadius,
                        ),
                        border: Border.all(color: kIconColorGrey),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Ionicons.add_circle_outline),
                          SizedBox(
                            width: 5,
                          ),
                          Text('Add Sub-task'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: IconButton(
        onPressed: () => AutoRouter.of(context).pop(),
        icon: const Icon(Ionicons.chevron_back),
      ),
      title: Text(
        _project.name,
        style: CustomTextStyle.heading3(context),
      ),
      actions: [
        Checkbox(
          activeColor: Theme.of(context).primaryColor,
          value: _task.isComplete,
          onChanged: (value) {
            // TODO(tuan): Sync isComplete to database
            setState(() {
              _task = _task.copyWith(isComplete: value);
            });
          },
        ),
        IconButton(
          onPressed: () {
            setState(() {
              final data = dummy_data.tasksData
                  .firstWhere((task) => task.id == widget.taskId);
              _task = data;
            });
          },
          icon: const Icon(Ionicons.ellipsis_horizontal_circle_outline),
        )
      ],
    );
  }

  Row _buildDataRow({
    required BuildContext context,
    required IconData iconData,
    required String rowTitle,
    required Widget rowData,
  }) {
    return Row(
      children: [
        Icon(
          iconData,
          color: kTextColorGrey,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          rowTitle,
          style:
              CustomTextStyle.heading4(context).copyWith(color: kTextColorGrey),
        ),
        const SizedBox(
          width: kDefaultPadding,
        ),
        rowData,
      ],
    );
  }
}
