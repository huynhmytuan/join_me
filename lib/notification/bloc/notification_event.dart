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
