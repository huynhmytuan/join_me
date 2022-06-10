import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:join_me/data/models/models.dart';
import 'package:join_me/data/models/notification.dart';
import 'package:join_me/data/repositories/notification_repository.dart';
import 'package:join_me/data/repositories/repositories.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc({
    required UserRepository userRepository,
    NotificationRepository? notificationRepository,
    MessageRepository? messageRepository,
  })  : _userRepository = userRepository,
        _notificationRepository =
            notificationRepository ?? NotificationRepository(),
        _messageRepository = messageRepository ?? MessageRepository(),
        super(UserState.initial()) {
    on<LoadUser>(_onLoadUser);
    on<UpdateUser>(_onUpdateUser);
    on<SendInvitation>(_onSendInvitation);
  }
  final UserRepository _userRepository;
  final NotificationRepository _notificationRepository;
  final MessageRepository _messageRepository;
  StreamSubscription? _streamSubscription;

  Future<void> _onLoadUser(
    LoadUser event,
    Emitter<UserState> emit,
  ) async {
    emit(state.copyWith(status: UserInfoStatus.loading));
    try {
      await _streamSubscription?.cancel();
      _streamSubscription =
          _userRepository.getUserById(userId: event.userId).listen((user) {
        add(UpdateUser(user));
      });
    } catch (e) {
      log(e.toString());
    }
  }

  void _onUpdateUser(
    UpdateUser event,
    Emitter<UserState> emit,
  ) {
    emit(
      state.copyWith(user: event.user, status: UserInfoStatus.success),
    );
  }

  ///Send an invitation to project via notification.
  Future<void> _onSendInvitation(
    SendInvitation event,
    Emitter<UserState> emit,
  ) async {
    final invitationNotification = NotificationModel(
      id: '',
      createdAt: DateTime.now(),
      notificationType: NotificationType.invite,
      actorId: event.project.owner,
      targetId: event.project.id,
      notifierId: state.user.id,
      isRead: false,
    );
    //Check invite sent before
    final notification = await _notificationRepository.findNotification(
      type: invitationNotification.notificationType,
      actorId: invitationNotification.actorId,
      targetId: invitationNotification.targetId,
      notifier: invitationNotification.targetId,
    );
    if (notification == null) {
      await _notificationRepository.addNotification(
        notification: invitationNotification,
      );
    }
  }
}
