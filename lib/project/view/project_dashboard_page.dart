import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:join_me/app/bloc/app_bloc.dart';
import 'package:join_me/config/router/app_router.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/generated/locale_keys.g.dart';

import 'package:join_me/project/bloc/project_bloc.dart';
import 'package:join_me/task/bloc/tasks_overview_bloc.dart';

import 'package:join_me/utilities/constant.dart';
import 'package:join_me/widgets/widgets.dart';

class ProjectDashboardPage extends StatelessWidget {
  const ProjectDashboardPage({
    required this.projectId,
    Key? key,
  }) : super(key: key);
  final String projectId;

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
            clipBehavior: Clip.none,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(kDefaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDataRow(
                        context: context,
                        iconData: Ionicons.person_outline,
                        rowTitle: LocaleKeys.properties_ownerBy.tr(),
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
                      const SizedBox(
                        height: kDefaultPadding,
                      ),
                      _buildDataRow(
                        context: context,
                        iconData: Ionicons.time_outline,
                        rowTitle: LocaleKeys.properties_createdAt.tr(),
                        rowData: Text(
                          DateFormat.yMMMMEEEEd(appLocale.languageCode)
                              .format(state.project.createdAt),
                        ),
                      ),
                      const SizedBox(
                        height: kDefaultPadding,
                      ),
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
                          rowTitle: LocaleKeys.general_members.tr(),
                          rowData: StackedImages(
                            imageUrlList: state.members
                                .map((user) => user.photoUrl)
                                .toList(),
                            totalCount: state.project.members.length,
                            imageSize: 24,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: kDefaultPadding,
                      ),
                      Text(
                        LocaleKeys.properties_description.tr(),
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
                                    hintText:
                                        LocaleKeys.button_addDescription.tr(),
                                  ),
                                )
                                    .then((textEdited) {
                                  if (textEdited == null ||
                                      textEdited is! String) {
                                    return;
                                  }
                                  if (textEdited != state.project.description) {
                                    context.read<ProjectBloc>().add(
                                          EditProject(
                                            state.project.copyWith(
                                              description: textEdited,
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
                          child: Builder(
                            builder: (context) {
                              if (state.project.description.isNotEmpty) {
                                return Text(
                                  state.project.description,
                                  style: CustomTextStyle.bodyMedium(context),
                                );
                              }
                              if (currentUser.id != state.owner.id) {
                                return const SizedBox();
                              }
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Ionicons.add),
                                  Text(
                                    LocaleKeys.button_addDescription.tr(),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const _ListInfoCards()
              ],
            ),
          );
        }
        return Text(
          LocaleKeys.errorMessage_wrong.tr(),
        );
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

class _ListInfoCards extends StatelessWidget {
  const _ListInfoCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksOverviewBloc, TasksOverviewState>(
      builder: (context, state) {
        if (state is TasksOverviewLoading) {
          return const CircularProgressIndicator();
        }
        if (state is TasksOverviewLoadSuccess) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DataBadge(
                  badgeTitle: LocaleKeys.project_pendingTask.tr(),
                  iconColor: kSecondaryYellow,
                  iconData: Ionicons.document_text,
                  valueCount: state.tasks
                      .where((task) => !task.task.isComplete)
                      .toList()
                      .length,
                ),
                _DataBadge(
                  badgeTitle: LocaleKeys.project_completed.tr(),
                  iconColor: kSecondaryGreen,
                  iconData: Ionicons.checkbox_outline,
                  valueCount: state.tasks
                      .where((task) => task.task.isComplete)
                      .toList()
                      .length,
                ),
                _DataBadge(
                  badgeTitle: LocaleKeys.project_all.tr(),
                  iconColor: kSecondaryBlue,
                  iconData: Ionicons.bag_handle_outline,
                  valueCount: state.tasks.length,
                ),
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}

class _DataBadge extends StatelessWidget {
  const _DataBadge({
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
    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            backgroundColor: iconColor.withOpacity(.3),
            radius: 24,
            child: Icon(
              iconData,
              color: iconColor,
            ),
          ),
          const SizedBox(
            width: kDefaultPadding,
          ),
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
                style: CustomTextStyle.heading2(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
