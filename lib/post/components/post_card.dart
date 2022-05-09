import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:join_me/config/router/router.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/data/dummy_data.dart' as dummy_data;
import 'package:join_me/data/models/models.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:join_me/widgets/widgets.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostCard extends StatefulWidget {
  const PostCard({
    required this.postId,
    Key? key,
  }) : super(key: key);
  final String postId;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late Post post;
  int comments = 0;
  late User user;
  void _getPost() {
    post = dummy_data.postsData.firstWhere((p) => p.id == widget.postId);
    comments =
        dummy_data.commentsData.where((c) => c.postId == widget.postId).length;
    user = dummy_data.usersData.firstWhere((u) => u.id == post.authorId);
  }

  @override
  void initState() {
    _getPost();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Get appLocale to get language code
    final appLocale = Localizations.localeOf(context);
    return GestureDetector(
      onTap: () {
        AutoRouter.of(context).push(PostDetailRoute(postId: widget.postId));
      },
      child: Container(
        margin: const EdgeInsets.all(kDefaultPadding / 2),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(kDefaultRadius),
          boxShadow: [kDefaultBoxShadow],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  Material(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () {
                        // TODO(tuan): Go to user's page
                      },
                      child: CircleAvatarWidget(imageUrl: user.photoUrl),
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
                          // TODO(tuan): Go to user's page
                        },
                        child: Text(
                          user.displayName,
                          style: CustomTextStyle.heading4(context),
                        ),
                      ),
                      Text(
                        timeago.format(
                          post.createdAt,
                          locale: appLocale.languageCode,
                        ),
                        style: CustomTextStyle.subText(context)
                            .copyWith(color: kTextColorGrey),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    splashRadius: 10,
                    onPressed: () {},
                    icon: const Icon(
                      Ionicons.chevron_down,
                      size: 20,
                    ),
                  )
                ],
              ),
            ),
            //Post Content
            Padding(
              padding: const EdgeInsets.all(10),
              child: ExpandedText(
                text: post.content,
              ),
            ),
            //Post Pictures
            if (post.imageUrls.isNotEmpty)
              PresetsSlider(
                imageList: post.imageUrls,
              ),
            const Divider(
              indent: 10,
              endIndent: 10,
            ),
            //Post Reaction
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: kIconColorGrey.withOpacity(.8),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                          splashRadius: 20,
                          onPressed: () {},
                          icon: const Icon(
                            Ionicons.heart_outline,
                            color: kTextColorGrey,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(post.likes.length.toString()),
                      const SizedBox(
                        width: 20,
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: kIconColorGrey.withOpacity(.8),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                          splashRadius: 20,
                          onPressed: () {},
                          icon: const Icon(
                            Ionicons.chatbubble_outline,
                            color: kTextColorGrey,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(comments.toString()),
                    ],
                  ),
                  if (post.type == PostType.invitation)
                    RoundedButton(
                      minWidth: 80,
                      height: 32,
                      child: Text(
                        'Join',
                        style: CustomTextStyle.heading4(context)
                            .copyWith(color: Colors.white),
                      ),
                      onPressed: () {},
                    )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
