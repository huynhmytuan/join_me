part of 'send_user_message_cubit.dart';

enum SendUserMessageStatus {
  initial,
  requesting,
  noConversation,
  conversationCreated
}

class SendUserMessageState extends Equatable {
  const SendUserMessageState({this.conversation, required this.status});
  factory SendUserMessageState.initial() =>
      const SendUserMessageState(status: SendUserMessageStatus.initial);
  final Conversation? conversation;
  final SendUserMessageStatus status;

  SendUserMessageState copyWith({
    Conversation? conversation,
    SendUserMessageStatus? status,
  }) {
    return SendUserMessageState(
      conversation: conversation ?? this.conversation,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [conversation, status];
}
