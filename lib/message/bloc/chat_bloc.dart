import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:join_me/app/cubit/app_message_cubit.dart';
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
    required AppMessageCubit appMessageCubit,
  })  : _messageRepository = messageRepository,
        _userRepository = userRepository,
        _appMessageCubit = appMessageCubit,
        super(ChatState.initial()) {
    on<LoadChat>(_onLoadChat);
    on<ConversationNotFound>(_onConversationNotFound);
    on<UpdateConversation>(_onUpdateConversation);
    on<UpdateMessages>(_onUpdateMessages);
    on<SendMessage>(_onSendMessage);
    on<DeletedMessage>(_onDeletedMessage);
    on<DeleteConversation>(_onDeleteConversation);
    on<AddMember>(_onAddMember);
    on<RemoveMember>(_onRemoveMember);
  }
  final MessageRepository _messageRepository;
  final UserRepository _userRepository;
  final AppMessageCubit _appMessageCubit;
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
        if (conversation != null) {
          add(UpdateConversation(conversation: conversation));
        } else {
          add(ConversationNotFound());
        }
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

  void _onConversationNotFound(
    ConversationNotFound event,
    Emitter<ChatState> emit,
  ) {
    emit(state.copyWith(status: ChatViewStatus.notFound));
    _conversationSubscription?.cancel();
    _messagesSubscription?.cancel();
  }

  Future<void> _onUpdateConversation(
    UpdateConversation event,
    Emitter<ChatState> emit,
  ) async {
    final members = await _userRepository.getUsers(
      userIds: event.conversation.members,
    );
    final lastMessage = await _messageRepository.getConversationLastMessage(
      conversationId: event.conversation.id,
    );
    final conversationViewModel = ConversationViewModel(
      conversation: event.conversation,
      members: members,
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
        content: event.content.trim(),
        seenBy: const [],
      );
      await _messageRepository.sendMessage(message: newMessage);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _onDeletedMessage(
    DeletedMessage event,
    Emitter<ChatState> emit,
  ) async {
    await _messageRepository.deleteMessage(message: event.message);
    _appMessageCubit.showSuccessfulSnackBar(message: 'Message deleted');
  }

  Future<void> _onDeleteConversation(
    DeleteConversation event,
    Emitter<ChatState> emit,
  ) async {
    try {
      await _messageRepository.deleteConversation(
        conversation: state.conversationViewModel.conversation,
      );
      emit(state.copyWith(status: ChatViewStatus.deleted));
      _appMessageCubit.showSuccessfulSnackBar(message: 'Conversation deleted');
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _onAddMember(
    AddMember event,
    Emitter<ChatState> emit,
  ) async {
    try {
      await _messageRepository.addMember(
        event.user,
        state.conversationViewModel.conversation,
      );
      _appMessageCubit.showSuccessfulSnackBar(
        message: 'A new member has been added',
      );
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _onRemoveMember(
    RemoveMember event,
    Emitter<ChatState> emit,
  ) async {
    try {
      await _messageRepository.removeMember(
        event.user,
        state.conversationViewModel.conversation,
      );
      _appMessageCubit.showSuccessfulSnackBar(
        message: 'A member has been removed',
      );
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
