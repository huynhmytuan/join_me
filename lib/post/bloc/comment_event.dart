part of 'comment_bloc.dart';

abstract class CommentEvent extends Equatable {
  const CommentEvent();

  @override
  List<Object> get props => [];
}

class LoadComments extends CommentEvent {
  const LoadComments(this.postId);

  final String postId;

  @override
  List<Object> get props => [postId];
}

class AddComment extends CommentEvent {
  const AddComment(this.comment, this.post);

  final Comment comment;
  final Post post;

  @override
  List<Object> get props => [comment, post];
}

class DeleteComment extends CommentEvent {
  const DeleteComment(this.comment);

  final Comment comment;

  @override
  List<Object> get props => [comment];
}

class UpdateComments extends CommentEvent {
  const UpdateComments(this.comments);

  final List<CommentViewModel> comments;

  @override
  List<Object> get props => [comments];
}
