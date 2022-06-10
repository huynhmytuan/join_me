import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:join_me/data/models/models.dart';
import 'package:join_me/data/repositories/repositories.dart';

part 'send_user_message_state.dart';

class SendUserMessageCubit extends Cubit<SendUserMessageState> {
  SendUserMessageCubit({
    required MessageRepository messageRepository,
  })  : _messageRepository = messageRepository,
        super(SendUserMessageState.initial());
  final MessageRepository _messageRepository;
  Future<void> requestSendMessage(AppUser currentUser, AppUser user) async {
    //Check has conversation or not
    emit(
      state.copyWith(
        status: SendUserMessageStatus.requesting,
      ),
    );
    //Check conversation store in state
    if (state.conversation != null) {
      emit(
        state.copyWith(
          status: SendUserMessageStatus.conversationCreated,
        ),
      );
      return;
    }
    //Check conversation on sever
    final conversation = await _messageRepository
        .getConversationByMembers([user.id, currentUser.id]);
    if (conversation == null) {
      emit(
        state.copyWith(
          status: SendUserMessageStatus.noConversation,
        ),
      );
    } else {
      emit(
        state.copyWith(
          conversation: conversation,
          status: SendUserMessageStatus.conversationCreated,
        ),
      );
    }
  }

  Future<void> createUserConversation(
    AppUser currentUser,
    AppUser user,
    String messageContent,
  ) async {
    emit(
      state.copyWith(
        status: SendUserMessageStatus.requesting,
      ),
    );
    final now = DateTime.now();
    final message = Message(
      id: '',
      conversationId: '',
      createdAt: now,
      authorId: currentUser.id,
      content: messageContent,
      seenBy: [currentUser.id],
    );
    final newConversation = Conversation(
      id: '',
      createdAt: now,
      lastModified: now,
      creator: currentUser.id,
      type: ConversationType.directMessage,
      members: [currentUser.id, user.id],
    );
    final conversation = await _messageRepository.addConversation(
      conversation: newConversation,
      firstMessage: message,
    );
    emit(
      state.copyWith(
        conversation: conversation,
        status: SendUserMessageStatus.conversationCreated,
      ),
    );
  }
}
