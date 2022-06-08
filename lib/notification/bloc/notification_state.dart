part of 'notification_bloc.dart';

enum NotificationLoadingStatus { initial, loading, success, failure }

class NotificationState extends Equatable {
  const NotificationState({
    required this.notifications,
    required this.status,
  });
  factory NotificationState.initial() => const NotificationState(
        notifications: [],
        status: NotificationLoadingStatus.initial,
      );
  final List<NotificationViewModel> notifications;
  final NotificationLoadingStatus status;

  NotificationState copyWith({
    List<NotificationViewModel>? notifications,
    NotificationLoadingStatus? status,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [notifications, status];
}

class NotificationViewModel extends Equatable {
  const NotificationViewModel({
    required this.notificationData,
    required this.actor,
    this.comment,
    this.post,
    this.project,
    this.task,
  });

  final NotificationModel notificationData;

  ///This field to store comment data when
  ///notification is like comment/ comment a post
  final Comment? comment;

  ///This field to store post data when
  ///notification is like post/ comment a post
  final Post? post;

  ///This field to store comment data when
  ///notification is invite to a project
  final Project? project;

  ///This field to store comment data when
  ///notification is new assign task
  final Task? task;

  ///This field to store comment data actor
  final AppUser actor;
  @override
  List<Object?> get props =>
      [notificationData, comment, post, project, task, actor];
}
