import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/data/dummy_data.dart';
import 'package:join_me/data/models/models.dart';
import 'package:join_me/post/components/components.dart';
import 'package:join_me/project/components/components.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:join_me/widgets/avatar_circle_widget.dart';
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
  late AppUser _user;
  bool isProjectView = false;
  late TabController _tabController;
  @override
  void initState() {
    _user = usersData.firstWhere((element) => element.id == widget.userId);
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                pinned: true,
                centerTitle: false,
                elevation: 0,
                leading: GestureDetector(
                  onTap: () => AutoRouter.of(context).pop(),
                  child: const Icon(Ionicons.chevron_back),
                ),
                leadingWidth: 40,
                title: Text(
                  _user.name,
                  style: CustomTextStyle.heading3(context),
                ),
              ),
              SliverToBoxAdapter(
                child: _buildInfoSection(context),
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
                        text: 'Post'.toUpperCase(),
                      ),
                      Tab(
                        text: 'Projects'.toUpperCase(),
                      )
                    ],
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildPostView(),
              _buildProjectView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context) {
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
            imageUrl: _user.photoUrl,
            size: 100,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            _user.name,
            style: CustomTextStyle.heading3(context),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(_user.personalBio),
          const SizedBox(
            height: 8,
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RoundedButton(
                height: 30,
                minWidth: 120,
                child: Row(
                  children: const [
                    Icon(
                      Ionicons.paper_plane_outline,
                      size: 20,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text('Send Message'),
                  ],
                ),
                onPressed: () {},
              ),
              RoundedButton(
                height: 30,
                minWidth: 120,
                color: kSecondaryBlue,
                child: Row(
                  children: const [
                    Icon(
                      Ionicons.add_circle_outline,
                      size: 20,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text('Invite To Project'),
                  ],
                ),
                onPressed: () {},
              ),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildPostView() {
    final posts = postsData.where((p) => p.authorId == _user.id).toList();
    return CustomScrollView(
      key: const PageStorageKey('posts-view'),
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return PostCard(postId: posts[index].id!);
            },
            childCount: posts.length,
          ),
        ),
      ],
    );
  }

  Widget _buildProjectView() {
    final projects =
        projectsData.where((p) => p.members.contains(_user.id)).toList();
    return CustomScrollView(
      key: const PageStorageKey('projects-view'),
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return ProjectCard(project: projects[index]);
            },
            childCount: projects.length,
          ),
        ),
      ],
    );
  }
}
