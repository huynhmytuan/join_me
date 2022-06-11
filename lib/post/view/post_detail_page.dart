import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:join_me/app/bloc/app_bloc.dart';
import 'package:join_me/config/router/router.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/data/models/models.dart';
import 'package:join_me/data/repositories/comment_repository.dart';
import 'package:join_me/data/repositories/repositories.dart';
import 'package:join_me/generated/locale_keys.g.dart';
import 'package:join_me/post/bloc/comment_bloc.dart';
import 'package:join_me/post/bloc/post_bloc.dart';
import 'package:join_me/post/bloc/posts_bloc.dart';
import 'package:join_me/post/components/components.dart';
import 'package:join_me/post/cubit/like_cubit.dart';
import 'package:join_me/post/view_model/post_view_model.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:join_me/widgets/bottom_sheet/selection_bottom_sheet.dart';
import 'package:join_me/widgets/widgets.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostDetailPage extends StatelessWidget {
  const PostDetailPage({
    @PathParam('postId') required this.postId,
    Key? key,
  }) : super(key: key);
  final String postId;

  @override
  Widget build(BuildContext context) {
    //Get appLocale to get language code
    return BlocProvider(
      create: (context) => PostBloc(
        userRepository: context.read<UserRepository>(),
        postRepository: context.read<PostRepository>(),
        projectRepository: context.read<ProjectRepository>(),
      )..add(LoadPost(postId: postId)),
      child: const _PostView(),
    );
  }
}

class _PostView extends StatefulWidget {
  const _PostView({Key? key}) : super(key: key);

  @override
  State<_PostView> createState() => _PostViewState();
}

class _PostViewState extends State<_PostView> {
  late FocusNode commentFocusNode;
  late TextEditingController commentTextInputController;
  void _showMoreDialog(
    BuildContext context,
    PostsBloc postsBloc,
    PostViewModel postViewModel,
  ) {
    showModalBottomSheet<void>(
      useRootNavigator: true,
      barrierColor: Colors.black.withOpacity(0.5),
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        // <-- for border radius
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(kDefaultRadius),
          topRight: Radius.circular(kDefaultRadius),
        ),
      ),
      builder: (_context) {
        final _currentUser = _context.read<AppBloc>().state.user;
        final isOwner = _currentUser.id == postViewModel.post.authorId;
        return SelectionBottomSheet(
          title: LocaleKeys.general_more.tr(),
          listSelections: [
            if (isOwner)
              SelectionRow(
                onTap: () {
                  AutoRouter.of(_context).pop().then(
                        (value) => showDialog<bool>(
                          context: _context,
                          builder: (context) => CustomAlertDialog(
                            title: LocaleKeys.dialog_delete_title.tr(),
                            content: LocaleKeys.dialog_delete_content.tr(),
                            submitButtonColor: Theme.of(context).errorColor,
                            submitLabel: LocaleKeys.button_delete.tr(),
                            onCancel: () => AutoRouter.of(context).pop(false),
                            onSubmit: () => AutoRouter.of(context).pop(true),
                          ),
                        ).then((choice) {
                          if (choice != null && choice) {
                            postsBloc.add(
                              DeletePost(
                                postId: postViewModel.post.id,
                              ),
                            );
                            AutoRouter.of(context).pop();
                          }
                        }),
                      );
                },
                color: Theme.of(_context).errorColor,
                title: [
                  LocaleKeys.button_delete.tr(),
                  LocaleKeys.post_post.tr()
                ].join(' '),
                iconData: Ionicons.trash_bin_outline,
              )
          ],
        );
      },
    );
  }

  @override
  void initState() {
    commentFocusNode = FocusNode();
    commentTextInputController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appLocale = Localizations.localeOf(context);
    final currentUser = context.read<AppBloc>().state.user;
    return BlocConsumer<PostBloc, PostState>(
      listener: (context, state) {
        if (state.status == PostStatus.notFound &&
            state.postViewModel.author.id != currentUser.id) {
          AutoRouter.of(context).popAndPush(const NotFoundRoute());
        }
      },
      builder: (context, state) {
        if (state.status == PostStatus.notFound) {
          const SizedBox();
        }
        if (state.status == PostStatus.loading ||
            state.status == PostStatus.initial) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (state.status == PostStatus.failure) {
          return Scaffold(
            body: Center(
              child: Text(LocaleKeys.errorMessage_wrong.tr()),
            ),
          );
        }
        return KeyboardDismisser(
          // ignore: avoid_redundant_argument_values
          gestures: const [GestureType.onTap],
          child: Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: _buildAppBar(context, appLocale, state.postViewModel),
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _PostContent(
                          commentFocusNode: commentFocusNode,
                        ),
                        _CommentView(
                          postId: state.postViewModel.post.id,
                        ),
                      ],
                    ),
                  ),
                ),
                _CommentInput(
                  commentFocusNode: commentFocusNode,
                  commentTextInputController: commentTextInputController,
                  postId: state.postViewModel.post.id,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  AppBar _buildAppBar(
    BuildContext context,
    Locale appLocale,
    PostViewModel postVM,
  ) {
    final currentUser = context.read<AppBloc>().state.user;
    return AppBar(
      elevation: 0,
      leading: IconButton(
        splashRadius: 20,
        onPressed: () {
          AutoRouter.of(context).pop();
        },
        icon: const Icon(Ionicons.chevron_back),
      ),
      title: Row(
        children: [
          CircleAvatarWidget(imageUrl: postVM.author.photoUrl),
          const SizedBox(
            width: kDefaultPadding / 2,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //User display name
              Text(
                postVM.author.name,
                style: CustomTextStyle.heading3(context),
              ),
              //PostTime
              Text(
                timeago.format(
                  postVM.post.createdAt,
                  locale: appLocale.languageCode,
                ),
                style: CustomTextStyle.subText(context)
                    .copyWith(color: kTextColorGrey),
              ),
            ],
          ),
        ],
      ),
      actions: [
        if (currentUser.id == postVM.author.id)
          IconButton(
            splashRadius: 20,
            onPressed: () => _showMoreDialog(
              context,
              context.read<PostsBloc>(),
              postVM,
            ),
            icon: const Icon(
              Ionicons.ellipsis_horizontal,
            ),
          )
      ],
    );
  }

  @override
  void dispose() {
    commentFocusNode.dispose();
    commentTextInputController.dispose();
    super.dispose();
  }
}

class _PostContent extends StatelessWidget {
  const _PostContent({required this.commentFocusNode, Key? key})
      : super(key: key);

  final FocusNode commentFocusNode;

  @override
  Widget build(BuildContext context) {
    final _currentUser = context.read<AppBloc>().state.user;
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        final appLocale = Localizations.localeOf(context);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (state.postViewModel.post.content.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(20),
                child: ExpandedText(text: state.postViewModel.post.content),
              ),
            const Divider(
              indent: kDefaultPadding,
              endIndent: kDefaultPadding,
            ),
            if (state.postViewModel.post.medias.isNotEmpty)
              PresetsSlider(
                imageList: state.postViewModel.post.medias,
              ),
            if (state.postViewModel.post.projectInvitationId.isNotEmpty)
              GestureDetector(
                onTap: state.postViewModel.project != null
                    ? () {
                        AutoRouter.of(context).push(
                          SingleProjectRoute(
                            projectId: state.postViewModel.project!.id,
                          ),
                        );
                      }
                    : null,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 10,
                  ),
                  width: double.infinity,
                  color: state.postViewModel.project == null
                      ? kIconColorGrey.withOpacity(.2)
                      : Theme.of(context).primaryColor,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          state.postViewModel.project == null
                              ? LocaleKeys.post_inviteNotExist.tr()
                              : LocaleKeys.post_invitationTo.tr(
                                  args: [state.postViewModel.project!.name],
                                ),
                          textAlign: state.postViewModel.project == null
                              ? TextAlign.center
                              : null,
                          style: CustomTextStyle.heading4(context).copyWith(
                            color: state.postViewModel.project != null
                                ? Colors.white
                                : Colors.grey,
                          ),
                        ),
                      ),
                      if (state.postViewModel.project != null)
                        Row(
                          children: [
                            Text(
                              LocaleKeys.button_showMore.tr(),
                              style: CustomTextStyle.heading4(context)
                                  .copyWith(color: Colors.white),
                            ),
                            const SizedBox(width: 3),
                            const Icon(
                              Ionicons.chevron_forward,
                              color: Colors.white,
                              size: 14,
                            )
                          ],
                        )
                    ],
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    [
                      LocaleKeys.post_likeCount.plural(
                        state.postViewModel.post.likes.length,
                        format: NumberFormat.compact(
                          locale: appLocale.languageCode,
                        ),
                      ),
                      LocaleKeys.post_commentCount.plural(
                        state.postViewModel.post.commentCount,
                        format: NumberFormat.compact(
                          locale: appLocale.languageCode,
                        ),
                      ),
                    ].join(' '),
                    style: CustomTextStyle.bodySmall(context)
                        .copyWith(color: kTextColorGrey),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            context.read<LikeCubit>().likeUnlikePost(
                                  post: state.postViewModel.post,
                                  userId: _currentUser.id,
                                  likeType: LikeType.post,
                                );
                          },
                          child: SizedBox(
                            width: 200,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  (state.postViewModel.post.likes
                                          .contains(_currentUser.id))
                                      ? Ionicons.heart
                                      : Ionicons.heart_outline,
                                  color: (state.postViewModel.post.likes
                                          .contains(_currentUser.id))
                                      ? kSecondaryRed
                                      : kTextColorGrey,
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  LocaleKeys.post_like.tr(),
                                  style: CustomTextStyle.heading4(context)
                                      .copyWith(
                                    color: (state.postViewModel.post.likes
                                            .contains(_currentUser.id))
                                        ? kSecondaryRed
                                        : kTextColorGrey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: commentFocusNode.requestFocus,
                          child: SizedBox(
                            width: 200,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Ionicons.chatbubble_ellipses_outline,
                                  color: kTextColorGrey,
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  LocaleKeys.post_comment.tr(),
                                  style: CustomTextStyle.heading4(context)
                                      .copyWith(color: kTextColorGrey),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(
              indent: kDefaultPadding,
              endIndent: kDefaultPadding,
            ),
          ],
        );
      },
    );
  }
}

class _CommentView extends StatefulWidget {
  const _CommentView({
    required this.postId,
    Key? key,
  }) : super(key: key);

  final String postId;

  @override
  State<_CommentView> createState() => _CommentViewState();
}

class _CommentViewState extends State<_CommentView> {
  late CommentBloc _commentBloc;
  late AppUser _currentUser;
  void _showMoreDialog(Comment comment) {
    showModalBottomSheet<ProjectViewType>(
      useRootNavigator: true,
      barrierColor: Colors.black.withOpacity(0.5),
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        // <-- for border radius
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(kDefaultRadius),
          topRight: Radius.circular(kDefaultRadius),
        ),
      ),
      builder: (context) {
        final isOwner = _currentUser.id == comment.authorId;
        return SelectionBottomSheet(
          title: LocaleKeys.general_more.tr(),
          listSelections: [
            SelectionRow(
              onTap: () {
                Clipboard.setData(ClipboardData(text: comment.content));
                AutoRouter.of(context).pop();
              },
              title: [
                LocaleKeys.button_copy.tr(),
                LocaleKeys.post_comment.tr(),
              ].join(' '),
              iconData: Ionicons.copy_outline,
            ),
            if (isOwner)
              SelectionRow(
                onTap: () {
                  AutoRouter.of(context).pop().then(
                        (value) => showDialog<bool>(
                          context: context,
                          builder: (context) => CustomAlertDialog(
                            title: LocaleKeys.dialog_delete_title.tr(),
                            content: LocaleKeys.dialog_delete_content.tr(),
                            submitButtonColor: Theme.of(context).errorColor,
                            submitLabel: LocaleKeys.button_delete.tr(),
                            onCancel: () => AutoRouter.of(context).pop(false),
                            onSubmit: () => AutoRouter.of(context).pop(true),
                          ),
                        ).then((choice) {
                          if (choice != null && choice) {
                            _commentBloc.add(DeleteComment(comment));
                          }
                        }),
                      );
                },
                color: Theme.of(context).errorColor,
                title: [
                  LocaleKeys.button_delete.tr(),
                  LocaleKeys.post_comment.tr(),
                ].join(' '),
                iconData: Ionicons.trash_bin_outline,
              )
          ],
        );
      },
    );
  }

  @override
  void initState() {
    _commentBloc = CommentBloc(
      commentRepository: context.read<CommentRepository>(),
      userRepository: context.read<UserRepository>(),
    )..add(LoadComments(widget.postId));
    _currentUser = context.read<AppBloc>().state.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentBloc, CommentState>(
      bloc: _commentBloc,
      builder: (context, state) {
        if (state.status == CommentStatus.initial) {
          return const Center(child: CircularProgressIndicator());
        }
        // in case of failure
        if (state.status == CommentStatus.failure) {
          return Center(child: Text(LocaleKeys.errorMessage_wrong.tr()));
        }
        // if the list is loading and the list is empty (first page)
        if (state.status == CommentStatus.loading && state.comments.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        // if the status is success but the list is empty (no items i)
        if (state.status == CommentStatus.success && state.comments.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: Icon(
                Ionicons.chatbubble_ellipses_outline,
                size: 60,
                color: kIconColorGrey,
              ),
            ),
          );
        }
        return ListView.builder(
          reverse: true,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return CommentWidget(
              key: UniqueKey(),
              comment: state.comments[index].comment,
              author: state.comments[index].author,
              currentUser: _currentUser,
              onLongPressed: () =>
                  _showMoreDialog(state.comments[index].comment),
            );
          },
          itemCount: state.comments.length,
        );
      },
    );
  }
}

class _CommentInput extends StatefulWidget {
  const _CommentInput({
    Key? key,
    required this.commentTextInputController,
    required this.commentFocusNode,
    required this.postId,
  }) : super(key: key);

  final TextEditingController commentTextInputController;
  final FocusNode commentFocusNode;
  final String postId;

  @override
  State<_CommentInput> createState() => _CommentInputState();
}

class _CommentInputState extends State<_CommentInput> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        return BottomTextField(
          textEditingController: widget.commentTextInputController,
          focusNode: widget.commentFocusNode,
          hintText: LocaleKeys.textField_writeAComment.tr(),
          onSubmit: () {
            // print(widget.commentTextInputController.text);
            final currentUser = context.read<AppBloc>().state.user;
            final commentContent = widget.commentTextInputController.text;
            context.read<CommentBloc>().add(
                  AddComment(
                    Comment(
                      id: '',
                      createdAt: DateTime.now(),
                      content: commentContent,
                      authorId: currentUser.id,
                      postId: widget.postId,
                      likes: const [],
                    ),
                    state.postViewModel.post,
                  ),
                );
            widget.commentTextInputController.clear();
          },
        );
      },
    );
  }
}
