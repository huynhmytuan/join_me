part of 'post_bloc.dart';

enum PostStatus { initial, loading, success, failure }

class PostState extends Equatable {
  const PostState({
    required this.postViewModel,
    required this.status,
  });
  factory PostState.initial() {
    return PostState(
      postViewModel: PostViewModel.empty(),
      status: PostStatus.initial,
    );
  }

  final PostViewModel postViewModel;
  final PostStatus status;

  @override
  List<Object> get props => [postViewModel];
  PostState copyWith({
    PostViewModel? postViewModel,
    PostStatus? status,
  }) {
    return PostState(
      postViewModel: postViewModel ?? this.postViewModel,
      status: status ?? this.status,
    );
  }
}
