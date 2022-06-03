part of 'posts_bloc.dart';

enum PostsStatus { initial, loading, success, failure }

class PostsState {
  const PostsState({
    required this.postsPages,
    required this.status,
    required this.hasReachedMax,
  });

  factory PostsState.initial() {
    return const PostsState(
      postsPages: [],
      status: PostsStatus.initial,
      hasReachedMax: false,
    );
  }

  final List<List<PostViewModel>> postsPages;
  final PostsStatus status;
  final bool hasReachedMax;

  List<PostViewModel> get posts => postsPages.expand((e) => e).toList();

  PostsState copyWith({
    List<List<PostViewModel>>? postsPages,
    PostsStatus? status,
    bool? hasReachedMax,
  }) {
    return PostsState(
      postsPages: postsPages ?? this.postsPages,
      status: status ?? this.status,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}
