part of 'project_bloc.dart';

enum ProjectStatus {
  initial,
  loading,
  success,
  failure,
  deleted,
}

class ProjectState extends Equatable {
  const ProjectState({
    required this.project,
    required this.members,
    required this.owner,
    this.status = ProjectStatus.initial,
    this.errorMessage,
  });

  final Project project;
  final List<AppUser> members;
  final AppUser owner;
  final ProjectStatus status;
  final String? errorMessage;

  @override
  List<Object> get props => [project, members, owner, status];
  ProjectState copyWith({
    Project? project,
    List<AppUser>? members,
    AppUser? owner,
    ProjectStatus? status,
    String? errorMessage,
  }) {
    return ProjectState(
      project: project ?? this.project,
      members: members ?? this.members,
      owner: owner ?? this.owner,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
