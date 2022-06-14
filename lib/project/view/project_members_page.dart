import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:join_me/app/bloc/app_bloc.dart';
import 'package:join_me/config/router/app_router.dart';

import 'package:join_me/data/models/models.dart';
import 'package:join_me/generated/locale_keys.g.dart';
import 'package:join_me/project/bloc/project_bloc.dart';
import 'package:join_me/user/cubit/search_user_cubit.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:join_me/widgets/bottom_sheet/selection_bottom_sheet.dart';

import 'package:join_me/widgets/widgets.dart';

class ProjectMembersPage extends StatelessWidget {
  const ProjectMembersPage({Key? key, required this.projectBloc})
      : super(key: key);

  final ProjectBloc projectBloc;
  void _onUserTap(BuildContext context, AppUser user, AppUser currentUser) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => SelectionBottomSheet(
        title: user.name,
        listSelections: [
          SelectionRow(
            onTap: () {
              AutoRouter.of(context).pop();
              AutoRouter.of(context).push(UserInfoRoute(userId: user.id));
            },
            title: LocaleKeys.button_viewUserPage.tr(),
            iconData: Icons.person_outline,
          ),
          if (currentUser.id == projectBloc.state.owner.id &&
              currentUser.id != user.id)
            SelectionRow(
              onTap: () {
                AutoRouter.of(context).pop();
                showDialog<bool>(
                  context: context,
                  builder: (context) => CustomAlertDialog(
                    title: LocaleKeys.dialog_removeMember_title.tr(),
                    content: LocaleKeys.dialog_removeMember_content.tr(),
                    submitButtonColor: Colors.red,
                    submitLabel: LocaleKeys.button_remove.tr(),
                    onCancel: () => AutoRouter.of(context).pop(false),
                    onSubmit: () => AutoRouter.of(context).pop(true),
                  ),
                ).then((value) {
                  if (value != null && value) {
                    projectBloc.add(RemoveUserFromProject(userId: user.id));
                  }
                });
              },
              color: Colors.red,
              title: LocaleKeys.button_delete.tr(),
              iconData: Icons.remove,
            )
          else if (currentUser.id == user.id &&
              projectBloc.state.project.owner != user.id)
            SelectionRow(
              onTap: () {
                showDialog<bool>(
                  context: context,
                  builder: (context) => CustomAlertDialog(
                    title: LocaleKeys.dialog_leave_title.tr(),
                    content: LocaleKeys.dialog_leave_content.tr(),
                    submitButtonColor: Colors.red,
                    submitLabel: LocaleKeys.button_leave.tr(),
                    onCancel: () => AutoRouter.of(context).pop(false),
                    onSubmit: () => AutoRouter.of(context).pop(true),
                  ),
                ).then((value) {
                  if (value != null && value) {
                    projectBloc
                        .add(RemoveUserFromProject(userId: currentUser.id));
                    //Pop and send value to tell
                    //that member was leave.
                    AutoRouter.of(context).pop(true);
                  }
                });
              },
              color: Colors.red,
              title: [
                LocaleKeys.button_leave.tr(),
                LocaleKeys.project_project.tr(),
              ].join(' '),
              iconData: Ionicons.log_out_outline,
            ),
        ],
      ),
    );
  }

  void _showAddMember(BuildContext context, List<AppUser>? withoutUser) {
    showDialog<AppUser>(
      context: context,
      builder: (context) => AddUserDialog(
        //Remove owner from search
        withoutUsers: withoutUser,
      ),
    ).then((selectedUser) {
      context.read<SearchUserCubit>().clearResults();
      if (selectedUser == null) {
        return;
      }
      projectBloc.add(
        AddUserToProject(userId: selectedUser.id),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AppBloc>().state.user;
    return BlocBuilder<ProjectBloc, ProjectState>(
      bloc: projectBloc,
      builder: (context, state) {
        if (state.status == ProjectStatus.loading ||
            state.status == ProjectStatus.initial) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state.status == ProjectStatus.success) {
          return Scaffold(
            appBar: AppBar(
              leading: GestureDetector(
                onTap: () => AutoRouter.of(context).pop(),
                child: const Icon(Ionicons.chevron_back),
              ),
              title: Text(
                LocaleKeys.general_members.tr(),
              ),
              actions: (state.owner.id == currentUser.id)
                  ? [
                      IconButton(
                        onPressed: () {
                          _showAddMember(
                            context,
                            state.members,
                          );
                        },
                        icon: const Icon(Ionicons.person_add_outline),
                      )
                    ]
                  : null,
            ),
            body: ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                kDefaultPadding,
                0,
                kDefaultPadding,
                kDefaultPadding,
              ),
              separatorBuilder: (context, index) => const Divider(),
              itemCount: state.members.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return ListTile(
                    onTap: () {
                      AutoRouter.of(context)
                          .push(RequestsRoute(projectId: state.project.id));
                    },
                    title: Text(LocaleKeys.project_joinRequest.tr()),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (projectBloc.state.project.requests.isNotEmpty)
                          CountBadge(
                            count: projectBloc.state.project.requests.length,
                          ),
                        const Icon(Ionicons.chevron_forward)
                      ],
                    ),
                  );
                }
                return ListTile(
                  onTap: () => _onUserTap(
                    context,
                    state.members[index - 1],
                    currentUser,
                  ),
                  leading: CircleAvatarWidget(
                    imageUrl: state.members[index - 1].photoUrl,
                    size: 40,
                  ),
                  title: Text(
                    state.members[index - 1].name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  subtitle: Text(state.members[index - 1].email),
                  trailing: state.members[index - 1].id == state.owner.id
                      ? const Icon(Ionicons.key_outline)
                      : null,
                );
              },
            ),
          );
        }
        return const Center(
          child: Text('Some thing went wrong.'),
        );
      },
    );
  }
}
