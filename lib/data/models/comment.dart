import 'package:equatable/equatable.dart';
import 'package:join_me/utilities/keys/comment_keys.dart';

import 'package:json_annotation/json_annotation.dart';

part 'comment.g.dart';

@JsonSerializable()
class Comment extends Equatable {
  const Comment({
    required this.createdAt,
    required this.content,
    required this.authorId,
    required this.postId,
    required this.likes,
  });
  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);

  Map<String, dynamic> toJson() => _$CommentToJson(this);
  //properties
  @JsonKey(name: CommentKeys.createdAt)
  final DateTime createdAt;
  @JsonKey(name: CommentKeys.content)
  final String content;
  @JsonKey(name: CommentKeys.authorId)
  final String authorId;
  @JsonKey(name: CommentKeys.postId)
  final String postId;
  final List<String> likes;

  Comment copyWith({
    DateTime? createdAt,
    String? content,
    String? authorId,
    String? postId,
    List<String>? likes,
  }) {
    return Comment(
      createdAt: createdAt ?? this.createdAt,
      content: content ?? this.content,
      authorId: authorId ?? this.authorId,
      postId: postId ?? this.postId,
      likes: likes ?? this.likes,
    );
  }

  @override
  bool get stringify => true;
  @override
  List<Object> get props {
    return [createdAt, content, authorId, postId, likes];
  }
}
