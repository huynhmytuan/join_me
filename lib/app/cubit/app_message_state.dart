part of 'app_message_cubit.dart';

enum AppMessageStatus { none, info, successful, errorMessage }

class AppMessageState extends Equatable {
  const AppMessageState({
    required this.message,
    required this.messageStatus,
    required this.timestamp,
    this.iconData,
  });
  factory AppMessageState.initial() => const AppMessageState(
        message: '',
        messageStatus: AppMessageStatus.none,
        timestamp: '',
      );
  final String message;
  final AppMessageStatus messageStatus;

  ///Change it in case need to custom icon
  final IconData? iconData;
  final String timestamp;

  AppMessageState copyWith({
    String? message,
    AppMessageStatus? messageStatus,
    String? timestamp,
  }) {
    return AppMessageState(
      message: message ?? this.message,
      messageStatus: messageStatus ?? this.messageStatus,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  List<Object?> get props => [message, messageStatus, timestamp, iconData];
}
