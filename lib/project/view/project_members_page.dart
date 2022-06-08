import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:join_me/app/bloc/app_bloc.dart';
import 'package:join_me/config/router/app_router.dart';

import 'package:join_me/data/models/models.dart';
import 'package:join_me/project/bloc/project_bloc.dart';
import 'package:join_me/utilities/constant.dart';

import 'package:join_me/widgets/widgets.dart';

class ProjectMembersPage extends StatelessWidget {
  const ProjectMembersPage({Key? key, required this.projectBloc})
      : super(key: key);

  final ProjectBloc projectBloc;

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
              title: const Text('Members'),
              actions: (state.owner.id == currentUser.id)
                  ? [
                      IconButton(
                        onPressed: () {
                          showDialog<List<AppUser>>(
                            context: context,
                            builder: (context) => AddUserDialog(
                              //Remove owner from member list
                              initialUserList: state.members
                                ..remove(state.owner),
                              //Remove owner from search
                              withoutUsers: [state.owner],
                            ),
                          ).then((selectedUser) {
                            if (selectedUser == null) {
                              return;
                            }
                            //Map id and Re-add ownerId from new list User.
                            final userIds = selectedUser
                                .map((user) => user.id)
                                .toList()
                              ..add(state.owner.id);
                            //Edit project with new member list
                            projectBloc.add(
                              EditProject(
                                state.project.copyWith(members: userIds),
                              ),
                            );
                          });
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
                    title: const Text('Join Request'),
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
                  onTap: () => AutoRouter.of(context).push(
                    UserInfoRoute(userId: state.members[index - 1].id),
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
