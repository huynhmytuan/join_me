import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:join_me/config/router/app_router.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/data/dummy_data.dart' as dummy_data;
import 'package:join_me/data/models/models.dart';
import 'package:join_me/utilities/extensions/extensions.dart';
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

  void _loadData() {
    final _tasks = dummy_data.tasksData
        .where(
          (task) =>
              task.projectId == widget.projectId && task.type == TaskType.task,
        )
        .toList();
    _items = dummy_data.projectsData
        .firstWhere((project) => project.id == widget.projectId)
        .categories
        .map(
          (sta) => Item(
            expandedValue:
                _tasks.where((task) => task.category == sta).toList(),
            headerValue: sta,
          ),
        )
        .toList();
  }

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _loadData();
    super.didChangeDependencies();
  }

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
                  _items[index].isExpanded = !isExpanded;
                });
              },
              elevation: 0,
              children: _items
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
      headerBuilder: (context, isExpanded) {
        return ListTile(
          dense: true,
          title: Text(
            '${item.headerValue} (${item.expandedValue.length})',
            style: CustomTextStyle.heading3(context),
          ),
        );
      },
      body: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        separatorBuilder: (context, index) => const Divider(),
        itemCount: item.expandedValue.length,
        itemBuilder: (context, index) => TaskListRow(
          task: item.expandedValue[index],
        ),
      ),
      isExpanded: item.isExpanded,
    );
  }
}

// stores ExpansionPanel state information
class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  List<Task> expandedValue;
  String headerValue;
  bool isExpanded;
}

class TaskListRow extends StatefulWidget {
  const TaskListRow({
    required this.task,
    Key? key,
  }) : super(key: key);
  final Task task;

  @override
  State<TaskListRow> createState() => _TaskListRowState();
}

class _TaskListRowState extends State<TaskListRow> {
  late List<User> _assignedUsers;
  bool isComplete = false;

  void _loadData() {
    _assignedUsers = dummy_data.usersData
        .where(
          (user) => widget.task.assignTo.contains(user.id),
        )
        .toList();
    isComplete = widget.task.isComplete;
  }

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        AutoRouter.of(context).push(SingleTaskRoute(taskId: widget.task.id));
      },
      child: Row(
        children: [
          Checkbox(
            value: isComplete,
            onChanged: (value) {
              //
              setState(() {
                isComplete = !isComplete;
              });
            },
          ),
          Expanded(
            child: Text(
              widget.task.name,
              style: CustomTextStyle.heading4(context),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          StackImage(
            imageUrlList: _assignedUsers.map((user) => user.photoUrl).toList(),
            imageSize: 30,
          ),
        ],
      ),
    );
  }
}
