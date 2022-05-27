// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) => Post(
      id: json['id'] as String?,
      type: $enumDecode(_$PostTypeEnumMap, json['type']),
      authorId: json['authorId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      content: json['content'] as String,
      medias: (json['medias'] as List<dynamic>)
          .map((dynamic e) => e as String)
          .toList(),
      projectInvitationId: json['projectInvitationId'] as String?,
      likes: (json['likes'] as List<dynamic>)
          .map((dynamic e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'id': instance.id,
      'type': _$PostTypeEnumMap[instance.type],
      'authorId': instance.authorId,
      'medias': instance.medias,
      'createdAt': instance.createdAt.toIso8601String(),
      'content': instance.content,
      'projectInvitationId': instance.projectInvitationId,
      'likes': instance.likes,
    };

const _$PostTypeEnumMap = {
  PostType.normal: 'normal',
  PostType.invitation: 'invitation',
  PostType.unknown: 'unknown',
};
