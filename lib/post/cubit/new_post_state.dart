part of 'new_post_cubit.dart';

class NewPostState extends Equatable {
  const NewPostState({
    this.content = '',
    this.medias = const [],
    required this.invitedProject,
  });

  final String content;
  final List<AssetEntity> medias;
  final Project invitedProject;

  NewPostState copyWith({
    String? content,
    List<AssetEntity>? medias,
    Project? invitedProject,
  }) {
    return NewPostState(
      content: content ?? this.content,
      medias: medias ?? this.medias,
      invitedProject: invitedProject ?? this.invitedProject,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [content, medias, invitedProject];
}
