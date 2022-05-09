import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:join_me/config/router/app_router.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/data/dummy_data.dart' as dummy_data;
import 'package:join_me/data/models/models.dart';
import 'package:join_me/utilities/constant.dart';

class SingleProjectPage extends StatefulWidget {
  const SingleProjectPage({
    @pathParam required this.projectId,
    Key? key,
  }) : super(key: key);
  final String projectId;

  @override
  State<SingleProjectPage> createState() => _SingleProjectPageState();
}

class _SingleProjectPageState extends State<SingleProjectPage> {
  late Project _project;
  bool _showFloatingButton = false;

  @override
  void initState() {
    _getProject();
    super.initState();
  }

  void _getProject() {
    _project = dummy_data.projectsData
        .firstWhere((proj) => proj.id == widget.projectId);
  }

  @override
  void didChangeDependencies() {
    _getProject();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      appBarBuilder: (context, tabsRouter) {
        return AppBar(
          leading: IconButton(
            onPressed: () => AutoRouter.of(context).pop(),
            icon: const Icon(Ionicons.chevron_back_outline),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Ionicons.person_add_outline),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Ionicons.ellipsis_horizontal_circle_outline),
            ),
          ],
          elevation: 0,
          title: Column(
            children: [
              Text(
                _project.name,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .appBarTheme
                    .titleTextStyle!
                    .copyWith(fontSize: 16),
              ),
              InkWell(
                onTap: () {
                  //Show Selections
                  _showSelectViewBottomSheet(context).then(
                    (dynamic value) {
                      if (value == null) {
                        return;
                      }
                      tabsRouter.setActiveIndex(value as int);
                      if (value == 0) {
                        setState(() {
                          _showFloatingButton = false;
                        });
                      } else {
                        setState(() {
                          _showFloatingButton = true;
                        });
                      }
                    },
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Builder(
                      builder: (context) {
                        // ignore: unused_local_variable
                        late String viewType;
                        switch (tabsRouter.current.name) {
                          case ProjectDashboardRoute.name:
                            viewType = 'Dashboard';
                            break;
                          case ProjectTaskListRoute.name:
                            viewType = 'Tasks List';
                            break;
                          case ProjectCalendarRoute.name:
                            viewType = 'Tasks Calendar';
                            break;
                          default:
                            viewType = 'Dashboard';
                            break;
                        }
                        return Text(
                          viewType,
                          style: CustomTextStyle.heading4(context)
                              .copyWith(color: kTextColorGrey),
                        );
                      },
                    ),
                    const Icon(
                      Ionicons.chevron_down_outline,
                      size: 15,
                      color: kTextColorGrey,
                    ),
                  ],
                ),
              )
            ],
          ),
          centerTitle: true,
        );
      },
      routes: [
        ProjectDashboardRoute(projectId: widget.projectId),
        ProjectTaskListRoute(projectId: widget.projectId),
        ProjectCalendarRoute(projectId: widget.projectId),
      ],
      floatingActionButton: _showFloatingButton
          ? FloatingActionButton(
              heroTag: 'new_task',
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // <-- Radius
              ),
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () {},
              child: const Icon(
                Icons.note_add_outlined,
                size: 30,
              ),
            )
          : null,
    );
  }

  Future<dynamic> _showSelectViewBottomSheet(BuildContext context) {
    return showModalBottomSheet<dynamic>(
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
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Align(
              alignment: Alignment.topCenter,
              child: Icon(
                Ionicons.remove,
                size: 40,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                kDefaultPadding,
                0,
                kDefaultPadding,
                kDefaultPadding,
              ),
              child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: kDefaultPadding,
                    ),
                    child: Text(
                      'View Type',
                      style: CustomTextStyle.heading3(context),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      AutoRouter.of(context).pop(0);
                    },
                    child: Row(
                      children: [
                        const Icon(Ionicons.pie_chart_outline),
                        const SizedBox(
                          width: kDefaultPadding,
                        ),
                        Text(
                          'Dashboard',
                          style: CustomTextStyle.heading3(context),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    indent: kDefaultPadding,
                    endIndent: kDefaultPadding,
                  ),
                  InkWell(
                    onTap: () {
                      AutoRouter.of(context).pop(1);
                    },
                    child: Row(
                      children: [
                        const Icon(Ionicons.list_outline),
                        const SizedBox(
                          width: kDefaultPadding,
                        ),
                        Text(
                          'List View',
                          style: CustomTextStyle.heading3(context),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    indent: kDefaultPadding,
                    endIndent: kDefaultPadding,
                  ),
                  InkWell(
                    onTap: () {
                      AutoRouter.of(context).pop(2);
                    },
                    child: Row(
                      children: [
                        const Icon(Ionicons.calendar_outline),
                        const SizedBox(
                          width: kDefaultPadding,
                        ),
                        Text(
                          'Calendar View',
                          style: CustomTextStyle.heading3(context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
