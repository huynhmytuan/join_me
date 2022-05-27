import 'package:equatable/equatable.dart';
import 'package:join_me/utilities/keys/post_keys.dart';

import 'package:json_annotation/json_annotation.dart';

part 'post.g.dart';

enum PostType {
  @JsonValue('normal')
  normal,
  @JsonValue('invitation')
  invitation,
  unknown,
}

@JsonSerializable()
class Post extends Equatable {
  const Post({
    required this.id,
    required this.type,
    required this.authorId,
    required this.createdAt,
    required this.content,
    required this.medias,
    required this.projectInvitationId,
    required this.likes,
  });
  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);

  //Properties
  @JsonKey(name: PostKeys.id)
  final String? id;

  ///Type Of Post
  @JsonKey(name: PostKeys.type)
  final PostType type;

  ///Return author id who created the post
  @JsonKey(name: PostKeys.authorId)
  final String authorId;

  ///Return author id who created the post
  @JsonKey(name: PostKeys.medias)
  final List<String> medias;

  ///Return time when the post created.
  @JsonKey(name: PostKeys.createdAt)
  final DateTime createdAt;

  ///Content of the post
  @JsonKey(name: PostKeys.content)
  final String content;

  ///Return id [String] of the project which post invite to
  ///If this a an normal post, this field can be 'null' or 'empty'
  @JsonKey(name: PostKeys.projectInvitationId)
  final String? projectInvitationId;

  ///Return a list of id [String], contain all user's id.
  @JsonKey(name: PostKeys.likes)
  final List<String> likes;

  Post copyWith({
    String? id,
    PostType? type,
    String? authorId,
    DateTime? createdAt,
    String? content,
    String? projectInvitationId,
    List<String>? likes,
    List<String>? imageUrls,
  }) {
    return Post(
      id: id ?? this.id,
      type: type ?? this.type,
      authorId: authorId ?? this.authorId,
      createdAt: createdAt ?? this.createdAt,
      content: content ?? this.content,
      medias: imageUrls ?? this.medias,
      projectInvitationId: projectInvitationId ?? this.projectInvitationId,
      likes: likes ?? this.likes,
    );
  }

  @override
  List<Object?> get props =>
      [id, type, authorId, createdAt, content, projectInvitationId, likes];
}
