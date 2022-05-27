part of 'posts_bloc.dart';

enum PostsStatus { initial, success, failure }

class PostsState extends Equatable {
  const PostsState({
    this.post = const <PostViewModel>[],
    this.status = PostsStatus.initial,
    this.hasReachedMax = false,
  });

  final List<PostViewModel> post;
  final PostsStatus status;
  final bool hasReachedMax;

  @override
  List<Object> get props => [post, status, hasReachedMax];
}

class PostViewModel extends Equatable {
  const PostViewModel(this.author, this.post);

  final AppUser author;
  final Post post;

  @override
  List<Object> get props => [author, post];

  @override
  bool get stringify => true;
}
