import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:join_me/data/models/app_user.dart';
import 'package:join_me/data/repositories/repositories.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc({
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(UserState.initial()) {
    on<LoadUser>(_onLoadUser);
    on<UpdateUser>(_onUpdateUser);
  }
  final UserRepository _userRepository;
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
}
