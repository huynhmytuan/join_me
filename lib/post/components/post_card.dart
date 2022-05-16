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
  late AppUser user;
  late AppUser _currentUser;
  void _getPost() {
    post = dummy_data.postsData.firstWhere((p) => p.id == widget.postId);
    comments =
        dummy_data.commentsData.where((c) => c.postId == widget.postId).length;
    user = dummy_data.usersData.firstWhere((u) => u.id == post.authorId);
    _currentUser = dummy_data.currentUser;
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
      child: RoundedContainer(
        margin: const EdgeInsets.all(kDefaultPadding / 2),
        color: Theme.of(context).scaffoldBackgroundColor,
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
                          AutoRouter.of(context).push(
                            UserInfoRoute(userId: user.id),
                          );
                        },
                        child: Text(
                          user.name,
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
                      IconButton(
                        splashRadius: 20,
                        onPressed: () {
                          final userId = _currentUser.id;
                          final likedList = List<String>.from(post.likes);
                          if (post.likes.contains(userId)) {
                            likedList.remove(userId);
                          } else {
                            likedList.add(userId);
                          }
                          setState(() {
                            post = post.copyWith(
                              likes: likedList,
                            );
                          });
                          // TODO(tuan): post like.
                        },
                        icon: Icon(
                          (post.likes.contains(_currentUser.id))
                              ? Ionicons.heart
                              : Ionicons.heart_outline,
                          color: (post.likes.contains(_currentUser.id))
                              ? kSecondaryRed
                              : kTextColorGrey,
                        ),
                      ),
                      Text(post.likes.length.toString()),
                      const SizedBox(
                        width: 20,
                      ),
                      IconButton(
                        splashRadius: 20,
                        onPressed: () {},
                        icon: const Icon(
                          Ionicons.chatbubble_outline,
                          color: kTextColorGrey,
                        ),
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
