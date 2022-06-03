import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:join_me/config/router/router.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/data/models/models.dart';
import 'package:join_me/data/repositories/repositories.dart';
import 'package:join_me/project/bloc/project_bloc.dart';

import 'package:join_me/project/project.dart';
import 'package:join_me/task/bloc/task_bloc.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:join_me/utilities/extensions/extensions.dart';
import 'package:join_me/widgets/widgets.dart';

class SingleTaskPage extends StatelessWidget {
  const SingleTaskPage({
    @PathParam('taskId') required this.taskId,
    Key? key,
  }) : super(key: key);
  final String taskId;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskBloc(
        taskRepository: context.read<TaskRepository>(),
        userRepository: context.read<UserRepository>(),
        projectRepository: context.read<ProjectRepository>(),
      )..add(LoadTask(taskId)),
      child: BlocConsumer<TaskBloc, TaskState>(
        listenWhen: (previous, current) =>
            current.status == TaskStateStatus.deleted,
        listener: (context, state) {
          if (state.status == TaskStateStatus.deleted) {
            AutoRouter.of(context).pop();
          }
        },
        builder: (context, state) {
          if (state.status == TaskStateStatus.loading) {
            return Scaffold(
              appBar: AppBar(),
              body: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (state.status == TaskStateStatus.success) {
            return const TaskView();
          }
          return Scaffold(
            appBar: AppBar(),
            body: const Center(
              child: Text('Something went wrong'),
            ),
          );
        },
      ),
    );
  }
}

class TaskView extends StatefulWidget {
  const TaskView({
    Key? key,
  }) : super(key: key);

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  void _showNewTaskDialog(TaskBloc taskBloc) {
    final project = taskBloc.state.project;
    final members = context.read<ProjectBloc>().state.members;
    showDialog<Task?>(
      context: context,
      builder: (context) => NewTaskDialog(
        project: project,
        members: members,
      ),
    ).then((task) {
      if (task != null) {
        taskBloc.add(
          AddSubTask(
            task.copyWith(
              type: TaskType.subTask,
            ),
          ),
        );
      }
    });
  }

  void _showDatePicker(TaskBloc taskBloc) {
    final task = taskBloc.state.task;
    showDialog<dynamic>(
      context: context,
      builder: (context) => CustomDatePicker(
        initialDay: task.dueDate,
      ),
    ).then((dynamic selectedDay) {
      if (selectedDay != null && selectedDay.runtimeType != DateTime) {
        return;
      }
      final dueDate = (selectedDay == null) ? null : selectedDay as DateTime;
      taskBloc.add(
        EditTask(
          task.copyWith(
            dueDate: dueDate,
          ),
        ),
      );
    });
  }

  void _showCategoryPickerSheet(TaskBloc taskBloc) {
    final task = taskBloc.state.task;
    final project = taskBloc.state.project;
    _showBottomSheet(
      builder: (context) {
        return CupertinoPickerBottomSheet(
          onSubmit: (index) {
            taskBloc.add(
              EditTask(
                task.copyWith(
                  category: taskBloc.state.project.categories[index],
                ),
              ),
            );
          },
          itemExtent: CustomTextStyle.heading4(context).fontSize! + 20,
          childCount: project.categories.length,
          initialIndex: project.categories.indexOf(task.category),
          itemBuilder: (context, index) => Container(
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.symmetric(
              vertical: 2,
              horizontal: 10,
            ),
            child: Text(
              project.categories[index],
              style: CustomTextStyle.bodyMedium(context),
            ),
          ),
        );
      },
    );
  }

  void _showAssigneeEditDialog(TaskBloc taskBloc) {
    final task = taskBloc.state.task;
    final assignee = taskBloc.state.assignee;
    final members = context.read<ProjectBloc>().state.members;
    showDialog<List<AppUser>>(
      context: context,
      useRootNavigator: true,
      builder: (context) => AddUserDialog(
        initialUserList: assignee,
        searchData: members,
      ),
    ).then((selectedUser) {
      if (selectedUser == null) {
        return;
      }
      final userIds = selectedUser.map((user) => user.id).toList();
      taskBloc.add(EditTask(task.copyWith(assignee: userIds)));
    });
  }

  void _showPriorityPickerSheet(TaskBloc taskBloc) {
    final task = taskBloc.state.task;
    _showBottomSheet(
      builder: (context) {
        final priorityList = TaskPriority.values
            .takeWhile((a) => a != TaskPriority.unknown)
            .toList();
        return CupertinoPickerBottomSheet(
          onSubmit: (index) {
            taskBloc
                .add(EditTask(task.copyWith(priority: priorityList[index])));
          },
          itemExtent: CustomTextStyle.heading4(context).fontSize! + 20,
          childCount: priorityList.length,
          initialIndex: priorityList.indexOf(task.priority),
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
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final appLocale = Localizations.localeOf(context);
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        return Scaffold(
          appBar: _buildAppBar(context, context.read<TaskBloc>()),
          body: Column(
            children: [
              if (state.task.isComplete)
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  color: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    'Task Completed',
                    style: CustomTextStyle.heading4(context).copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      if (state.task.type == TaskType.subTask)
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('This is sub task of '),
                              GestureDetector(
                                onTap: () => AutoRouter.of(context).push(
                                  SingleTaskRoute(taskId: state.parent!.id),
                                ),
                                child: Text(
                                  state.parent!.name,
                                  style: CustomTextStyle.heading4(context)
                                      .copyWith(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          kDefaultPadding,
                          5,
                          kDefaultPadding,
                          kDefaultPadding,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.task.name,
                              style: CustomTextStyle.heading2(context),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            _buildDataRow(
                              context: context,
                              iconData: Ionicons.person_outline,
                              rowTitle: 'Created by',
                              rowData: Chip(
                                avatar: CircleAvatarWidget(
                                  imageUrl: state.createdBy.photoUrl,
                                  size: 24,
                                ),
                                label: Text(
                                  state.createdBy.email,
                                  style: CustomTextStyle.bodySmall(context),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            _buildDataRow(
                              context: context,
                              iconData: Ionicons.time_outline,
                              rowTitle: 'Created at',
                              rowData: Text(
                                DateFormat.yMMMMEEEEd(appLocale.languageCode)
                                    .format(state.task.createdAt),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            _buildDataRow(
                              context: context,
                              iconData: Ionicons.time_outline,
                              rowTitle: 'Due date',
                              rowData: GestureDetector(
                                onTap: () =>
                                    _showDatePicker(context.read<TaskBloc>()),
                                child: Text(
                                  state.task.dueDate == null
                                      ? 'No due date'
                                      : DateFormat.yMMMMEEEEd(
                                          appLocale.languageCode,
                                        ).format(state.task.dueDate!),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            GestureDetector(
                              onTap: () => _showAssigneeEditDialog(
                                context.read<TaskBloc>(),
                              ),
                              child: _buildDataRow(
                                context: context,
                                iconData: Ionicons.people_outline,
                                rowTitle: 'Assigned to',
                                rowData: StackedImages(
                                  imageUrlList: state.assignee
                                      .map((user) => user.photoUrl)
                                      .toList(),
                                  totalCount: state.assignee.length,
                                  imageSize: 24,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _showPriorityPickerSheet(
                                context.read<TaskBloc>(),
                              ),
                              child: _buildDataRow(
                                context: context,
                                iconData: Ionicons.warning_outline,
                                rowTitle: 'Priority',
                                rowData: Chip(
                                  visualDensity: VisualDensity.compact,
                                  backgroundColor:
                                      state.task.priority.getColor(),
                                  label: Text(
                                    state.task.priority.toTitle(),
                                    style: CustomTextStyle.bodySmall(context)
                                        .copyWith(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _showCategoryPickerSheet(
                                context.read<TaskBloc>(),
                              ),
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
                                        state.task.category,
                                        style:
                                            CustomTextStyle.bodyMedium(context),
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
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Description',
                              style: CustomTextStyle.heading4(context)
                                  .copyWith(color: kTextColorGrey),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: () {
                                AutoRouter.of(context)
                                    .push(
                                  TextEditingRoute(
                                    initialText: state.task.description,
                                    hintText: 'Edit description',
                                  ),
                                )
                                    .then((textEdited) {
                                  if (textEdited != null) {
                                    context.read<TaskBloc>().add(
                                          EditTask(
                                            state.task.copyWith(
                                              description: textEdited as String,
                                            ),
                                          ),
                                        );
                                  }
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: state.task.description.isEmpty
                                      ? kDefaultPadding
                                      : 0,
                                  vertical: kDefaultPadding / 2,
                                ),
                                child: (state.task.description.isEmpty)
                                    ? Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: const [
                                          Icon(Ionicons.add),
                                          Text('Add description'),
                                        ],
                                      )
                                    : Text(
                                        state.task.description,
                                        style:
                                            CustomTextStyle.bodyMedium(context),
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
                            if (state.task.subTasks.isNotEmpty)
                              ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                separatorBuilder: (_, __) => const SizedBox(
                                  height: 5,
                                ),
                                itemCount: state.subTasks.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        kDefaultRadius,
                                      ),
                                      border: Border.all(color: kIconColorGrey),
                                    ),
                                    child: TaskListRow(
                                      task: state.subTasks[index],
                                      onChange: (value) => context
                                          .read<TaskBloc>()
                                          .add(
                                            EditTask(
                                              state.subTasks[index].copyWith(
                                                isComplete: value,
                                              ),
                                            ),
                                          ),
                                    ),
                                  );
                                },
                              ),
                            GestureDetector(
                              onTap: () =>
                                  _showNewTaskDialog(context.read<TaskBloc>()),
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
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
              ),
            ],
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, TaskBloc taskBloc) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(100),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => AutoRouter.of(context).pop(),
                child: Row(
                  children: [
                    const Icon(Ionicons.chevron_back),
                    Text(
                      taskBloc.state.project.name,
                      style: CustomTextStyle.heading3(context),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Checkbox(
                    activeColor: Theme.of(context).primaryColor,
                    value: taskBloc.state.task.isComplete,
                    onChanged: (value) {
                      taskBloc.add(
                        EditTask(
                          taskBloc.state.task.copyWith(isComplete: value),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    splashRadius: 10,
                    onPressed: () {
                      showDialog<bool>(
                        context: context,
                        builder: (context) => CustomAlertDialog(
                          title: 'Are you sure?',
                          content:
                              '''Once you delete this task, this cannot be undone.''',
                          submitButtonColor: Theme.of(context).errorColor,
                          submitLabel: 'Delete',
                          onCancel: () => AutoRouter.of(context).pop(false),
                          onSubmit: () => AutoRouter.of(context).pop(true),
                        ),
                      ).then((choice) {
                        if (choice != null && choice) {
                          taskBloc.add(DeleteTask(taskBloc.state.task));
                        }
                      });
                    },
                    icon: const Icon(
                      Ionicons.trash_bin_outline,
                      color: Colors.red,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
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
          size: 20,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          rowTitle,
          style: CustomTextStyle.heading4(context)
              .copyWith(color: kTextColorGrey, fontSize: 12),
        ),
        const SizedBox(
          width: kDefaultPadding,
        ),
        rowData,
      ],
    );
  }
}
