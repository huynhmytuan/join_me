import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:join_me/data/models/models.dart';
import 'package:join_me/data/repositories/repositories.dart';

part 'conversations_event.dart';
part 'conversations_state.dart';

class ConversationsBloc extends Bloc<ConversationsEvent, ConversationsState> {
  ConversationsBloc({
    required MessageRepository messageRepository,
    required UserRepository userRepository,
  })  : _messageRepository = messageRepository,
        _userRepository = userRepository,
        super(ConversationsState.initial()) {
    on<FetchConversations>(_onFetchConversations);
    on<UpdateConversations>(_onUpdateConversations);
  }

  final MessageRepository _messageRepository;
  final UserRepository _userRepository;
  StreamSubscription? _streamSubscription;

  Future<void> _onFetchConversations(
    FetchConversations event,
    Emitter<ConversationsState> emit,
  ) async {
    emit(state.copyWith(status: ConversationsStatus.loading));
    try {
      await _streamSubscription?.cancel();
      _streamSubscription = _messageRepository
          .getUserConversations(userId: event.userId)
          .listen((conversations) {
        add(UpdateConversations(conversations));
      });
    } catch (e) {
      emit(state.copyWith(status: ConversationsStatus.failure));
    }
  }

  Future<void> _onUpdateConversations(
    UpdateConversations event,
    Emitter<ConversationsState> emit,
  ) async {
    final conversationViewModels = <ConversationViewModel>[];
    for (final conversation in event.conversations) {
      final receivers = await _userRepository.getUsers(
        userIds: conversation.members,
      );
      final lastMessage = await _messageRepository.getConversationLastMessage(
        conversationId: conversation.id,
      );
      conversationViewModels.add(
        ConversationViewModel(
          conversation: conversation,
          members: receivers,
          lastMessage: lastMessage,
        ),
      );
    }
    emit(
      state.copyWith(conversations: conversationViewModels),
    );
  }
}
