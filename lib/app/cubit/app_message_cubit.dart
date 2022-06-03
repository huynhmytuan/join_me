import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'app_message_state.dart';

class AppMessageCubit extends Cubit<AppMessageState> {
  AppMessageCubit() : super(AppMessageState.initial());

  void showInfoSnackbar({required String message}) {
    emit(
      state.copyWith(
        message: message,
        messageStatus: AppMessageStatus.info,
        timestamp: DateTime.now().toIso8601String(),
      ),
    );
  }

  void showSuccessfulSnackBar({required String message}) {
    emit(
      state.copyWith(
        message: message,
        messageStatus: AppMessageStatus.successful,
        timestamp: DateTime.now().toIso8601String(),
      ),
    );
  }

  void showErrorSnackBar({required String message}) {
    emit(
      state.copyWith(
        message: message,
        messageStatus: AppMessageStatus.errorMessage,
        timestamp: DateTime.now().toIso8601String(),
      ),
    );
  }
}
