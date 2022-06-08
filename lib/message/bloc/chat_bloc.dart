import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:join_me/data/models/app_user.dart';

import 'package:join_me/data/models/conversation.dart';
import 'package:join_me/data/models/message.dart';

import 'package:join_me/data/repositories/repositories.dart';
import 'package:join_me/message/bloc/conversations_bloc.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc({
    required MessageRepository messageRepository,
    required UserRepository userRepository,
  })  : _messageRepository = messageRepository,
        _userRepository = userRepository,
        super(ChatState.initial()) {
    on<LoadChat>(_onLoadChat);
    on<UpdateConversation>(_onUpdateConversation);
    on<UpdateMessages>(_onUpdateMessages);
    on<SendMessage>(_onSendMessage);
  }
  final MessageRepository _messageRepository;
  final UserRepository _userRepository;
  StreamSubscription? _conversationSubscription;
  StreamSubscription? _messagesSubscription;

  Future<void> _onLoadChat(
    LoadChat event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(status: ChatViewStatus.loading));
    try {
      await _conversationSubscription?.cancel();
      await _messagesSubscription?.cancel();
      _conversationSubscription = _messageRepository
          .getConversationById(event.conversationId)
          .listen((conversation) {
        add(UpdateConversation(conversation: conversation!));
      });
      _messagesSubscription = _messageRepository
          .loadAllConversationMessages(
        conversationId: event.conversationId,
        userId: event.userId,
      )
          .listen((messages) {
        add(UpdateMessages(messages: messages));
      });
    } catch (e) {
      log(e.toString());
      return;
    }
  }

  Future<void> _onUpdateConversation(
    UpdateConversation event,
    Emitter<ChatState> emit,
  ) async {
    final receivers = await _userRepository.getUsers(
      userIds: event.conversation.members,
    );
    final lastMessage = await _messageRepository.getConversationLastMessage(
      conversationId: event.conversation.id,
    );
    final conversationViewModel = ConversationViewModel(
      conversation: event.conversation,
      members: receivers,
      lastMessage: lastMessage,
    );
    emit(
      state.copyWith(
        conversationViewModel: conversationViewModel,
        status: ChatViewStatus.success,
      ),
    );
  }

  Future<void> _onUpdateMessages(
    UpdateMessages event,
    Emitter<ChatState> emit,
  ) async {
    emit(
      state.copyWith(
        messages: event.messages,
        status: ChatViewStatus.success,
      ),
    );
  }

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<ChatState> emit,
  ) async {
    try {
      final newMessage = Message(
        id: 'id',
        conversationId: state.conversationViewModel.conversation.id,
        createdAt: DateTime.now(),
        authorId: event.author.id,
        content: event.content,
        seenBy: const [],
      );
      await _messageRepository.sendMessage(message: newMessage);
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Future<void> close() {
    _conversationSubscription?.cancel();
    _messagesSubscription?.cancel();
    return super.close();
  }
}
