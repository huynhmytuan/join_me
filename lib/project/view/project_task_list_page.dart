import 'package:flutter/material.dart';

import 'package:join_me/config/theme.dart';
import 'package:join_me/data/dummy_data.dart' as dummy_data;
import 'package:join_me/data/models/models.dart';
import 'package:join_me/project/components/components.dart';
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
      canTapOnHeader: true,
      headerBuilder: (context, isExpanded) {
        return Align(
          alignment: Alignment.centerLeft,
          child: Text(
            item.headerValue,
            style: CustomTextStyle.heading4(context),
          ),
        );
      },
      body: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        separatorBuilder: (context, index) => const Divider(),
        itemCount: item.expandedValue.length,
        itemBuilder: (context, index) {
          final _assignedUsers = dummy_data.usersData
              .where(
                (user) => item.expandedValue[index].assignee.contains(user.id),
              )
              .toList();
          return TaskListRow(
            task: item.expandedValue[index],
            trailing: StackImage(
              imageUrlList:
                  _assignedUsers.map((user) => user.photoUrl).toList(),
              imageSize: 24,
              totalCount: _assignedUsers.length,
            ),
          );
        },
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
    this.isExpanded = true,
  });

  List<Task> expandedValue;
  String headerValue;
  bool isExpanded;
}
