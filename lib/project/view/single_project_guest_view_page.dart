import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:join_me/app/bloc/app_bloc.dart';
import 'package:join_me/app/cubit/app_message_cubit.dart';
import 'package:join_me/config/router/app_router.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/data/repositories/repositories.dart';

import 'package:join_me/project/bloc/project_bloc.dart';
import 'package:join_me/utilities/constant.dart';

import 'package:join_me/widgets/widgets.dart';

class SingleProjectGuestViewPage extends StatefulWidget {
  const SingleProjectGuestViewPage({
    @pathParam required this.projectId,
    Key? key,
  }) : super(key: key);
  final String projectId;

  @override
  State<SingleProjectGuestViewPage> createState() =>
      _SingleProjectGuestViewPageState();
}

class _SingleProjectGuestViewPageState
    extends State<SingleProjectGuestViewPage> {
  ProjectBloc? projectBloc;

  @override
  void didChangeDependencies() {
    projectBloc = projectBloc ??
        ProjectBloc(
          projectRepository: context.read<ProjectRepository>(),
          userRepository: context.read<UserRepository>(),
          appMessageCubit: context.read<AppMessageCubit>(),
        )
      ..add(LoadProject(widget.projectId));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectBloc, ProjectState>(
      bloc: projectBloc,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          body: CustomScrollView(
            slivers: [
              _AppBar(projectBloc: projectBloc!),
              _JoinProjectButton(projectBloc: projectBloc!),
              _ProjectInformationList(projectBloc: projectBloc!)
            ],
          ),
        );
      },
    );
  }
}

class _ProjectInformationList extends StatelessWidget {
  const _ProjectInformationList({
    required this.projectBloc,
    Key? key,
  }) : super(key: key);
  final ProjectBloc projectBloc;
  @override
  Widget build(BuildContext context) {
    final appLocale = Localizations.localeOf(context);
    return BlocBuilder<ProjectBloc, ProjectState>(
      bloc: projectBloc,
      builder: (context, state) {
        return SliverFillRemaining(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About this project',
                    style: CustomTextStyle.heading2(context),
                  ),
                  const SizedBox(
                    height: kDefaultPadding / 2,
                  ),
                  Text(
                    state.project.description.isEmpty
                        ? 'No description for this project'
                        : state.project.description,
                  ),
                  const SizedBox(
                    height: kDefaultPadding,
                  ),
                  Text(
                    'This project start from',
                    style: CustomTextStyle.heading4(context),
                  ),
                  const SizedBox(
                    height: kDefaultPadding / 2,
                  ),
                  Text(
                    DateFormat.yMMMd(appLocale.languageCode)
                        .format(state.project.createdAt),
                  ),
                  const SizedBox(
                    height: kDefaultPadding,
                  ),
                  Text(
                    'Created by',
                    style: CustomTextStyle.heading4(context),
                  ),
                  const SizedBox(
                    height: kDefaultPadding / 2,
                  ),
                  ListTile(
                    onTap: () => AutoRouter.of(context)
                        .push(UserInfoRoute(userId: state.owner.id)),
                    contentPadding: EdgeInsets.zero,
                    visualDensity: VisualDensity.comfortable,
                    leading: CircleAvatarWidget(
                      imageUrl: state.owner.photoUrl,
                      size: 40,
                    ),
                    title: Text(
                      state.owner.name,
                      style: CustomTextStyle.heading4(context),
                    ),
                  ),
                  const SizedBox(
                    height: kDefaultPadding,
                  ),
                  Text(
                    'Already ${state.project.members.length} member(s) joined',
                    style: CustomTextStyle.heading4(context),
                  ),
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount:
                        (state.members.length >= 5) ? 5 : state.members.length,
                    itemBuilder: (context, index) => ListTile(
                      onTap: () => AutoRouter.of(context).push(
                        UserInfoRoute(userId: state.members[index].id),
                      ),
                      contentPadding: EdgeInsets.zero,
                      visualDensity: VisualDensity.comfortable,
                      leading: CircleAvatarWidget(
                        imageUrl: state.members[index].photoUrl,
                        size: 40,
                      ),
                      title: Text(state.members[index].name),
                    ),
                  ),
                  if (state.members.length >= 5)
                    Text(
                      'And more..',
                      style: CustomTextStyle.heading4(context),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _JoinProjectButton extends StatelessWidget {
  const _JoinProjectButton({
    required this.projectBloc,
    Key? key,
  }) : super(key: key);
  final ProjectBloc projectBloc;

  @override
  Widget build(BuildContext context) {
    final _currentUser = context.read<AppBloc>().state.user;
    return BlocBuilder<ProjectBloc, ProjectState>(
      bloc: projectBloc,
      builder: (context, state) {
        final isMember =
            state.members.any((user) => user.id == _currentUser.id);
        final isRequested = state.project.requests.contains(_currentUser.id);
        var title = '';
        if (isMember) {
          title = 'Already Member';
        } else if (isRequested) {
          title = 'Requested';
        } else {
          title = 'Join Now';
        }
        return SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: 20,
            ),
            child: Center(
              child: RoundedButton(
                height: 30,
                onPressed: (isMember || isRequested)
                    ? null
                    : () {
                        projectBloc.add(
                          AddJoinRequest(
                            project: state.project,
                            userId: _currentUser.id,
                          ),
                        );
                      },
                color: Colors.white.withOpacity(.4),
                elevation: 0,
                child: Text(
                  title,
                  style: CustomTextStyle.heading3(context).copyWith(
                    color:
                        (isMember || isRequested) ? Colors.grey : Colors.white,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar({
    required this.projectBloc,
    Key? key,
  }) : super(key: key);
  final ProjectBloc projectBloc;
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Theme.of(context).primaryColor,
      leading: RoundedIconButton(
        onTap: () => AutoRouter.of(context).pop(),
        icon: const Icon(
          Ionicons.chevron_back,
          size: 24,
          color: Colors.white,
        ),
      ),
      expandedHeight: 130,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: BlocBuilder<ProjectBloc, ProjectState>(
          bloc: projectBloc,
          buildWhen: (previous, current) =>
              previous.project.name != current.project.name,
          builder: (context, state) {
            return Text(
              state.project.name,
              style: const TextStyle(color: Colors.white),
              textScaleFactor: 1,
            );
          },
        ),
      ),
    );
  }
}
