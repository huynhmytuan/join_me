import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:join_me/app/bloc/app_bloc.dart';
import 'package:join_me/config/router/router.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/data/models/models.dart';
import 'package:join_me/data/repositories/repositories.dart';
import 'package:join_me/generated/locale_keys.g.dart';
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
        listener: (context, state) {
          if (state.status == TaskStateStatus.deleted) {
            AutoRouter.of(context).pop();
            return;
          }
        },
        builder: (context, state) {
          if (state.status == TaskStateStatus.notFound) {
            return Scaffold(
              appBar: AppBar(),
              body: const Center(
                child: Text('Not Found'),
              ),
            );
          }
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

  void _showDatePicker(TaskBloc taskBloc, AppUser currentUser) {
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
          currentUser.id,
        ),
      );
    });
  }

  void _showCategoryPickerSheet(TaskBloc taskBloc, AppUser currentUser) {
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
                currentUser.id,
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

  void _showAssigneeEditDialog(TaskBloc taskBloc, AppUser currentUser) {
    final task = taskBloc.state.task;
    final assignee = taskBloc.state.assignee;
    final members = context.read<ProjectBloc>().state.members;
    showDialog<List<AppUser>>(
      context: context,
      useRootNavigator: true,
      builder: (context) => EditUserDialog(
        title: LocaleKeys.task_assignedTo.tr(),
        initialUserList: assignee,
        searchData: members,
      ),
    ).then((selectedUser) {
      if (selectedUser == null) {
        return;
      }
      final userIds = selectedUser.map((user) => user.id).toList();
      taskBloc.add(
        EditTask(
          task.copyWith(assignee: userIds),
          currentUser.id,
        ),
      );
    });
  }

  void _showPriorityPickerSheet(TaskBloc taskBloc, AppUser currentUser) {
    final task = taskBloc.state.task;
    _showBottomSheet(
      builder: (context) {
        final priorityList = TaskPriority.values
            .takeWhile((a) => a != TaskPriority.unknown)
            .toList();
        return CupertinoPickerBottomSheet(
          onSubmit: (index) {
            taskBloc.add(
              EditTask(
                task.copyWith(priority: priorityList[index]),
                currentUser.id,
              ),
            );
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
    final currentUser = context.read<AppBloc>().state.user;
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        return Scaffold(
          appBar: _buildAppBar(
            context,
            context.read<TaskBloc>(),
            currentUser,
          ),
          body: Column(
            children: [
              if (state.task.isComplete)
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  color: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    LocaleKeys.task_completed.tr(),
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
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  LocaleKeys.task_subTaskOf.tr(),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => AutoRouter.of(context).push(
                                  SingleTaskRoute(taskId: state.parent!.id),
                                ),
                                child: Text(
                                  state.parent!.name,
                                  overflow: TextOverflow.ellipsis,
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
                            GestureDetector(
                              onTap: () {
                                AutoRouter.of(context)
                                    .push(
                                  TextEditingRoute(
                                    initialText: state.task.name,
                                    hintText: LocaleKeys.task_name.tr(),
                                  ),
                                )
                                    .then((textEdited) {
                                  if (textEdited != null &&
                                      textEdited != state.task.name) {
                                    final task = state.task;
                                    context.read<TaskBloc>().add(
                                          EditTask(
                                            task.copyWith(
                                              name: textEdited as String,
                                            ),
                                            currentUser.id,
                                          ),
                                        );
                                  }
                                });
                              },
                              child: Text(
                                state.task.name,
                                style: CustomTextStyle.heading2(context),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            _buildDataRow(
                              context: context,
                              iconData: Ionicons.person_outline,
                              rowTitle: LocaleKeys.task_createdBy.tr(),
                              rowData: Chip(
                                avatar: CircleAvatarWidget(
                                  imageUrl: state.createdBy.photoUrl,
                                  size: 24,
                                ),
                                label: Text(
                                  state.createdBy.email.isEmpty
                                      ? state.createdBy.name
                                      : state.createdBy.email,
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
                              rowTitle: LocaleKeys.properties_createdAt.tr(),
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
                              rowTitle: LocaleKeys.task_dueDate.tr(),
                              rowData: GestureDetector(
                                onTap: () => _showDatePicker(
                                  context.read<TaskBloc>(),
                                  currentUser,
                                ),
                                child: Text(
                                  state.task.dueDate == null
                                      ? LocaleKeys.task_noDueDate.tr()
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
                                currentUser,
                              ),
                              child: _buildDataRow(
                                context: context,
                                iconData: Ionicons.people_outline,
                                rowTitle: LocaleKeys.task_assignedTo.tr(),
                                rowData: StackedImages(
                                  imageUrlList: state.assignee
                                      .map((user) => user.photoUrl)
                                      .toList(),
                                  totalCount: state.assignee.length,
                                  imageSize: 24,
                                  emptyHandler: Text(
                                    LocaleKeys.task_unAssigned.tr(),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _showPriorityPickerSheet(
                                context.read<TaskBloc>(),
                                currentUser,
                              ),
                              child: _buildDataRow(
                                context: context,
                                iconData: Ionicons.warning_outline,
                                rowTitle: LocaleKeys.task_priority_title.tr(),
                                rowData: Chip(
                                  visualDensity: VisualDensity.compact,
                                  backgroundColor:
                                      state.task.priority.getColor(),
                                  label: Text(
                                    "task.priority.${state.task.priority.name}"
                                        .tr(),
                                    style: CustomTextStyle.bodySmall(context)
                                        .copyWith(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _showCategoryPickerSheet(
                                context.read<TaskBloc>(),
                                currentUser,
                              ),
                              child: _buildDataRow(
                                context: context,
                                iconData: Ionicons.menu_outline,
                                rowTitle: LocaleKeys.task_category.tr(),
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
                              LocaleKeys.properties_description.tr(),
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
                                    hintText:
                                        LocaleKeys.button_addDescription.tr(),
                                  ),
                                )
                                    .then((textEdited) {
                                  if (textEdited != null) {
                                    context.read<TaskBloc>().add(
                                          EditTask(
                                            state.task.copyWith(
                                              description: textEdited as String,
                                            ),
                                            currentUser.id,
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
                                        children: [
                                          const Icon(Ionicons.add),
                                          Text(
                                            LocaleKeys.button_addDescription
                                                .tr(),
                                          ),
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
                              LocaleKeys.task_subTasks.tr(),
                              style: CustomTextStyle.heading4(context)
                                  .copyWith(color: kTextColorGrey),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            if (state.task.subTasks.isNotEmpty)
                              Builder(
                                builder: (context) {
                                  final subTasksOrderByCreatedAt =
                                      List.of(state.subTasks)
                                        ..sort(
                                          (a, b) => a.createdAt
                                              .compareTo(b.createdAt),
                                        );
                                  return ListView.separated(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
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
                                          border:
                                              Border.all(color: kIconColorGrey),
                                        ),
                                        child: TaskListRow(
                                          isShowPriorityColor: false,
                                          task: subTasksOrderByCreatedAt[index],
                                          onChange: (value) =>
                                              context.read<TaskBloc>().add(
                                                    EditTask(
                                                      subTasksOrderByCreatedAt[
                                                              index]
                                                          .copyWith(
                                                        isComplete: value,
                                                      ),
                                                      currentUser.id,
                                                    ),
                                                  ),
                                        ),
                                      );
                                    },
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
                                  children: [
                                    const Icon(Ionicons.add_circle_outline),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(LocaleKeys.task_addSubTask.tr()),
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

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    TaskBloc taskBloc,
    AppUser currentUser,
  ) {
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
                          currentUser.id,
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
                          title: LocaleKeys.dialog_delete_title.tr(),
                          content: LocaleKeys.dialog_delete_content.tr(),
                          submitButtonColor: Theme.of(context).errorColor,
                          submitLabel: LocaleKeys.button_delete.tr(),
                          onCancel: () => AutoRouter.of(context).pop(false),
                          onSubmit: () => AutoRouter.of(context).pop(true),
                        ),
                      ).then((choice) {
                        if (choice != null && choice) {
                          taskBloc.add(DeleteTask(taskBloc.state.task));
                          AutoRouter.of(context).pop();
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
