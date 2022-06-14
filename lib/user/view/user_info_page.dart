import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:join_me/app/bloc/app_bloc.dart';

import 'package:join_me/app/cubit/app_message_cubit.dart';
import 'package:join_me/config/router/app_router.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/data/models/models.dart';

import 'package:join_me/data/repositories/repositories.dart';
import 'package:join_me/generated/locale_keys.g.dart';

import 'package:join_me/post/bloc/posts_bloc.dart';
import 'package:join_me/post/components/components.dart';
import 'package:join_me/project/bloc/project_overview_bloc.dart';
import 'package:join_me/project/components/components.dart';
import 'package:join_me/user/bloc/user_bloc.dart';
import 'package:join_me/user/components/new_conversation_dialog.dart';
import 'package:join_me/user/cubit/send_user_message_cubit.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:join_me/widgets/avatar_circle_widget.dart';
import 'package:join_me/widgets/dialog/add_project_invitation_dialog.dart';
import 'package:join_me/widgets/handlers/empty_handler_widget.dart';
import 'package:join_me/widgets/persistent_header_delegate.dart';
import 'package:join_me/widgets/rounded_button.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({
    @PathParam('userId') required this.userId,
    Key? key,
  }) : super(key: key);
  final String userId;

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage>
    with SingleTickerProviderStateMixin {
  bool isProjectView = false;
  late TabController _tabController;
  late UserBloc userBloc;
  late PostsBloc postsBloc;
  late ProjectOverviewBloc projectOverviewBloc;

  @override
  void initState() {
    userBloc = UserBloc(
      userRepository: context.read<UserRepository>(),
    )..add(LoadUser(widget.userId));
    postsBloc = PostsBloc(
      userRepository: context.read<UserRepository>(),
      postRepository: context.read<PostRepository>(),
      projectRepository: context.read<ProjectRepository>(),
      appMessageCubit: context.read<AppMessageCubit>(),
    )..add(FetchPosts(userId: widget.userId));
    projectOverviewBloc = ProjectOverviewBloc(
      projectRepository: context.read<ProjectRepository>(),
      taskRepository: context.read<TaskRepository>(),
      userRepository: context.read<UserRepository>(),
    )..add(LoadProjects(widget.userId));
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserBloc(
        userRepository: context.read<UserRepository>(),
      ),
      child: Scaffold(
        body: DefaultTabController(
          length: 2,
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                _MyAppBar(userBloc: userBloc),
                SliverToBoxAdapter(
                  child: _UserInfoSection(userBloc: userBloc),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: PersistentHeaderDelegate(
                    child: TabBar(
                      controller: _tabController,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorColor: Theme.of(context).primaryColor,
                      labelColor: Theme.of(context).primaryColor,
                      unselectedLabelColor: kTextColorGrey,
                      labelStyle: CustomTextStyle.heading3(context),
                      tabs: [
                        Tab(
                          text: LocaleKeys.post_post.tr().toUpperCase(),
                        ),
                        Tab(
                          text: LocaleKeys.project_project.tr().toUpperCase(),
                        )
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: Container(
              color: Theme.of(context).brightness == Brightness.light
                  ? kBackgroundPostLight
                  : null,
              padding: const EdgeInsets.only(top: kDefaultPadding),
              child: TabBarView(
                controller: _tabController,
                children: [
                  _UserPostView(
                    postsBloc: postsBloc,
                  ),
                  _UserProjectView(
                    projectOverviewBloc: projectOverviewBloc,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MyAppBar extends StatelessWidget {
  const _MyAppBar({required this.userBloc, Key? key}) : super(key: key);
  final UserBloc userBloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      bloc: userBloc,
      builder: (context, state) {
        return SliverAppBar(
          pinned: true,
          centerTitle: false,
          elevation: 0,
          leading: GestureDetector(
            onTap: () => AutoRouter.of(context).pop(),
            child: const Icon(Ionicons.chevron_back),
          ),
          leadingWidth: 40,
          title: Text(
            state.user.name,
            style: CustomTextStyle.heading3(context),
          ),
          actions: [
            if (state.user.id == context.read<AppBloc>().state.user.id)
              IconButton(
                onPressed: () => AutoRouter.of(context).push(
                  EditProfileRoute(userBloc: userBloc),
                ),
                icon: const Icon(Icons.edit_note),
              )
          ],
        );
      },
    );
  }
}

class _UserInfoSection extends StatelessWidget {
  const _UserInfoSection({required this.userBloc, Key? key}) : super(key: key);
  final UserBloc userBloc;

  void _showAddInvitationDialog(BuildContext context) {
    showDialog<Project>(
      context: context,
      builder: (context) => const AddProjectInviteDialog(
        isOnlyProjectOwned: true,
      ),
    ).then((project) {
      if (project == null) {
        return;
      }
      log(project.toJson().toString());
      if (project.members.contains(userBloc.state.user.id)) {
        context.read<AppMessageCubit>().showInfoSnackbar(
              message: 'User already in this project!',
            );
      } else {
        userBloc.add(SendInvitation(userBloc.state.user, project));
        context.read<AppMessageCubit>().showSuccessfulSnackBar(
              message: 'The invitation has been sent!',
            );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AppBloc>().state.user;
    return BlocProvider(
      create: (context) => SendUserMessageCubit(
        messageRepository: context.read<MessageRepository>(),
      ),
      child: BlocBuilder<UserBloc, UserState>(
        bloc: userBloc,
        builder: (context, state) {
          return Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            margin: const EdgeInsets.only(
              top: kDefaultPadding,
              left: kDefaultPadding,
              right: kDefaultPadding,
            ),
            child: Column(
              children: [
                CircleAvatarWidget(
                  imageUrl: state.user.photoUrl,
                  size: 100,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  state.user.name,
                  style: CustomTextStyle.heading2(context),
                ),
                const SizedBox(
                  height: 8,
                ),
                if (state.user.personalBio.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      state.user.personalBio,
                    ),
                  ),
                if (currentUser.id != state.user.id)
                  const SizedBox(
                    height: 8,
                  ),
                if (currentUser.id != state.user.id) const Divider(),
                if (currentUser.id != state.user.id)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      BlocListener<SendUserMessageCubit, SendUserMessageState>(
                        listener: (context, newConversationState) {
                          if (newConversationState.status ==
                              SendUserMessageStatus.conversationCreated) {
                            AutoRouter.of(context).push(
                              ChatRoute(
                                conversationId:
                                    newConversationState.conversation!.id,
                              ),
                            );
                          }
                          if (newConversationState.status ==
                              SendUserMessageStatus.noConversation) {
                            final sendUserMessageCubit =
                                context.read<SendUserMessageCubit>();
                            showDialog<void>(
                              context: context,
                              builder: (ctx) => NewConversationDialog(
                                receiver: state.user,
                                sendUserMessageCubit: sendUserMessageCubit,
                                onSend: (content) {
                                  sendUserMessageCubit.createUserConversation(
                                    currentUser,
                                    state.user,
                                    content,
                                  );
                                },
                              ),
                            );
                          }
                        },
                        child: RoundedButton(
                          height: 30,
                          minWidth: 120,
                          child: Row(
                            children: [
                              const Icon(
                                Ionicons.paper_plane_outline,
                                size: 20,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(LocaleKeys.button_sendMessage.tr()),
                            ],
                          ),
                          onPressed: () {
                            final currentUser =
                                context.read<AppBloc>().state.user;

                            context
                                .read<SendUserMessageCubit>()
                                .requestSendMessage(currentUser, state.user);
                          },
                        ),
                      ),
                      RoundedButton(
                        height: 30,
                        minWidth: 120,
                        color: kSecondaryBlue,
                        child: Row(
                          children: [
                            const Icon(
                              Ionicons.add_circle_outline,
                              size: 20,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(LocaleKeys.button_projectInvite.tr()),
                          ],
                        ),
                        onPressed: () => _showAddInvitationDialog(context),
                      ),
                    ],
                  ),
                const Divider(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _UserPostView extends StatelessWidget {
  const _UserPostView({required this.postsBloc, Key? key}) : super(key: key);
  final PostsBloc postsBloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostsBloc, PostsState>(
      bloc: postsBloc,
      builder: (context, state) {
        if (state.posts.isEmpty) {
          return EmptyHandlerWidget(
            size: MediaQuery.of(context).size.width * .3,
            imageHandlerDir: kNoPostPicDir,
            textHandler: 'No Posts',
          );
        }
        if (state.status == PostsStatus.initial ||
            state.status == PostsStatus.loading) {
          return const SizedBox();
        }
        return CustomScrollView(
          key: const PageStorageKey('posts-view'),
          physics: const NeverScrollableScrollPhysics(),
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return PostCard(
                    post: state.posts[index].post,
                    author: state.posts[index].author,
                    project: state.posts[index].project,
                  );
                },
                childCount: state.posts.length,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _UserProjectView extends StatelessWidget {
  const _UserProjectView({required this.projectOverviewBloc, Key? key})
      : super(key: key);
  final ProjectOverviewBloc projectOverviewBloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectOverviewBloc, ProjectOverviewState>(
      bloc: projectOverviewBloc,
      builder: (context, state) {
        if (state is ProjectsLoading || state is ProjectsInitial) {
          return const SizedBox();
        }

        if (state is ProjectsLoaded) {
          if (state.projects.isEmpty) {
            return EmptyHandlerWidget(
              size: MediaQuery.of(context).size.width * .3,
              imageHandlerDir: kNoProjectPicDir,
              textHandler: 'No Projects',
            );
          }
          return CustomScrollView(
            key: const PageStorageKey('projects-view'),
            physics: const NeverScrollableScrollPhysics(),
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return ProjectCard(
                      project: state.projects[index].project,
                      users: state.projects[index].members,
                      tasks: state.projects[index].tasks,
                    );
                  },
                  childCount: state.projects.length,
                ),
              ),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }
}
