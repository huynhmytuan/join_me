part of 'posts_bloc.dart';

abstract class PostsEvent extends Equatable {
  const PostsEvent();

  @override
  List<Object> get props => [];
}

class FetchPosts extends PostsEvent {
  const FetchPosts({this.userId});

  ///Pass userId in case need to
  ///Fetch all posts of an certain user.
  final String? userId;
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FetchPosts && other.userId == userId;
  }

  @override
  int get hashCode => userId.hashCode;
}
