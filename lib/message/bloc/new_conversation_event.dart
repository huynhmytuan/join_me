part of 'new_conversation_bloc.dart';

abstract class NewConversationEvent extends Equatable {
  const NewConversationEvent();

  @override
  List<Object> get props => [];
}

class AddSender extends NewConversationEvent {
  const AddSender(this.sender);

  final AppUser sender;
  @override
  List<Object> get props => [sender];
}

class AddReceiver extends NewConversationEvent {
  const AddReceiver(this.receiver);

  final AppUser receiver;
  @override
  List<Object> get props => [receiver];
}

class RemoveReceiver extends NewConversationEvent {
  const RemoveReceiver(this.receiver);

  final AppUser receiver;
  @override
  List<Object> get props => [receiver];
}

class UpdateConversation extends NewConversationEvent {}

class AddConversation extends NewConversationEvent {
  const AddConversation({
    required this.senderId,
    required this.receiverIds,
    required this.firstMessageContent,
  });

  final String senderId;
  final List<String> receiverIds;
  final String firstMessageContent;

  @override
  List<Object> get props => [senderId, receiverIds, firstMessageContent];
}

class SendMessageToCurrentConversation extends NewConversationEvent {
  const SendMessageToCurrentConversation({required this.messageContent});

  final String messageContent;

  @override
  List<Object> get props => [messageContent];
}
