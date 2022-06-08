// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    NotificationModel(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      notificationType:
          $enumDecode(_$NotificationTypeEnumMap, json['notificationType']),
      actorId: json['actorId'] as String,
      targetId: json['targetId'] as String,
      notifierId: json['notifierId'] as String,
    );

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'notificationType': _$NotificationTypeEnumMap[instance.notificationType],
      'actorId': instance.actorId,
      'targetId': instance.targetId,
      'notifierId': instance.notifierId,
    };

const _$NotificationTypeEnumMap = {
  NotificationType.likePost: 'likePost',
  NotificationType.likeComment: 'likeComment',
  NotificationType.comment: 'comment',
  NotificationType.invite: 'invite',
  NotificationType.assign: 'assign',
};
