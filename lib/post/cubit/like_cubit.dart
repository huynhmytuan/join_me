import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:join_me/data/models/models.dart';
import 'package:join_me/data/repositories/comment_repository.dart';
import 'package:join_me/data/repositories/post_repository.dart';

part 'like_state.dart';

enum LikeType { post, comment }

class LikeCubit extends Cubit<LikeState> {
  LikeCubit({
    required PostRepository postRepository,
    required CommentRepository commentRepository,
  })  : _postRepository = postRepository,
        _commentRepository = commentRepository,
        super(LikeCubitDartInitial());

  final PostRepository _postRepository;
  final CommentRepository _commentRepository;

  Future<void> likeUnlikePost({
    Post? post,
    Comment? comment,
    required String userId,
    required LikeType likeType,
  }) async {
    if (likeType == LikeType.post) {
      await _postRepository.likeUnLikePost(post: post!, userId: userId);
    } else {
      await _commentRepository.likeUnlikeComment(
        comment: comment!,
        userId: userId,
      );
    }
  }
}
