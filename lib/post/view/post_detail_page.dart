import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/data/dummy_data.dart' as dummy_data;
import 'package:join_me/data/models/models.dart';
import 'package:join_me/post/components/components.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:join_me/widgets/widgets.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostDetailPage extends StatefulWidget {
  const PostDetailPage({
    @PathParam('postId') required this.postId,
    Key? key,
  }) : super(key: key);
  final String postId;

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  late Post post;
  late AppUser author;
  late List<Comment> comments;
  late FocusNode commentFocusNode;
  final commentTextInputController = TextEditingController();
  void _getPost() {
    post = dummy_data.postsData.firstWhere((p) => p.id == widget.postId);
    author = dummy_data.usersData.firstWhere((u) => u.id == post.authorId);
    comments = dummy_data.commentsData
        .where((c) => c.postId == widget.postId)
        .toList();
  }

  @override
  void didChangeDependencies() {
    _getPost();

    super.didChangeDependencies();
  }

  @override
  void initState() {
    _getPost();
    commentFocusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Get appLocale to get language code
    final appLocale = Localizations.localeOf(context);
    return KeyboardDismisser(
      // ignore: avoid_redundant_argument_values
      gestures: const [GestureType.onTap],
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: _buildAppBar(context, appLocale),
        body: Column(
          children: [
            Expanded(
              child: _buildPostView(context),
            ),
            BottomTextField(
              textEditingController: commentTextInputController,
              focusNode: commentFocusNode,
              hintText: 'Write a comment...',
              onSubmit: () {
                // TODO(tuanhuynh): post comment.
              },
            )
          ],
        ),
      ),
    );
  }

  SingleChildScrollView _buildPostView(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: ExpandedText(text: post.content),
          ),
          const Divider(
            indent: kDefaultPadding,
            endIndent: kDefaultPadding,
          ),
          if (post.medias.isNotEmpty)
            PresetsSlider(
              imageList: post.medias,
            ),
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
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: IconButton(
                        splashRadius: 20,
                        onPressed: () {
                          commentFocusNode.requestFocus();
                        },
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
                    Text(comments.length.toString()),
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
          ),
          const Divider(
            indent: kDefaultPadding,
            endIndent: kDefaultPadding,
          ),
          _buildCommentSection(),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, Locale appLocale) {
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
          CircleAvatarWidget(imageUrl: dummy_data.currentUser.photoUrl),
          const SizedBox(
            width: kDefaultPadding / 2,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //User display name
              Text(
                author.name,
                style: CustomTextStyle.heading3(context),
              ),
              //PostTime
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
        ],
      ),
      actions: [
        IconButton(
          splashRadius: 20,
          onPressed: () {},
          icon: const Icon(
            Ionicons.ellipsis_horizontal,
          ),
        )
      ],
    );
  }

  Widget _buildCommentSection() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return CommentWidget(
          comment: comments[index],
        );
      },
      itemCount: comments.length,
    );
  }

  @override
  void dispose() {
    commentFocusNode.dispose();
    super.dispose();
  }
}
