import 'package:equatable/equatable.dart';

import 'package:join_me/data/models/models.dart';
import 'package:join_me/project/bloc/project_bloc.dart';

class PostViewModel extends Equatable {
  const PostViewModel({
    required this.author,
    required this.post,
    this.project,
  });

  factory PostViewModel.empty() {
    return PostViewModel(
      author: AppUser.empty,
      post: Post.empty(),
    );
  }

  final AppUser author;
  final Post post;
  final Project? project;

  PostViewModel copyWith({
    AppUser? author,
    Post? post,
    Project? project,
  }) {
    return PostViewModel(
      author: author ?? this.author,
      post: post ?? this.post,
      project: project ?? this.project,
    );
  }

  @override
  List<Object?> get props => [author, post];
}
