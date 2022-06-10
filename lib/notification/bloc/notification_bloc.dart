import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:join_me/data/models/models.dart';
import 'package:join_me/data/models/notification.dart';
import 'package:join_me/data/repositories/comment_repository.dart';
import 'package:join_me/data/repositories/notification_repository.dart';
import 'package:join_me/data/repositories/repositories.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc({
    required NotificationRepository notificationRepository,
  })  : _notificationRepository = notificationRepository,
        super(NotificationState.initial()) {
    on<LoadNotifications>(_onLoadNotifications);
    on<UpdateNotifications>(_onUpdateNotifications);
    on<MarkAsRead>(_onMarkAsRead);
    on<MarkAllAsRead>(_onMarkAllAsRead);
    on<DeleteNotification>(_onDeleteNotification);
  }

  final NotificationRepository _notificationRepository;
  StreamSubscription<List<NotificationModel>>? _streamSubscription;
  Future<void> _onLoadNotifications(
    LoadNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    emit(state.copyWith(status: NotificationLoadingStatus.loading));
    try {
      await _streamSubscription?.cancel();
      _streamSubscription = _notificationRepository
          .fetchAllUserNotification(userId: event.userId)
          .listen((notifications) {
        add(UpdateNotifications(notifications));
      });
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(status: NotificationLoadingStatus.failure));
    }
  }

  Future<void> _onUpdateNotifications(
    UpdateNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    final list = <NotificationViewModel>[];
    for (final notification in event.notifications) {
      final notificationViewModel =
          await getNotificationViewModel(notification);
      if (notificationViewModel == null) {
        await _notificationRepository.deleteNotification(
          notification: notification,
        );
      } else {
        list.add(notificationViewModel);
      }
    }
    emit(
      state.copyWith(
        notifications: list,
        status: NotificationLoadingStatus.success,
      ),
    );
  }

  Future<NotificationViewModel?> getNotificationViewModel(
    NotificationModel notificationModel,
  ) async {
    final actor = await UserRepository()
        .getUserById(userId: notificationModel.actorId)
        .first;
    switch (notificationModel.notificationType) {
      case NotificationType.likePost:
        final post = await PostRepository()
            .getPostById(postId: notificationModel.targetId)
            .first;
        if (post == null) {
          return null;
        }
        return NotificationViewModel(
          notificationData: notificationModel,
          actor: actor,
          post: post,
        );
      case NotificationType.likeComment:
        final postId = notificationModel.targetId.trim().split('/')[0];
        final commentId = notificationModel.targetId.trim().split('/')[1];
        final comment =
            await CommentRepository().getCommentById(postId, commentId);
        if (comment == null) {
          return null;
        }
        return NotificationViewModel(
          notificationData: notificationModel,
          actor: actor,
          comment: comment,
        );
      case NotificationType.comment:
        final postId = notificationModel.targetId.trim().split('/')[0];
        final commentId = notificationModel.targetId.trim().split('/')[1];
        final comment =
            await CommentRepository().getCommentById(postId, commentId);
        if (comment == null) {
          return null;
        }
        return NotificationViewModel(
          notificationData: notificationModel,
          actor: actor,
          comment: comment,
        );
      case NotificationType.invite:
        final project = await ProjectRepository()
            .getProjectById(notificationModel.targetId)
            .first;
        if (project == null) {
          return null;
        }
        return NotificationViewModel(
          notificationData: notificationModel,
          actor: actor,
          project: project,
        );
      case NotificationType.assign:
        final task = await TaskRepository()
            .getTaskById(notificationModel.targetId)
            .first;
        if (task == null) {
          return null;
        }
        return NotificationViewModel(
          notificationData: notificationModel,
          actor: actor,
          task: task,
        );
    }
  }

  Future<void> _onMarkAsRead(
    MarkAsRead event,
    Emitter<NotificationState> emit,
  ) async {
    await _notificationRepository.markAsRead(
      notificationId: event.notificationId,
      notifierId: event.notifierId,
    );
  }

  Future<void> _onMarkAllAsRead(
    MarkAllAsRead event,
    Emitter<NotificationState> emit,
  ) async {
    await _notificationRepository.markAllAsRead(
      notifierId: event.notifierId,
    );
  }

  Future<void> _onDeleteNotification(
    DeleteNotification event,
    Emitter<NotificationState> emit,
  ) async {
    await _notificationRepository.deleteNotification(
      notification: event.notification,
    );
  }
}
