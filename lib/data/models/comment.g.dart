// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      content: json['content'] as String,
      authorId: json['authorId'] as String,
      postId: json['postId'] as String,
      likes: (json['likes'] as List<dynamic>)
          .map((dynamic e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'content': instance.content,
      'authorId': instance.authorId,
      'postId': instance.postId,
      'likes': instance.likes,
    };
