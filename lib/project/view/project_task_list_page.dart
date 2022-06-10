import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:join_me/app/bloc/app_bloc.dart';

import 'package:join_me/config/theme.dart';
import 'package:join_me/project/bloc/project_bloc.dart';
import 'package:join_me/project/components/components.dart';
import 'package:join_me/task/bloc/tasks_overview_bloc.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:join_me/widgets/widgets.dart';

class ProjectTaskListPage extends StatefulWidget {
  const ProjectTaskListPage({
    required this.projectId,
    Key? key,
  }) : super(key: key);
  final String projectId;

  @override
  State<ProjectTaskListPage> createState() => _ProjectTaskListPageState();
}

class _ProjectTaskListPageState extends State<ProjectTaskListPage> {
  late List<Item> _items;

  void _setListItems({required List<TaskViewModel> task}) {
    _items = context
        .read<ProjectBloc>()
        .state
        .project
        .categories
        .map(
          (sta) => Item(
            expandedValue:
                task.where((task) => task.task.category == sta).toList(),
            headerValue: sta,
          ),
        )
        .toList();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksOverviewBloc, TasksOverviewState>(
      builder: (context, state) {
        if (state is TasksOverviewLoadSuccess) {
          _setListItems(task: state.tasks);
          return TaskListView(items: _items);
        }
        return const Center(
          child: Text('Something went wrong'),
        );
      },
    );
  }
}

// stores ExpansionPanel state information
class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = true,
  });

  List<TaskViewModel> expandedValue;
  String headerValue;
  bool isExpanded;
}

class TaskListView extends StatefulWidget {
  const TaskListView({required this.items, Key? key}) : super(key: key);
  final List<Item> items;

  @override
  State<TaskListView> createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          kDefaultPadding,
          kDefaultPadding,
          kDefaultPadding,
          0,
        ),
        child: Column(
          children: [
            ExpansionPanelList(
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  widget.items[index].isExpanded = !isExpanded;
                });
              },
              elevation: 0,
              children: widget.items
                  .map(
                    (Item item) => _buildExpandSection(
                      context: context,
                      item: item,
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  ExpansionPanel _buildExpandSection({
    required BuildContext context,
    required Item item,
  }) {
    return ExpansionPanel(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      canTapOnHeader: true,
      headerBuilder: (context, isExpanded) {
        return Align(
          alignment: Alignment.centerLeft,
          child: Text(
            item.headerValue,
            style: CustomTextStyle.heading3(context),
          ),
        );
      },
      body: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        separatorBuilder: (context, index) => const Divider(),
        itemCount: item.expandedValue.length,
        itemBuilder: (context, index) {
          final _assignedUsers = item.expandedValue[index].assignee;
          return TaskListRow(
            task: item.expandedValue[index].task,
            trailing: StackedImages(
              imageUrlList:
                  _assignedUsers.map((user) => user.photoUrl).toList(),
              imageSize: 24,
              totalCount: _assignedUsers.length,
              emptyHandler: const SizedBox(),
            ),
            onChange: (value) => context.read<TasksOverviewBloc>().add(
                  ToggleTaskStatus(
                    item.expandedValue[index].task.copyWith(
                      isComplete: value,
                    ),
                    context.read<AppBloc>().state.user.id,
                  ),
                ),
          );
        },
      ),
      isExpanded: item.isExpanded,
    );
  }
}
