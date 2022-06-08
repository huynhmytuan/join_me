// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Conversation _$ConversationFromJson(Map<String, dynamic> json) => Conversation(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastModified: DateTime.parse(json['lastModified'] as String),
      creator: json['creator'] as String,
      type: $enumDecode(_$ConversationTypeEnumMap, json['type']),
      members: (json['members'] as List<dynamic>)
          .map((dynamic e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ConversationToJson(Conversation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'lastModified': instance.lastModified.toIso8601String(),
      'creator': instance.creator,
      'type': _$ConversationTypeEnumMap[instance.type],
      'members': instance.members,
    };

const _$ConversationTypeEnumMap = {
  ConversationType.directMessage: 'dm',
  ConversationType.group: 'group',
  ConversationType.unknown: 'unknown',
};
