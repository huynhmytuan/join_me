part of 'post_bloc.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object> get props => [];
}

class LoadPost extends PostEvent {
  const LoadPost({required this.postId});

  final String postId;

  @override
  List<Object> get props => [postId];
}

class UpdatePost extends PostEvent {
  const UpdatePost(this.post);

  final Post post;

  @override
  List<Object> get props => [post];
}
