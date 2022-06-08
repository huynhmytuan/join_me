import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:join_me/app/cubit/app_message_cubit.dart';
import 'package:join_me/data/models/models.dart';

import 'package:join_me/data/repositories/repositories.dart';

import 'package:join_me/post/view_model/post_view_model.dart';
import 'package:stream_transform/stream_transform.dart';

part 'posts_event.dart';
part 'posts_state.dart';

const _paginationSize = 20;
const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  PostsBloc({
    required UserRepository userRepository,
    required PostRepository postRepository,
    required ProjectRepository projectRepository,
    required AppMessageCubit appMessageCubit,
  })  : _userRepository = userRepository,
        _postRepository = postRepository,
        _projectRepository = projectRepository,
        _appMessageCubit = appMessageCubit,
        super(PostsState.initial()) {
    on<FetchPosts>(_onFetchPosts);
    on<LoadMorePosts>(
      _onLoadMorePost,
      transformer: throttleDroppable(throttleDuration),
    );
    on<PostsPageUpdates>(_onPostsPageUpdates);
    on<DeletePost>(_onDeletePost);
  }
  final UserRepository _userRepository;
  final PostRepository _postRepository;
  final ProjectRepository _projectRepository;
  final List<StreamSubscription?> _postsSubscriptions = [];
  final AppMessageCubit _appMessageCubit;

  @override
  Future<void> close() async {
    _postsSubscriptions.map((subscription) => subscription?.cancel());
    return super.close();
  }

  Future<void> _onFetchPosts(
    FetchPosts event,
    Emitter<PostsState> emit,
  ) async {
    emit(
      state.copyWith(
        postsPages: const [],
        status: PostsStatus.loading,
        hasReachedMax: false,
      ),
    );
    try {
      for (final sub in _postsSubscriptions) {
        await sub?.cancel();
      }
      _postsSubscriptions
        ..clear()
        ..add(
          _postRepository
              .fetchPosts(
            paginationSize: _paginationSize,
            userId: event.userId,
          )
              .listen(
            (page) {
              add(PostsPageUpdates(pageNumber: 0, newPostsPage: page));
            },
          ),
        );
    } catch (e) {
      log('ERROR: ${e.toString()}');
      emit(state.copyWith(status: PostsStatus.failure));
    }
  }

  Future<void> _onLoadMorePost(LoadMorePosts event, Emitter emit) async {
    log('Load more called');
    // if the repository doesn't have more events we do not need to do anything
    if (!state.hasReachedMax) {
      //Prevent scroll when no post
      if (state.posts.isEmpty) {
        return;
      }
      final newPageNumber = state.postsPages.length;
      final lastItem = state.posts.last;

      _postsSubscriptions.add(
        _postRepository
            .fetchPosts(
          paginationSize: _paginationSize,
          lastedPost: lastItem.post,
          userId: event.userId,
        )
            .listen(
          (page) async {
            add(
              PostsPageUpdates(
                pageNumber: newPageNumber,
                newPostsPage: page,
              ),
            );
          },
          onError: (dynamic error) {
            emit(state.copyWith(status: PostsStatus.failure));
          },
        ),
      );
    }
  }

  Future<void> _onPostsPageUpdates(PostsPageUpdates event, Emitter emit) async {
    //retrieve page and page number from the event
    final newPage = <PostViewModel>[];
    for (final post in event.newPostsPage) {
      final postViewModel = await getViewModel(post);
      newPage.add(postViewModel);
    }
    final pageNumber = event.pageNumber;
    //copy the current list of pages and the current hasReachedMax value

    final postsPages = List.of(state.postsPages);
    var hasReachedMax = state.hasReachedMax;
    var reset = false;

    //Case 1: Initial fetch posts
    if (postsPages.length <= pageNumber) {
      log('Case 1');
      postsPages.add(newPage);
      hasReachedMax = newPage.length < _paginationSize;
    }
    //Case 2: Edit at last page
    else if (pageNumber == postsPages.length - 1 && newPage.isNotEmpty) {
      log('Case 2');
      hasReachedMax = newPage.length != _paginationSize;
      postsPages[pageNumber].clear();
      print('hello ${postsPages[pageNumber]}');
      postsPages[pageNumber].addAll(newPage);
      print(postsPages[pageNumber]);
    }
    // Case: update a list page
    else if (newPage.length == postsPages[pageNumber].length &&
        newPage.map((e) => e.post.id).every(
              (e) => postsPages[pageNumber].map((e) => e.post.id).contains(e),
            )) {
      log('Case 3');
      postsPages[pageNumber].clear();
      postsPages[pageNumber].addAll(newPage);
    }
    //else a previous page had insert/delete
    else {
      reset = true;
    }
    // either we reset the list
    if (reset) {
      add(FetchPosts(userId: event.userId));
    } else {
      emit(
        PostsState(
          postsPages: postsPages,
          status: PostsStatus.success,
          hasReachedMax: hasReachedMax,
        ),
      );
    }
  }

  Future<PostViewModel> getViewModel(Post post) async {
    final author =
        await _userRepository.getUserById(userId: post.authorId).first;
    final project = post.projectInvitationId.isNotEmpty
        ? await _projectRepository
            .getProjectById(post.projectInvitationId)
            .first
        : null;

    return PostViewModel(
      author: author,
      post: post,
      project: project,
    );
  }

  Future<void> _onDeletePost(
    DeletePost event,
    Emitter<PostsState> emit,
  ) async {
    try {
      await _postRepository.deletePost(postId: event.postId);
      _appMessageCubit.showInfoSnackbar(message: 'Post Deleted');
    } catch (e) {
      rethrow;
    }
  }
}
