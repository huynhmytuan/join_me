import 'package:equatable/equatable.dart';
import 'package:join_me/utilities/keys/notification_keys.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification.g.dart';

enum NotificationType {
  @JsonValue('likePost')
  likePost,
  @JsonValue('likeComment')
  likeComment,
  @JsonValue('comment')
  comment,
  @JsonValue('invite')
  invite,
  @JsonValue('assign')
  assign,
}

@JsonSerializable()
class NotificationModel extends Equatable {
  const NotificationModel({
    required this.id,
    required this.createdAt,
    required this.notificationType,
    required this.actorId,
    required this.targetId,
    required this.notifierId,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);
  //properties
  @JsonKey(name: NotificationKeys.id)
  final String id;
  @JsonKey(name: NotificationKeys.createdAt)
  final DateTime createdAt;
  @JsonKey(name: NotificationKeys.notificationType)
  final NotificationType notificationType;
  @JsonKey(name: NotificationKeys.actorId)
  final String actorId;
  @JsonKey(name: NotificationKeys.targetId)
  final String targetId;
  @JsonKey(name: NotificationKeys.notifierId)
  final String notifierId;

  NotificationModel copyWith({
    String? id,
    DateTime? createdAt,
    NotificationType? notificationType,
    String? actorId,
    String? targetId,
    String? notifierId,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      notificationType: notificationType ?? this.notificationType,
      actorId: actorId ?? this.actorId,
      targetId: targetId ?? this.targetId,
      notifierId: notifierId ?? this.notifierId,
    );
  }

  @override
  bool get stringify => true;
  @override
  List<Object> get props {
    return [id, createdAt, actorId, targetId, notificationType, notifierId];
  }
}
