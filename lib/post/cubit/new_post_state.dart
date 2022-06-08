part of 'new_post_cubit.dart';

enum NewPostStatus {
  initial,
  newPostUpload,
}

class NewPostState extends Equatable {
  const NewPostState({
    this.content = '',
    this.medias = const [],
    this.status = NewPostStatus.initial,
    required this.invitedProject,
  });

  final String content;
  final List<AssetEntity> medias;
  final Project invitedProject;
  final NewPostStatus status;

  NewPostState copyWith({
    String? content,
    List<AssetEntity>? medias,
    Project? invitedProject,
    NewPostStatus? status,
  }) {
    return NewPostState(
      content: content ?? this.content,
      medias: medias ?? this.medias,
      invitedProject: invitedProject ?? this.invitedProject,
      status: status ?? this.status,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [content, medias, invitedProject, status];
}
