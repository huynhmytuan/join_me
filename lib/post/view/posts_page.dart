import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/data/dummy_data.dart' as dummy_data;
import 'package:join_me/data/models/post.dart';
import 'package:join_me/post/components/components.dart';
import 'package:join_me/utilities/constant.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({Key? key}) : super(key: key);

  @override
  State<PostsPage> createState() => _PostsWallState();
}

class _PostsWallState extends State<PostsPage> {
  late List<Post> posts;
  void _getPosts() {
    posts = dummy_data.postsData;
  }

  @override
  void initState() {
    _getPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).brightness == Brightness.light
            ? Colors.black
            : Colors.white,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Home Page',
          style: CustomTextStyle.heading2(context),
        ),
        leading: SvgPicture.asset(kLogoLightDir),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const NewPostCard(),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return PostCard(
                  postId: posts[index].id.toString(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
