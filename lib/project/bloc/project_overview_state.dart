part of 'project_overview_bloc.dart';

abstract class ProjectOverviewState extends Equatable {
  const ProjectOverviewState();

  @override
  List<Object> get props => [];
}

class ProjectsInitial extends ProjectOverviewState {}

class ProjectsLoading extends ProjectOverviewState {}

class ProjectsLoaded extends ProjectOverviewState {
  const ProjectsLoaded({this.projects = const <ProjectViewModel>[]});

  final List<ProjectViewModel> projects;
  @override
  List<Object> get props => [projects];
}

class NewProjectCreated extends ProjectOverviewState {
  const NewProjectCreated({required this.project});

  final Project project;
  @override
  List<Object> get props => [project];
}

///View Model Class to store project data fo preview in list UI.
class ProjectViewModel {
  const ProjectViewModel(this.project, this.tasks, this.members);

  final Project project;
  final List<Task?> tasks;
  final List<AppUser> members;
}
