import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:join_me/app/blocs/app_bloc.dart';

import 'package:join_me/config/router/app_router.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/data/models/models.dart';
import 'package:join_me/project/bloc/project_bloc/project_bloc.dart';
import 'package:join_me/project/components/components.dart';
import 'package:join_me/task/bloc/tasks_overview_bloc.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:join_me/utilities/extensions/extensions.dart';
import 'package:join_me/widgets/dialog/custom_alert_dialog.dart';
import 'package:join_me/widgets/bottom_sheet/selection_bottom_sheet.dart';

class SingleProjectPage extends StatelessWidget {
  const SingleProjectPage({
    @PathParam('projectId') required this.projectId,
    Key? key,
  }) : super(key: key);
  final String projectId;

  @override
  Widget build(BuildContext context) {
    context.read<ProjectBloc>().add(LoadProject(projectId));
    context.read<TasksOverviewBloc>().add(LoadTasksList(projectId));
    return BlocConsumer<ProjectBloc, ProjectState>(
      listener: (context, state) {
        if (state.status == ProjectStatus.deleted) {
          AutoRouter.of(context).pop();
        }
      },
      builder: (context, state) {
        if (state.status == ProjectStatus.loading) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (state.status == ProjectStatus.success) {
          return ProjectView(
            project: state.project,
            members: state.members,
          );
        }
        return Scaffold(
          appBar: AppBar(),
          body: const Center(
            child: Text('Something went wrong'),
          ),
        );
      },
    );
  }
}

class ProjectView extends StatefulWidget {
  const ProjectView({
    required this.project,
    required this.members,
    Key? key,
  }) : super(key: key);
  final Project project;
  final List<AppUser> members;

  @override
  State<ProjectView> createState() => _ProjectViewState();
}

class _ProjectViewState extends State<ProjectView> {
  late List<PageRouteInfo> _routes;

  void _getRoute() {
    _routes = [
      ProjectDashboardRoute(projectId: widget.project.id),
      ProjectTaskListRoute(projectId: widget.project.id),
      ProjectCalendarRoute(projectId: widget.project.id),
    ];
    final route = _routes.removeAt(
      _routes.indexWhere(
        (routeInfo) =>
            routeInfo.routeName == widget.project.viewType.toRouteName(),
      ),
    );
    _routes.insert(0, route);
  }

  void _showNewTaskDialog() {
    showDialog<Task?>(
      context: context,
      builder: (context) => NewTaskDialog(
        project: widget.project,
        members: widget.members,
      ),
    ).then((task) {
      if (task != null) {
        context.read<TasksOverviewBloc>().add(AddNewTask(task));
      }
    });
  }

  Future<ProjectViewType?> _showSelectViewBottomSheet(
    BuildContext context,
  ) {
    return showModalBottomSheet<ProjectViewType>(
      useRootNavigator: true,
      barrierColor: Colors.black.withOpacity(0.5),
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        // <-- for border radius
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(kDefaultRadius),
          topRight: Radius.circular(kDefaultRadius),
        ),
      ),
      builder: (context) {
        return SelectionBottomSheet(
          title: 'View Type',
          listSelections: [
            SelectionRow(
              onTap: () {
                AutoRouter.of(context).pop(ProjectViewType.dashBoard);
              },
              title: 'Dashboard',
              iconData: Ionicons.pie_chart_outline,
            ),
            SelectionRow(
              onTap: () {
                AutoRouter.of(context).pop(ProjectViewType.listView);
              },
              title: 'List View',
              iconData: Ionicons.list_outline,
            ),
            SelectionRow(
              onTap: () {
                AutoRouter.of(context).pop(ProjectViewType.calendarView);
              },
              title: 'Calendar View',
              iconData: Ionicons.calendar_outline,
            ),
          ],
        );
      },
    );
  }

  void _showMoreMenuBottomSheet(ProjectBloc projectBloc) {
    showModalBottomSheet<ProjectViewType>(
      useRootNavigator: true,
      barrierColor: Colors.black.withOpacity(0.5),
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        // <-- for border radius
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(kDefaultRadius),
          topRight: Radius.circular(kDefaultRadius),
        ),
      ),
      builder: (context) {
        final currentUser = context.read<AppBloc>().state.user;
        final isOwner = currentUser.id == widget.project.owner;
        return SelectionBottomSheet(
          title: 'More',
          listSelections: [
            if (isOwner)
              SelectionRow(
                onTap: () {
                  AutoRouter.of(context).pop();
                  AutoRouter.of(context)
                      .push(
                    TextEditingRoute(
                      initialText: widget.project.name,
                      hintText: 'Edit Project Name',
                    ),
                  )
                      .then((textEdited) {
                    if (textEdited != null &&
                        textEdited != widget.project.description) {
                      projectBloc.add(
                        EditProject(
                          widget.project.copyWith(
                            name: textEdited as String,
                          ),
                        ),
                      );
                    }
                  });
                },
                title: 'Edit Project Name',
                iconData: Ionicons.pencil_outline,
              ),
            SelectionRow(
              onTap: () {
                AutoRouter.of(context).pop();
                AutoRouter.of(context)
                    .push(ProjectMembersRoute(projectBloc: projectBloc));
              },
              title: 'Members',
              iconData: Ionicons.people_outline,
            ),
            if (isOwner)
              SelectionRow(
                onTap: () {
                  AutoRouter.of(context).pop().then(
                        (value) => showDialog<bool>(
                          context: context,
                          builder: (context) => CustomAlertDialog(
                            title: 'Are you sure?',
                            content:
                                '''Once you delete this project, this cannot be undone.''',
                            submitButtonColor: Theme.of(context).errorColor,
                            submitLabel: 'Delete',
                            onCancel: () => AutoRouter.of(context).pop(false),
                            onSubmit: () => AutoRouter.of(context).pop(true),
                          ),
                        ).then((choice) {
                          if (choice != null && choice) {
                            projectBloc.add(DeleteProject(widget.project));
                          }
                        }),
                      );
                },
                color: Theme.of(context).errorColor,
                title: 'Delete Project',
                iconData: Ionicons.trash_bin_outline,
              )
            else
              SelectionRow(
                onTap: () {
                  AutoRouter.of(context).pop().then(
                        (value) => showDialog<bool>(
                          context: context,
                          builder: (context) => CustomAlertDialog(
                            title: 'Are you sure?',
                            content:
                                '''Once you leave this project, this cannot be read or see this project until someone add you in again.''',
                            submitButtonColor: Theme.of(context).errorColor,
                            submitLabel: 'Leave',
                            onCancel: () => AutoRouter.of(context).pop(false),
                            onSubmit: () => AutoRouter.of(context).pop(true),
                          ),
                        ).then((choice) {
                          if (choice != null && choice) {
                            projectBloc.add(
                              EditProject(
                                widget.project.copyWith(
                                  members: widget.project.members
                                    ..remove(currentUser.id),
                                ),
                              ),
                            );
                          }
                        }),
                      );
                },
                title: 'Leave Project',
                color: Theme.of(context).errorColor,
                iconData: Ionicons.log_out_outline,
              ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    _getRoute();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      resizeToAvoidBottomInset: false,
      routes: _routes,
      appBarBuilder: (context, tabsRouter) => AppBar(
        leading: IconButton(
          onPressed: () => AutoRouter.of(context).pop(),
          icon: const Icon(Ionicons.chevron_back_outline),
        ),
        actions: [
          IconButton(
            onPressed: () =>
                _showMoreMenuBottomSheet(context.read<ProjectBloc>()),
            icon: const Icon(Ionicons.ellipsis_horizontal_circle_outline),
          ),
        ],
        elevation: 0,
        title: GestureDetector(
          onTap: () {
            //Show Selections
            _showSelectViewBottomSheet(context).then(
              (viewType) {
                if (viewType == null) {
                  return;
                }
                if (viewType == widget.project.viewType) {
                  return;
                }
                final routeNames = _routes.map((e) => e.routeName).toList();
                final pageIndex = routeNames.indexOf(viewType.toRouteName());
                context.tabsRouter.setActiveIndex(pageIndex);
                context.read<ProjectBloc>().add(
                      EditProject(
                        widget.project.copyWith(viewType: viewType),
                      ),
                    );
              },
            );
          },
          child: Column(
            children: [
              Text(
                widget.project.name,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .appBarTheme
                    .titleTextStyle!
                    .copyWith(fontSize: 16),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.project.viewType.toTitle(),
                    style: CustomTextStyle.heading4(context)
                        .copyWith(color: kTextColorGrey),
                  ),
                  const Icon(
                    Ionicons.chevron_down_outline,
                    size: 15,
                    color: kTextColorGrey,
                  ),
                ],
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: widget.project.viewType != ProjectViewType.dashBoard
          ? BlocBuilder<TasksOverviewBloc, TasksOverviewState>(
              builder: (context, state) {
                return FloatingActionButton(
                  heroTag: 'new_task',
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // <-- Radius
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                  onPressed: _showNewTaskDialog,
                  child: const Icon(
                    Icons.note_add_outlined,
                    size: 30,
                  ),
                );
              },
            )
          : null,
    );
  }
}
