// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      conversationId: json['conversationId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      authorId: json['authorId'] as String,
      content: json['content'] as String,
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'conversationId': instance.conversationId,
      'createdAt': instance.createdAt.toIso8601String(),
      'authorId': instance.authorId,
      'content': instance.content,
    };
