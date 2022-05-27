import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:join_me/data/models/models.dart';
import 'package:join_me/data/repositories/post_repository.dart';
import 'package:join_me/data/repositories/repositories.dart';

part 'posts_event.dart';
part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  PostsBloc({
    required UserRepository userRepository,
    required PostRepository postRepository,
  })  : _userRepository = userRepository,
        _postRepository = postRepository,
        super(const PostsState()) {
    on<PostsEvent>((event, emit) {});
  }
  final UserRepository _userRepository;
  final PostRepository _postRepository;
}
