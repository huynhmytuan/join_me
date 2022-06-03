import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:join_me/data/models/models.dart';
import 'package:join_me/data/repositories/comment_repository.dart';
import 'package:join_me/data/repositories/repositories.dart';

part 'comment_event.dart';
part 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  CommentBloc({
    required CommentRepository commentRepository,
    required UserRepository userRepository,
  })  : _commentRepository = commentRepository,
        _userRepository = userRepository,
        super(CommentState.initial()) {
    on<LoadComments>(_onLoadComments);
    on<UpdateComments>(_onUpdateComments);
    on<AddComment>(_onAddComment);
    on<DeleteComment>(_onDeleteComment);
  }

  final CommentRepository _commentRepository;
  final UserRepository _userRepository;
  StreamSubscription? _commentSubscription;

  Future<void> _onLoadComments(
    LoadComments event,
    Emitter<CommentState> emit,
  ) async {
    emit(state.copyWith(status: CommentStatus.loading));
    try {
      await _commentSubscription?.cancel();
      _commentSubscription =
          _commentRepository.fetchAllPostComment(postId: event.postId).listen(
        (comments) async {
          final listViewModels = <CommentViewModel>[];
          for (final comment in comments) {
            final author =
                await _userRepository.getUserById(userId: comment.authorId);
            listViewModels.add(CommentViewModel(comment, author));
          }
          add(UpdateComments(listViewModels));
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CommentStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onUpdateComments(
    UpdateComments event,
    Emitter<CommentState> emit,
  ) {
    emit(
      state.copyWith(
        status: CommentStatus.success,
        comments: event.comments,
      ),
    );
  }

  Future<void> _onAddComment(
    AddComment event,
    Emitter<CommentState> emit,
  ) async {
    try {
      await _commentRepository.addComment(event.comment);
    } catch (e) {
      emit(
        state.copyWith(
          status: CommentStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onDeleteComment(
    DeleteComment event,
    Emitter<CommentState> emit,
  ) async {
    try {
      await _commentRepository.deleteComment(event.comment);
    } catch (e) {
      emit(
        state.copyWith(
          status: CommentStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
