import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/data/dummy_data.dart' as dummy_data;
import 'package:join_me/data/models/models.dart';

import 'package:join_me/utilities/constant.dart';
import 'package:join_me/widgets/widgets.dart';

class ProjectDashboardPage extends StatefulWidget {
  const ProjectDashboardPage({
    required this.projectId,
    Key? key,
  }) : super(key: key);
  final String projectId;

  @override
  State<ProjectDashboardPage> createState() => _ProjectDashboardPageState();
}

class _ProjectDashboardPageState extends State<ProjectDashboardPage> {
  late Project _project;
  late User _leader;
  late List<User> _members;
  late List<Task> _tasks;
  void _loadData() {
    _project = dummy_data.projectsData
        .firstWhere((proj) => proj.id == widget.projectId);
    _leader =
        dummy_data.usersData.firstWhere((user) => user.id == _project.leader);
    _members = dummy_data.usersData
        .where((user) => _project.members.contains(user.id))
        .toList();
    _tasks = dummy_data.tasksData
        .where(
          (task) => task.projectId == _project.id && task.type == TaskType.task,
        )
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
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDataRow(
                context: context,
                iconData: Ionicons.person_outline,
                rowTitle: 'Leader',
                rowData: Container(
                  padding: const EdgeInsets.all(kDefaultPadding / 4),
                  decoration: BoxDecoration(
                    color: kIconColorGrey,
                    borderRadius: BorderRadius.circular(kDefaultRadius),
                  ),
                  child: Row(
                    children: [
                      CircleAvatarWidget(
                        imageUrl: _leader.photoUrl,
                        size: 24,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        _leader.displayName,
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
                rowTitle: 'Created At',
                rowData: Text(
                  DateFormat.yMMMMEEEEd(appLocale.languageCode)
                      .format(_project.createdAt),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              _buildDataRow(
                context: context,
                iconData: Ionicons.time_outline,
                rowTitle: 'Last Updated',
                rowData: Text(
                  DateFormat.yMMMMEEEEd(appLocale.languageCode)
                      .format(_project.lastChangeAt),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              _buildDataRow(
                context: context,
                iconData: Ionicons.people_outline,
                rowTitle: 'Members',
                rowData: StackImage(
                  imageUrlList: _members.map((user) => user.photoUrl).toList(),
                  totalCount: _project.members.length,
                  imageSize: 24,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {},
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal:
                        _project.description.isEmpty ? kDefaultPadding : 0,
                    vertical: kDefaultPadding / 2,
                  ),
                  child: (_project.description.isEmpty)
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Ionicons.add),
                            Text('Add description'),
                          ],
                        )
                      : Text(
                          _project.description,
                          style: CustomTextStyle.bodyMedium(context),
                        ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Wrap(
                alignment: WrapAlignment.spaceAround,
                children: [
                  _buildDataBadge(
                    context: context,
                    badgeTitle: 'Pending Task',
                    iconColor: kSecondaryYellow,
                    iconData: Ionicons.document_text,
                    valueCount:
                        _tasks.where((task) => task.isComplete).toList().length,
                  ),
                  _buildDataBadge(
                    context: context,
                    badgeTitle: 'Complete',
                    iconColor: kSecondaryGreen,
                    iconData: Ionicons.checkbox_outline,
                    valueCount: _tasks
                        .where((task) => !task.isComplete)
                        .toList()
                        .length,
                  ),
                  _buildDataBadge(
                    context: context,
                    badgeTitle: 'All',
                    iconColor: kSecondaryBlue,
                    iconData: Ionicons.bag_handle_outline,
                    valueCount: _tasks.length,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container _buildDataBadge({
    required BuildContext context,
    required String badgeTitle,
    required IconData iconData,
    required Color iconColor,
    required int valueCount,
  }) {
    return Container(
      constraints: const BoxConstraints(
        minWidth: 165,
        minHeight: 80,
      ),
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(kDefaultPadding / 2),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(kDefaultRadius),
        boxShadow: [kDefaultBoxShadow],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                badgeTitle,
                style: CustomTextStyle.heading4(context)
                    .copyWith(color: kTextColorGrey),
              ),
              Text(
                valueCount.toString(),
                style: CustomTextStyle.heading4(context),
              ),
            ],
          ),
          const SizedBox(
            width: kDefaultPadding,
          ),
          CircleAvatar(
            backgroundColor: iconColor,
            child: Icon(
              iconData,
              color: Colors.white,
            ),
          )
        ],
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
}
