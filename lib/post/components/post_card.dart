import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:join_me/app/bloc/app_bloc.dart';
import 'package:join_me/config/router/router.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/data/models/models.dart';
import 'package:join_me/generated/locale_keys.g.dart';
import 'package:join_me/post/bloc/posts_bloc.dart';

import 'package:join_me/post/cubit/like_cubit.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:join_me/widgets/bottom_sheet/selection_bottom_sheet.dart';
import 'package:join_me/widgets/widgets.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostCard extends StatelessWidget {
  const PostCard({
    required this.post,
    required this.author,
    this.project,
    Key? key,
  }) : super(key: key);
  final Post post;
  final AppUser author;
  final Project? project;

  static int comments = 0;

  @override
  Widget build(BuildContext context) {
    //Get appLocale to get language code
    final appLocale = Localizations.localeOf(context);
    final _currentUser = context.read<AppBloc>().state.user;
    return GestureDetector(
      onTap: () {
        AutoRouter.of(context).push(PostDetailRoute(postId: post.id));
      },
      child: RoundedContainer(
        margin: const EdgeInsets.symmetric(
          horizontal: kDefaultPadding / 2,
          vertical: 5,
        ),
        color: Theme.of(context).cardColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
              child: _PostHeader(
                author: author,
                post: post,
                appLocale: appLocale,
              ),
            ),
            //Post Content
            if (post.content.isNotEmpty) _PostContent(post: post),
            //Post Pictures
            if (post.medias.isNotEmpty) _PostMedias(post: post),
            if (post.type == PostType.invitation)
              _ProjectInviteSection(
                key: UniqueKey(),
                project: project,
              ),
            //Post Reaction
            _PostReaction(
              post: post,
              currentUser: _currentUser,
              comments: comments,
            )
          ],
        ),
      ),
    );
  }
}

class _ProjectInviteSection extends StatelessWidget {
  const _ProjectInviteSection({
    Key? key,
    required this.project,
  }) : super(key: key);

  final Project? project;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AutoRouter.of(context).push(SingleProjectRoute(projectId: project!.id));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        width: double.infinity,
        color: project == null
            ? kIconColorGrey.withOpacity(.2)
            : Theme.of(context).primaryColor,
        child: Row(
          children: [
            Expanded(
              child: Text(
                project == null
                    ? LocaleKeys.post_inviteNotExist.tr()
                    : LocaleKeys.post_invitationTo.tr(args: [project!.name]),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: CustomTextStyle.heading4(context).copyWith(
                  color: project == null ? Colors.grey : Colors.white,
                ),
              ),
            ),
            if (project != null) const SizedBox(width: 30),
            if (project != null)
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
    );
  }
}

class _PostReaction extends StatelessWidget {
  const _PostReaction({
    Key? key,
    required this.post,
    required AppUser currentUser,
    required this.comments,
  })  : _currentUser = currentUser,
        super(key: key);

  final Post post;
  final AppUser _currentUser;
  final int comments;

  @override
  Widget build(BuildContext context) {
    final appLocale = Localizations.localeOf(context);

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            [
              LocaleKeys.post_likeCount.plural(
                post.likes.length,
                format: NumberFormat.compact(locale: appLocale.languageCode),
              ),
              LocaleKeys.post_commentCount.plural(
                post.commentCount,
                format: NumberFormat.compact(locale: appLocale.languageCode),
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
                          post: post,
                          userId: _currentUser.id,
                          likeType: LikeType.post,
                        );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        (post.likes.contains(_currentUser.id))
                            ? Ionicons.heart
                            : Ionicons.heart_outline,
                        color: (post.likes.contains(_currentUser.id))
                            ? kSecondaryRed
                            : kTextColorGrey,
                      ),
                      const SizedBox(
                        width: 3,
                      ),
                      Text(
                        LocaleKeys.post_like.tr(),
                        style: CustomTextStyle.heading4(context).copyWith(
                          color: (post.likes.contains(_currentUser.id))
                              ? kSecondaryRed
                              : kTextColorGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
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
            ],
          ),
        ],
      ),
    );
  }
}

class _PostMedias extends StatelessWidget {
  const _PostMedias({
    Key? key,
    required this.post,
  }) : super(key: key);

  final Post post;

  @override
  Widget build(BuildContext context) {
    return PresetsSlider(
      imageList: post.medias,
    );
  }
}

class _PostContent extends StatelessWidget {
  const _PostContent({
    Key? key,
    required this.post,
  }) : super(key: key);

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ExpandedText(
        text: post.content,
        key: UniqueKey(),
      ),
    );
  }
}

class _PostHeader extends StatelessWidget {
  const _PostHeader({
    Key? key,
    required this.author,
    required this.post,
    required this.appLocale,
  }) : super(key: key);

  final AppUser author;
  final Post post;
  final Locale appLocale;
  void _showMoreDialog(BuildContext _context, PostsBloc postsBloc) {
    showModalBottomSheet<void>(
      useRootNavigator: true,
      barrierColor: Colors.black.withOpacity(0.5),
      isScrollControlled: true,
      context: _context,
      shape: const RoundedRectangleBorder(
        // <-- for border radius
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(kDefaultRadius),
          topRight: Radius.circular(kDefaultRadius),
        ),
      ),
      builder: (_context) {
        final _currentUser = _context.read<AppBloc>().state.user;
        final isOwner = _currentUser.id == author.id;
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
                                postId: post.id,
                              ),
                            );
                          }
                        }),
                      );
                },
                color: Theme.of(_context).errorColor,
                title: [
                  LocaleKeys.button_delete.tr(),
                  LocaleKeys.post_post.tr(),
                ].join(' '),
                iconData: Ionicons.trash_bin_outline,
              )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          Material(
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: () {
                AutoRouter.of(context).push(
                  UserInfoRoute(userId: author.id),
                );
              },
              child: CircleAvatarWidget(
                imageUrl: author.photoUrl,
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  AutoRouter.of(context).push(
                    UserInfoRoute(userId: author.id),
                  );
                },
                child: Text(
                  author.name,
                  style: CustomTextStyle.heading4(context),
                ),
              ),
              Text(
                timeago.format(
                  post.createdAt,
                  locale: context.locale.languageCode,
                ),
                style: CustomTextStyle.subText(context)
                    .copyWith(color: kTextColorGrey),
              ),
            ],
          ),
          const Spacer(),
          if (author.id == context.read<AppBloc>().state.user.id)
            BlocBuilder<PostsBloc, PostsState>(
              buildWhen: (previous, current) => false,
              builder: (context, state) {
                return IconButton(
                  splashRadius: 10,
                  onPressed: () =>
                      _showMoreDialog(context, context.read<PostsBloc>()),
                  icon: const Icon(
                    Ionicons.chevron_down,
                    size: 20,
                  ),
                );
              },
            )
        ],
      ),
    );
  }
}
