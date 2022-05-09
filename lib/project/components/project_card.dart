import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:join_me/config/router/app_router.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/data/dummy_data.dart' as dummy_data;
import 'package:join_me/data/models/models.dart';
import 'package:join_me/project/project.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:timeago/timeago.dart' as timeago;

class ProjectCard extends StatelessWidget {
  const ProjectCard({
    required this.project,
    Key? key,
  }) : super(key: key);
  final Project project;

  @override
  Widget build(BuildContext context) {
    final users = project.members.map((userId) {
      return dummy_data.usersData.firstWhere((user) => user.id == userId);
    }).toList();
    final tasks = dummy_data.tasksData
        .where(
          (element) => project.id == element.projectId,
        )
        .toList();
    return GestureDetector(
      onTap: () {
        AutoRouter.of(context).push(SingleProjectRoute(projectId: project.id));
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(kDefaultPadding),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [kDefaultBoxShadow],
          borderRadius: BorderRadius.circular(kDefaultRadius),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    project.name,
                    style: CustomTextStyle.heading3(context),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  timeago.format(project.lastChangeAt),
                  style: CustomTextStyle.subText(context),
                ),
                const SizedBox(
                  width: 3,
                ),
                GestureDetector(
                  onTap: () {
                    // TODO(tuan): more action button.
                  },
                  child:
                      const Icon(Ionicons.ellipsis_horizontal_circle_outline),
                )
              ],
            ),
            const SizedBox(
              height: kDefaultPadding,
            ),
            SizedBox(
              height: 54,
              width: double.infinity,
              child: Text(
                project.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: CustomTextStyle.bodyMedium(context)
                    .copyWith(color: kTextColorGrey),
              ),
            ),
            const SizedBox(
              height: kDefaultPadding,
            ),
            Row(
              children: [
                Expanded(
                  child: StackImage(
                    imageUrlList: users.map((user) => user.photoUrl).toList(),
                    totalCount: project.members.length,
                  ),
                ),
                const Icon(
                  Ionicons.document_text_outline,
                  color: kTextColorGrey,
                ),
                Text(
                  tasks.length.toString(),
                  style: CustomTextStyle.heading4(context)
                      .copyWith(color: kTextColorGrey),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
