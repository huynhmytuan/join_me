import 'package:flutter/material.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/data/dummy_data.dart' as dummy_data;
import 'package:join_me/data/models/models.dart';
import 'package:join_me/project/components/components.dart';
import 'package:join_me/utilities/constant.dart';

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
    _items = [
      Item(
        expandedValue:
            _tasks.where((task) => task.status == TaskStatus.toTo).toList(),
        headerValue: 'To-Do',
      ),
      Item(
        expandedValue: _tasks
            .where((task) => task.status == TaskStatus.inProcess)
            .toList(),
        headerValue: 'In-Process',
      ),
      Item(
        expandedValue:
            _tasks.where((task) => task.status == TaskStatus.complete).toList(),
        headerValue: 'Complete',
      ),
    ];
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
        itemBuilder: (context, index) => Builder(
          builder: (context) {
            final _assignedUsers = dummy_data.usersData
                .where(
                  (user) =>
                      item.expandedValue[index].assignTo.contains(user.id),
                )
                .toList();
            final task = item.expandedValue[index];
            var status = false;
            if (task.status == TaskStatus.complete) {
              status = true;
            }
            return InkWell(
              onTap: () {},
              child: Row(
                children: [
                  Checkbox(
                    value: status,
                    onChanged: (value) {
                      //
                      setState(() {
                        status = !status;
                      });
                    },
                  ),
                  Expanded(
                    child: Text(
                      task.name,
                      style: CustomTextStyle.heading4(context),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  StackImage(
                    imageUrlList:
                        _assignedUsers.map((user) => user.photoUrl).toList(),
                    imageSize: 30,
                  ),
                ],
              ),
            );
          },
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
