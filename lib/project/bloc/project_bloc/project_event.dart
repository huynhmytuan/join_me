part of 'project_bloc.dart';

abstract class ProjectEvent extends Equatable {
  const ProjectEvent();

  @override
  List<Object> get props => [];
}

class LoadProject extends ProjectEvent {
  const LoadProject(this.projectId);

  final String projectId;
  @override
  List<Object> get props => [projectId];
}

class UpdateProject extends ProjectEvent {
  const UpdateProject(this.project);

  final Project project;
  @override
  List<Object> get props => [project];
}

class EditProject extends ProjectEvent {
  const EditProject(this.project);

  final Project project;
  @override
  List<Object> get props => [project];
}

class DeleteProject extends ProjectEvent {
  const DeleteProject(this.project);

  final Project project;
  @override
  List<Object> get props => [project];
}
