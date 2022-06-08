part of 'chat_bloc.dart';

enum ChatViewStatus { initial, loading, success, failure }

class ChatState extends Equatable {
  const ChatState({
    required this.conversationViewModel,
    required this.messages,
    required this.status,
  });
  factory ChatState.initial() => ChatState(
        conversationViewModel: ConversationViewModel(
          conversation: Conversation.empty(),
          lastMessage: null,
          members: const [],
        ),
        messages: const [],
        status: ChatViewStatus.initial,
      );
  final ConversationViewModel conversationViewModel;
  final List<Message> messages;
  final ChatViewStatus status;

  @override
  List<Object?> get props => [conversationViewModel, messages];
  ChatState copyWith({
    ConversationViewModel? conversationViewModel,
    List<Message>? messages,
    ChatViewStatus? status,
  }) {
    return ChatState(
      conversationViewModel:
          conversationViewModel ?? this.conversationViewModel,
      messages: messages ?? this.messages,
      status: status ?? this.status,
    );
  }
}
