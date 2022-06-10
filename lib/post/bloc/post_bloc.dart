import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:join_me/data/models/models.dart';

import 'package:join_me/data/repositories/repositories.dart';

import 'package:join_me/post/view_model/post_view_model.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc({
    required UserRepository userRepository,
    required PostRepository postRepository,
    required ProjectRepository projectRepository,
  })  : _userRepository = userRepository,
        _postRepository = postRepository,
        _projectRepository = projectRepository,
        super(PostState.initial()) {
    on<LoadPost>(_onLoadPost);
    on<UpdatePost>(_onUpdatePost);
    on<NoPostFound>(_onNoPostFound);
  }

  final UserRepository _userRepository;
  final PostRepository _postRepository;
  final ProjectRepository _projectRepository;
  StreamSubscription? _postSubscription;

  Future<void> _onLoadPost(
    LoadPost event,
    Emitter<PostState> emit,
  ) async {
    emit(state.copyWith(status: PostStatus.loading));
    await _postSubscription?.cancel();
    _postSubscription =
        _postRepository.getPostById(postId: event.postId).listen((post) {
      if (post == null) {
        add(NoPostFound());
      } else {
        add(UpdatePost(post));
      }
    });
  }

  Future<void> _onUpdatePost(
    UpdatePost event,
    Emitter<PostState> emit,
  ) async {
    try {
      final author =
          await _userRepository.getUserById(userId: event.post.authorId).first;
      final project = event.post.projectInvitationId.isNotEmpty
          ? await _projectRepository
              .getProjectById(event.post.projectInvitationId)
              .first
          : null;
      emit(
        state.copyWith(
          postViewModel: state.postViewModel.copyWith(
            post: event.post,
            author: author,
            project: project,
          ),
          status: PostStatus.success,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: PostStatus.failure));
    }
  }

  void _onNoPostFound(
    NoPostFound event,
    Emitter<PostState> emit,
  ) {
    emit(state.copyWith(status: PostStatus.notFound));
  }

  @override
  Future<void> close() {
    _postSubscription?.cancel();
    return super.close();
  }
}
