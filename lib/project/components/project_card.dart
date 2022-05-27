import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:join_me/config/router/app_router.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/data/models/models.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:join_me/widgets/widgets.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard({
    required this.project,
    required this.users,
    required this.tasks,
    Key? key,
  }) : super(key: key);
  final Project project;
  final List<AppUser> users;
  final List<Task?> tasks;

  @override
  Widget build(BuildContext context) {
    final appLocale = Localizations.localeOf(context);
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
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                project.name,
                style: CustomTextStyle.heading3(context),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(
              height: 5,
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
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StackedImages(
                  imageUrlList: users.map((user) => user.photoUrl).toList(),
                  totalCount: project.members.length,
                  imageSize: 24,
                ),
                Row(
                  children: [
                    const Icon(
                      Ionicons.document_text_outline,
                      color: kTextColorGrey,
                      size: 16,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      tasks.length.toString(),
                      style: CustomTextStyle.subText(context)
                          .copyWith(fontSize: 12),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(
                      Ionicons.time_outline,
                      color: kTextColorGrey,
                      size: 16,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      DateFormat.yMMMMd(appLocale.languageCode)
                          .format(project.createdAt),
                      style: CustomTextStyle.subText(context)
                          .copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
