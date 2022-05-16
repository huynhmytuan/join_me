import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:join_me/config/router/app_router.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/data/dummy_data.dart' as dummy_data;
import 'package:join_me/data/models/models.dart';
import 'package:join_me/project/components/components.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:join_me/utilities/extensions/extensions.dart';
import 'package:join_me/widgets/selection_bottom_sheet.dart';

class SingleProjectPage extends StatefulWidget {
  const SingleProjectPage({
    @PathParam('projectId') required this.projectId,
    Key? key,
  }) : super(key: key);
  final String projectId;

  @override
  State<SingleProjectPage> createState() => _SingleProjectPageState();
}

class _SingleProjectPageState extends State<SingleProjectPage> {
  late Project _project;
  late bool _showFloatingButton;
  late List<PageRouteInfo> _routes;

  void _getProject() {
    _project = dummy_data.projectsData
        .firstWhere((proj) => proj.id == widget.projectId);
    _routes = [
      ProjectDashboardRoute(projectId: widget.projectId),
      ProjectTaskListRoute(projectId: widget.projectId),
      ProjectCalendarRoute(projectId: widget.projectId),
    ];
    _showFloatingButton =
        // ignore: avoid_bool_literals_in_conditional_expressions
        _project.viewType == ProjectViewType.dashBoard ? false : true;
    final route = _routes.removeAt(
      _routes.indexWhere(
        (routeInfo) => routeInfo.routeName == _project.viewType.toRouteName(),
      ),
    );
    _routes.insert(0, route);
  }

  void _showNewTaskDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => NewTaskDialog(
        project: _project,
      ),
    );
  }

  @override
  void initState() {
    _getProject();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      routes: _routes,
      appBarBuilder: (context, tabsRouter) => AppBar(
        leading: IconButton(
          onPressed: () => AutoRouter.of(context).pop(),
          icon: const Icon(Ionicons.chevron_back_outline),
        ),
        actions: [
          IconButton(
            onPressed: () {},
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
                if (viewType == _project.viewType) {
                  return;
                }

                final routeNames = _routes.map((e) => e.routeName).toList();
                final pageIndex = routeNames.indexOf(viewType.toRouteName());
                context.tabsRouter.setActiveIndex(pageIndex);
                setState(() {
                  if (viewType == ProjectViewType.dashBoard) {
                    _showFloatingButton = false;
                  } else {
                    _showFloatingButton = true;
                  }
                });
                _project = _project.copyWith(viewType: viewType);
              },
            );
          },
          child: Column(
            children: [
              Text(
                _project.name,
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
                    _project.viewType.toTitle(),
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
      floatingActionButton: _showFloatingButton
          ? FloatingActionButton(
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
            )
          : null,
    );
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
}
