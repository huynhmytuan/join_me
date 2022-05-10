import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/data/dummy_data.dart' as dummy_data;
import 'package:join_me/data/models/models.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:join_me/utilities/extensions/extensions.dart';
import 'package:join_me/widgets/widgets.dart';

class SingleTaskPage extends StatefulWidget {
  const SingleTaskPage({
    @pathParam required this.taskId,
    Key? key,
  }) : super(key: key);
  final String taskId;

  @override
  State<SingleTaskPage> createState() => _SingleTaskPageState();
}

class _SingleTaskPageState extends State<SingleTaskPage> {
  late Task _task;
  late Project _project;
  late User _createdBy;
  late List<User> _assignedTo;

  void _loadData() {
    _task = dummy_data.tasksData.firstWhere((task) => task.id == widget.taskId);
    _project = dummy_data.projectsData
        .firstWhere((project) => project.id == _task.projectId);
    _createdBy =
        dummy_data.usersData.firstWhere((user) => user.id == _task.createdBy);
    _assignedTo = dummy_data.usersData
        .where((user) => user.id == _task.createdBy)
        .toList();
  }

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appLocale = Localizations.localeOf(context);
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Padding(
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
                rowData: Container(
                  padding: const EdgeInsets.all(kDefaultPadding / 4),
                  decoration: BoxDecoration(
                    color: kIconColorGrey,
                    borderRadius: BorderRadius.circular(kDefaultRadius),
                  ),
                  child: Row(
                    children: [
                      CircleAvatarWidget(
                        imageUrl: _createdBy.photoUrl,
                        size: 24,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        _createdBy.displayName,
                        style: CustomTextStyle.bodySmall(context),
                      ),
                    ],
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
                      .format(_task.createdAt),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              _buildDataRow(
                context: context,
                iconData: Ionicons.time_outline,
                rowTitle: 'Due date',
                rowData: Text(
                  DateFormat.yMMMMEEEEd(appLocale.languageCode)
                      .format(_task.dueDate),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              _buildDataRow(
                context: context,
                iconData: Ionicons.people_outline,
                rowTitle: 'Assigned to',
                rowData: StackImage(
                  imageUrlList:
                      _assignedTo.map((user) => user.photoUrl).toList(),
                  totalCount: _assignedTo.length,
                  imageSize: 24,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: _showPriorityPickerSheet,
                child: _buildDataRow(
                  context: context,
                  iconData: Ionicons.warning_outline,
                  rowTitle: 'Priority',
                  rowData: Container(
                    decoration: BoxDecoration(
                      color: _task.priority.getColor(),
                      borderRadius: BorderRadius.circular(kDefaultRadius),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 2,
                      horizontal: 10,
                    ),
                    child: Text(
                      _task.priority.toTitle(),
                      style: CustomTextStyle.bodyMedium(context)
                          .copyWith(color: Colors.white),
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
                onTap: () {},
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: _task.description.isEmpty ? kDefaultPadding : 0,
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
              )
            ],
          ),
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
          value: true,
          onChanged: (value) {},
        ),
        IconButton(
          onPressed: () {},
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

  void _showPriorityPickerSheet() {
    showModalBottomSheet<dynamic>(
      context: context,
      shape: kTopBorderRadiusShape,
      useRootNavigator: true,
      barrierColor: Colors.black.withOpacity(0.5),
      isScrollControlled: true,
      builder: (context) {
        final priorityList = TaskPriority.values
            .takeWhile((a) => a != TaskPriority.unknown)
            .toList();
        return CupertinoPickerBottomSheet(
          onSubmit: (index) {
            /// TODO(tuan): save to sever
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
}
