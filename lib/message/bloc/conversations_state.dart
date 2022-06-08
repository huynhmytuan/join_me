part of 'conversations_bloc.dart';

enum ConversationsStatus { initial, loading, success, failure }

class ConversationsState extends Equatable {
  const ConversationsState({
    required this.conversations,
    required this.status,
  });

  factory ConversationsState.initial() => const ConversationsState(
        conversations: [],
        status: ConversationsStatus.initial,
      );
  final List<ConversationViewModel> conversations;
  final ConversationsStatus status;

  @override
  List<Object> get props => [conversations, status];
  ConversationsState copyWith({
    List<ConversationViewModel>? conversations,
    ConversationsStatus? status,
  }) {
    return ConversationsState(
      conversations: conversations ?? this.conversations,
      status: status ?? this.status,
    );
  }
}

class ConversationViewModel extends Equatable {
  const ConversationViewModel({
    required this.conversation,
    required this.members,
    required this.lastMessage,
  });

  final Conversation conversation;
  final List<AppUser> members;
  final Message? lastMessage;
  @override
  List<Object?> get props => [conversation, members, lastMessage];
}
