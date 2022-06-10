part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class LoadNotifications extends NotificationEvent {
  const LoadNotifications(this.userId);
  final String userId;
  @override
  List<Object> get props => [userId];
}

class UpdateNotifications extends NotificationEvent {
  const UpdateNotifications(this.notifications);

  final List<NotificationModel> notifications;
  @override
  List<Object> get props => [notifications];
}

class MarkAsRead extends NotificationEvent {
  const MarkAsRead(this.notificationId, this.notifierId);

  final String notificationId;
  final String notifierId;
  @override
  List<Object> get props => [notificationId, notifierId];
}

class MarkAllAsRead extends NotificationEvent {
  const MarkAllAsRead(this.notifierId);
  final String notifierId;
  @override
  List<Object> get props => [notifierId, notifierId];
}

class DeleteNotification extends NotificationEvent {
  const DeleteNotification(this.notification);
  final NotificationModel notification;
  @override
  List<Object> get props => [notification];
}
