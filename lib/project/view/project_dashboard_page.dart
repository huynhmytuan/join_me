import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:join_me/app/blocs/app_bloc.dart';
import 'package:join_me/config/router/app_router.dart';
import 'package:join_me/config/theme.dart';

import 'package:join_me/project/bloc/project_bloc/project_bloc.dart';
import 'package:join_me/task/bloc/tasks_overview_bloc.dart';

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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appLocale = Localizations.localeOf(context);
    final currentUser = context.read<AppBloc>().state.user;
    return BlocBuilder<ProjectBloc, ProjectState>(
      builder: (context, state) {
        if (state.status == ProjectStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state.status == ProjectStatus.success) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDataRow(
                    context: context,
                    iconData: Ionicons.person_outline,
                    rowTitle: 'Owned By',
                    rowData: Row(
                      children: [
                        CircleAvatarWidget(
                          imageUrl: state.owner.photoUrl,
                          size: 24,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          state.owner.email,
                          style: CustomTextStyle.bodySmall(context),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  _buildDataRow(
                    context: context,
                    iconData: Ionicons.time_outline,
                    rowTitle: 'Created At',
                    rowData: Text(
                      DateFormat.yMMMMEEEEd(appLocale.languageCode)
                          .format(state.project.createdAt),
                    ),
                  ),
                  const Divider(),
                  GestureDetector(
                    onTap: () {
                      AutoRouter.of(context).push(
                        ProjectMembersRoute(
                          projectBloc: context.read<ProjectBloc>(),
                        ),
                      );
                    },
                    child: _buildDataRow(
                      context: context,
                      iconData: Ionicons.people_outline,
                      rowTitle: 'Members',
                      rowData: StackedImages(
                        imageUrlList:
                            state.members.map((user) => user.photoUrl).toList(),
                        totalCount: state.project.members.length,
                        imageSize: 24,
                      ),
                    ),
                  ),
                  const Divider(),
                  Text(
                    'Description',
                    style: CustomTextStyle.heading4(context)
                        .copyWith(color: kTextColorGrey),
                  ),
                  InkWell(
                    onTap: currentUser.id == state.owner.id
                        ? () {
                            AutoRouter.of(context)
                                .push(
                              TextEditingRoute(
                                initialText: state.project.description,
                                hintText: 'Edit description',
                              ),
                            )
                                .then((textEdited) {
                              if (textEdited != null &&
                                  textEdited != state.project.description) {
                                context.read<ProjectBloc>().add(
                                      EditProject(
                                        state.project.copyWith(
                                          description: textEdited as String,
                                        ),
                                      ),
                                    );
                              }
                            });
                          }
                        : null,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: state.project.description.isEmpty
                            ? kDefaultPadding
                            : 0,
                        vertical: kDefaultPadding / 2,
                      ),
                      child: (state.project.description.isEmpty)
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Ionicons.add),
                                Text('Add description'),
                              ],
                            )
                          : Text(
                              state.project.description,
                              style: CustomTextStyle.bodyMedium(context),
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  BlocBuilder<TasksOverviewBloc, TasksOverviewState>(
                    builder: (context, state) {
                      if (state is TasksOverviewLoading) {
                        return const CircularProgressIndicator();
                      }
                      if (state is TasksOverviewLoadSuccess) {
                        return Wrap(
                          alignment: WrapAlignment.spaceAround,
                          children: [
                            DataBadge(
                              badgeTitle: 'Pending Task',
                              iconColor: kSecondaryYellow,
                              iconData: Ionicons.document_text,
                              valueCount: state.tasks
                                  .where((task) => task.task.isComplete)
                                  .toList()
                                  .length,
                            ),
                            DataBadge(
                              badgeTitle: 'Complete',
                              iconColor: kSecondaryGreen,
                              iconData: Ionicons.checkbox_outline,
                              valueCount: state.tasks
                                  .where((task) => !task.task.isComplete)
                                  .toList()
                                  .length,
                            ),
                            DataBadge(
                              badgeTitle: 'All',
                              iconColor: kSecondaryBlue,
                              iconData: Ionicons.bag_handle_outline,
                              valueCount: state.tasks.length,
                            ),
                          ],
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ],
              ),
            ),
          );
        }
        return const Text('Something went wrong');
      },
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

class DataBadge extends StatelessWidget {
  const DataBadge({
    required this.badgeTitle,
    required this.iconData,
    required this.iconColor,
    required this.valueCount,
    Key? key,
  }) : super(key: key);
  final String badgeTitle;
  final IconData iconData;
  final Color iconColor;
  final int valueCount;
  @override
  Widget build(BuildContext context) {
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
}
