part of 'project_overview_bloc.dart';

abstract class ProjectEvent extends Equatable {
  const ProjectEvent();

  @override
  List<Object> get props => [];
}

class LoadProjects extends ProjectEvent {
  const LoadProjects({required this.userId});

  final String userId;

  @override
  List<Object> get props => [userId];
}

class UpdateProjects extends ProjectEvent {
  const UpdateProjects(this.projects);

  final List<ProjectViewModel> projects;
  @override
  List<Object> get props => [projects];
}

class AddProject extends ProjectEvent {
  const AddProject(this.project);

  final Project project;

  @override
  List<Object> get props => [project];
}
