import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:join_me/post/bloc/posts_bloc.dart';
import 'package:join_me/post/components/components.dart';

import 'package:join_me/utilities/constant.dart';
import 'package:join_me/widgets/handlers/empty_handler_widget.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({Key? key}) : super(key: key);

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  final _scrollController = ScrollController();

  final _scrollThreshold = 0.95;
  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? kBackgroundPostLight
          : null,
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              Theme.of(context).brightness == Brightness.light
                  ? kLogoLightDir
                  : kLogoDarkDir,
              height: 40,
              width: 40,
            ),
            const SizedBox(
              width: 10,
            ),
            const Text('Home Page'),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<PostsBloc>().add(const FetchPosts());
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          controller: _scrollController,
          child: Column(
            children: const [
              NewPostCard(),
              _PostsListView(),
            ],
          ),
        ),
      ),
    );
  }

  void _onScroll() {
    // if the bottom of the list is reached, request a new page
    final postBloc = context.read<PostsBloc>();
    if (_isBottom && !postBloc.state.hasReachedMax) {
      postBloc.add(const LoadMorePosts());
    }
  }

  //check when we have reached the bottom
  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * _scrollThreshold);
  }
}

class _PostsListView extends StatefulWidget {
  const _PostsListView({
    Key? key,
  }) : super(key: key);

  @override
  State<_PostsListView> createState() => _PostsListViewState();
}

class _PostsListViewState extends State<_PostsListView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostsBloc, PostsState>(
      builder: (context, state) {
        if (state.status == PostsStatus.initial) {
          return const Center(child: CircularProgressIndicator());
        }
        // in case of failure
        if (state.status == PostsStatus.failure) {
          return const Center(child: Text('Ouch: There was an error!'));
        }
        // if the list is loading and the list is empty (first page)
        if (state.status == PostsStatus.loading && state.posts.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        // if the status is success but the list is empty (no items i)
        if (state.status == PostsStatus.success && state.posts.isEmpty) {
          return Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.width * .3),
            child: EmptyHandlerWidget(
              imageHandlerDir: kNoPostPicDir,
              titleHandler: 'No post created yet.',
              textHandler: "Let't fill it up with your activity!",
              size: MediaQuery.of(context).size.width * .5,
            ),
          );
        }
        // and eventually loading following pages
        return ListView.builder(
          padding: EdgeInsets.zero,
          clipBehavior: Clip.none,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount:
              state.hasReachedMax ? state.posts.length : state.posts.length + 1,
          itemBuilder: (context, index) {
            return index >= state.posts.length
                ? const Center(child: CircularProgressIndicator())
                : PostCard(
                    post: state.posts[index].post,
                    author: state.posts[index].author,
                    project: state.posts[index].project,
                  );
          },
        );
      },
    );
  }
}
