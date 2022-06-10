import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:join_me/data/models/models.dart';
import 'package:join_me/data/repositories/repositories.dart';

part 'new_conversation_event.dart';
part 'new_conversation_state.dart';

class NewConversationBloc
    extends Bloc<NewConversationEvent, NewConversationState> {
  NewConversationBloc({
    required MessageRepository messageRepository,
  })  : _messageRepository = messageRepository,
        super(NewConversationState.initial()) {
    on<AddSender>(_onAddSender);
    on<AddReceiver>(_onAddReceiver);
    on<RemoveReceiver>(_onRemoveReceiver);
    on<UpdateConversation>(_onUpdateConversation);
    on<AddConversation>(_onAddConversation);
    on<SendMessageToCurrentConversation>(_onSendMessageToCurrentConversation);
  }
  final MessageRepository _messageRepository;

  void _onAddSender(
    AddSender event,
    Emitter<NewConversationState> emit,
  ) {
    emit(
      state.copyWith(
        sender: event.sender,
      ),
    );
  }

  void _onAddReceiver(
    AddReceiver event,
    Emitter<NewConversationState> emit,
  ) {
    final receivers = List.of(state.receivers);
    if (receivers.contains(event.receiver)) {
      return;
    }
    emit(
      state.copyWith(
        receivers: receivers..add(event.receiver),
      ),
    );
    add(UpdateConversation());
  }

  void _onRemoveReceiver(
    RemoveReceiver event,
    Emitter<NewConversationState> emit,
  ) {
    final receivers = List.of(state.receivers)..remove(event.receiver);
    emit(
      state.copyWith(
        receivers: receivers,
      ),
    );
    add(UpdateConversation());
  }

  Future<void> _onUpdateConversation(
    UpdateConversation event,
    Emitter<NewConversationState> emit,
  ) async {
    if (state.receivers.isEmpty) {
      emit(
        state.copyWith(),
      );
      return;
    }
    final members = List.of(state.receivers)..add(state.sender);
    final conversation = (members.length == 2)
        ? await _messageRepository.getConversationByMembers(
            members.map((user) => user.id).toList(),
          )
        : null;
    final messages = conversation != null
        ? await _messageRepository
            .loadAllConversationMessages(
              conversationId: conversation.id,
            )
            .first
        : <Message>[];
    emit(
      state.copyWith(
        conversation: conversation,
        messages: messages,
      ),
    );
  }

  Future<void> _onAddConversation(
    AddConversation event,
    Emitter<NewConversationState> emit,
  ) async {
    try {
      final now = DateTime.now();
      final receivers = event.receiverIds;
      final members = List<String>.from(receivers..add(event.senderId));
      final conversation = Conversation(
        id: '',
        createdAt: now,
        lastModified: now,
        creator: event.senderId,
        type: receivers.length == 2
            ? ConversationType.directMessage
            : ConversationType.group,
        members: members,
      );

      final firstMessage = Message(
        id: '',
        conversationId: '',
        createdAt: now,
        authorId: event.senderId,
        content: event.firstMessageContent.trim(),
        seenBy: const [],
      );
      final newConversation = await _messageRepository.addConversation(
        conversation: conversation,
        firstMessage: firstMessage,
      );
      emit(
        state.copyWith(
          conversation: newConversation,
          newConversationStatus: NewConversationStatus.newConversationAdded,
        ),
      );
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _onSendMessageToCurrentConversation(
    SendMessageToCurrentConversation event,
    Emitter<NewConversationState> emit,
  ) async {
    try {
      final now = DateTime.now();
      final message = Message(
        id: '',
        conversationId: state.conversation!.id,
        createdAt: now,
        authorId: state.sender.id,
        content: event.messageContent.trim(),
        seenBy: const [],
      );
      await _messageRepository.sendMessage(message: message);
      emit(
        state.copyWith(
          conversation: state.conversation,
          newConversationStatus: NewConversationStatus.newMessageSent,
        ),
      );
    } catch (e) {
      log(e.toString());
    }
  }
}
