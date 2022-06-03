part of 'comment_bloc.dart';

enum CommentStatus { initial, loading, success, failure }

class CommentState extends Equatable {
  const CommentState({
    required this.comments,
    required this.status,
    this.errorMessage = '',
  });
  factory CommentState.initial() =>
      const CommentState(comments: [], status: CommentStatus.initial);

  final List<CommentViewModel> comments;
  final CommentStatus status;
  final String errorMessage;

  CommentState copyWith({
    List<CommentViewModel>? comments,
    CommentStatus? status,
    String? errorMessage,
  }) {
    return CommentState(
      comments: comments ?? this.comments,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  String toString() {
    return 'CommentBloc{ Comment: $comments, Status: ${status.toString()} }';
  }

  @override
  List<Object> get props => [comments, status, errorMessage];
}

class CommentViewModel extends Equatable {
  const CommentViewModel(this.comment, this.author);

  final Comment comment;
  final AppUser author;

  @override
  List<Object> get props => [comment, author];
}
