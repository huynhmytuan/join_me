import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';

import 'package:join_me/config/router/router.dart';
import 'package:join_me/config/theme.dart';

import 'package:join_me/data/models/models.dart';

import 'package:join_me/post/cubit/like_cubit.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:join_me/widgets/avatar_circle_widget.dart';
import 'package:join_me/widgets/expanded_text.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentWidget extends StatefulWidget {
  const CommentWidget({
    required this.comment,
    required this.author,
    required this.currentUser,
    required this.onLongPressed,
    Key? key,
  }) : super(key: key);
  final Comment comment;
  final AppUser author;
  final AppUser currentUser;
  final Function() onLongPressed;
  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding / 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              AutoRouter.of(context)
                  .push(UserInfoRoute(userId: widget.author.id));
            },
            child: CircleAvatarWidget(imageUrl: widget.author.photoUrl),
          ),
          const SizedBox(
            width: 5,
          ),
          GestureDetector(
            onLongPress: widget.onLongPressed,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.70,
              ),
              padding: const EdgeInsets.symmetric(
                vertical: kDefaultPadding / 2,
                horizontal: kDefaultPadding,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? kCardLightColor
                    : Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(kDefaultRadius),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //User display name
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          AutoRouter.of(context).push(
                            UserInfoRoute(userId: widget.author.id),
                          );
                        },
                        child: Text(
                          widget.author.name,
                          style: CustomTextStyle.heading4(context).copyWith(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: kDefaultPadding,
                      ),
                      Text(
                        timeago.format(
                          widget.comment.createdAt,
                          locale: Localizations.localeOf(context).languageCode,
                        ),
                        style: CustomTextStyle.subText(context),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: kDefaultPadding / 2,
                  ),
                  Wrap(
                    children: [
                      ExpandedText(
                        text: widget.comment.content,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(kDefaultPadding),
            onTap: () {
              context.read<LikeCubit>().likeUnlikePost(
                    userId: widget.currentUser.id,
                    comment: widget.comment,
                    likeType: LikeType.comment,
                  );
            },
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    (widget.comment.likes.contains(widget.currentUser.id))
                        ? Ionicons.heart
                        : Ionicons.heart_outline,
                    color:
                        (widget.comment.likes.contains(widget.currentUser.id))
                            ? kSecondaryRed
                            : kTextColorGrey,
                    size: 20,
                  ),
                  Text(
                    widget.comment.likes.length.toString(),
                    overflow: TextOverflow.clip,
                    style: CustomTextStyle.heading4(context).copyWith(
                      color:
                          (widget.comment.likes.contains(widget.currentUser.id))
                              ? kSecondaryRed
                              : kTextColorGrey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
