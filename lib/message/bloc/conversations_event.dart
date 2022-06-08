part of 'conversations_bloc.dart';

abstract class ConversationsEvent extends Equatable {
  const ConversationsEvent();

  @override
  List<Object> get props => [];
}

class UpdateConversations extends ConversationsEvent {
  const UpdateConversations(this.conversations);

  final List<Conversation> conversations;
  @override
  List<Object> get props => [conversations];
}

class FetchConversations extends ConversationsEvent {
  const FetchConversations(this.userId);

  final String userId;
  @override
  List<Object> get props => [userId];
}
