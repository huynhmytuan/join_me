import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:join_me/config/router/app_router.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/data/models/models.dart';
import 'package:join_me/generated/locale_keys.g.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:join_me/utilities/extensions/extensions.dart';
import 'package:join_me/widgets/widgets.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    required this.task,
    required this.assignedTo,
    Key? key,
  }) : super(key: key);
  final Task task;
  final List<AppUser> assignedTo;

  @override
  Widget build(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;
    return GestureDetector(
      onTap: () {
        AutoRouter.of(context).push(SingleTaskRoute(taskId: task.id));
      },
      child: Container(
        height: 100,
        padding: const EdgeInsets.fromLTRB(
          0,
          kDefaultPadding,
          kDefaultPadding,
          kDefaultPadding,
        ),
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: Theme.of(context).brightness == Brightness.light
              ? kDefaultBoxShadow
              : null,
          borderRadius: BorderRadius.circular(kDefaultRadius),
        ),
        child: Row(
          children: [
            Container(
              height: 57,
              width: 10,
              decoration: BoxDecoration(
                color: task.priority.getColor(),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(kDefaultRadius),
                  bottomRight: Radius.circular(kDefaultRadius),
                ),
              ),
            ),
            const SizedBox(
              width: kDefaultPadding,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.name,
                    style: CustomTextStyle.heading3(context),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Ionicons.time_outline,
                            size: 17,
                            color: kTextColorGrey,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            task.dueDate == null
                                ? LocaleKeys.task_noDueDate.tr()
                                : DateFormat.yMMMMEEEEd(languageCode)
                                    .format(task.dueDate!),
                            style: CustomTextStyle.bodyMedium(context).copyWith(
                              color: kTextColorGrey,
                            ),
                          ),
                        ],
                      ),
                      if (task.subTasks.isNotEmpty)
                        Row(
                          children: [
                            const Icon(
                              Ionicons.git_merge_outline,
                              size: 17,
                              color: kTextColorGrey,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              task.subTasks.length.toString(),
                              style:
                                  CustomTextStyle.bodyMedium(context).copyWith(
                                color: kTextColorGrey,
                              ),
                            ),
                          ],
                        ),
                      StackedImages(
                        imageUrlList:
                            assignedTo.map((e) => e.photoUrl).toList(),
                        imageSize: 24,
                        totalCount: assignedTo.length,
                        emptyHandler: Text(
                          LocaleKeys.task_unAssigned.tr(),
                          style: CustomTextStyle.bodyMedium(context).copyWith(
                            color: kTextColorGrey,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
