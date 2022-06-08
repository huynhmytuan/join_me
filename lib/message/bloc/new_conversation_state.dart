part of 'new_conversation_bloc.dart';

enum LoadConversationStatus { loading, success, failure }

enum NewConversationStatus { initial, newConversationAdded, newMessageSent }

class NewConversationState extends Equatable {
  const NewConversationState({
    required this.receivers,
    required this.sender,
    required this.newConversationStatus,
    this.conversation,
    this.messages = const [],
  });
  factory NewConversationState.initial() => const NewConversationState(
        sender: AppUser.empty,
        receivers: [],
        newConversationStatus: NewConversationStatus.initial,
      );
  final AppUser sender;
  final List<AppUser> receivers;
  final Conversation? conversation;
  final List<Message> messages;
  final NewConversationStatus newConversationStatus;

  NewConversationState copyWith({
    AppUser? sender,
    List<AppUser>? receivers,
    Conversation? conversation,
    List<Message>? messages,
    NewConversationStatus? newConversationStatus,
  }) {
    return NewConversationState(
      sender: sender ?? this.sender,
      receivers: receivers ?? this.receivers,
      conversation: conversation,
      messages: messages ?? this.messages,
      newConversationStatus:
          newConversationStatus ?? this.newConversationStatus,
    );
  }

  @override
  List<Object?> get props =>
      [receivers, conversation, messages, newConversationStatus];
}
