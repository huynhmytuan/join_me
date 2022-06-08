part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class LoadChat extends ChatEvent {
  const LoadChat({required this.conversationId, required this.userId});

  final String conversationId;
  final String userId;

  @override
  List<Object> get props => [conversationId, userId];
}

class UpdateConversation extends ChatEvent {
  const UpdateConversation({required this.conversation});

  final Conversation conversation;

  @override
  List<Object> get props => [conversation];
}

class UpdateMessages extends ChatEvent {
  const UpdateMessages({required this.messages});

  final List<Message> messages;

  @override
  List<Object> get props => [messages];
}

class SendMessage extends ChatEvent {
  const SendMessage({
    required this.content,
    required this.author,
  });

  final String content;
  final AppUser author;
  @override
  List<Object> get props => [content, author];
}
