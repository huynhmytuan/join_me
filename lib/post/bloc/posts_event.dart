part of 'posts_bloc.dart';

abstract class PostsEvent extends Equatable {
  const PostsEvent();

  @override
  List<Object> get props => [];
}

class FetchPosts extends PostsEvent {
  const FetchPosts({this.userId});

  ///Pass userId to
  ///Fetch all posts of an certain user.
  final String? userId;
}

class LoadMorePosts extends PostsEvent {
  const LoadMorePosts({this.userId});

  final String? userId;
}

class DeletePost extends PostsEvent {
  const DeletePost({required this.postId});

  final String postId;
}

class PostsPageUpdates extends PostsEvent {
  const PostsPageUpdates({
    required this.pageNumber,
    required this.newPostsPage,
    this.userId,
  });

  final int pageNumber;
  final List<Post> newPostsPage;
  final String? userId;
  @override
  List<Object> get props => [pageNumber, newPostsPage];
}
