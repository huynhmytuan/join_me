import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:join_me/data/models/app_user.dart';
import 'package:join_me/data/models/post.dart';
import 'package:join_me/data/models/project.dart';
import 'package:join_me/data/repositories/post_repository.dart';
import 'package:photo_manager/photo_manager.dart';

part 'new_post_state.dart';

class NewPostCubit extends Cubit<NewPostState> {
  NewPostCubit({
    required PostRepository postRepository,
    required AppUser author,
  })  : _postRepository = postRepository,
        _author = author,
        super(NewPostState(invitedProject: Project.empty()));
  final PostRepository _postRepository;
  final AppUser _author;

  void contentChange(String value) {
    emit(state.copyWith(content: value));
  }

  void postMediasChange({required List<AssetEntity> medias}) {
    emit(state.copyWith(medias: medias));
  }

  void mediaRemove({required AssetEntity media}) {
    final medias = List<AssetEntity>.from(state.medias)..remove(media);
    emit(
      state.copyWith(
        medias: medias,
      ),
    );
  }

  void addInvitation({required Project project}) {
    emit(state.copyWith(invitedProject: project));
  }

  void removeInvitation() {
    emit(state.copyWith(invitedProject: Project.empty()));
  }

  Future<void> submitPost() async {
    await _postRepository.addPost(
      post: Post(
        id: '',
        type: state.invitedProject.id.isEmpty
            ? PostType.normal
            : PostType.invitation,
        authorId: _author.id,
        createdAt: DateTime.now(),
        content: state.content,
        medias: const [],
        projectInvitationId:
            state.invitedProject.id.isEmpty ? '' : state.invitedProject.id,
        likes: const [],
        commentCount: 0,
      ),
      medias: state.medias,
    );
  }
}
