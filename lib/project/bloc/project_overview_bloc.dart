import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:join_me/data/models/models.dart';
import 'package:join_me/data/repositories/project_repository.dart';
import 'package:join_me/data/repositories/task_repository.dart';
import 'package:join_me/data/repositories/user_repository.dart';

part 'project_overview_event.dart';
part 'project_overview_state.dart';

class ProjectOverviewBloc extends Bloc<ProjectEvent, ProjectOverviewState> {
  ProjectOverviewBloc({
    required ProjectRepository projectRepository,
    required TaskRepository taskRepository,
    required UserRepository userRepository,
  })  : _projectRepository = projectRepository,
        _taskRepository = taskRepository,
        _userRepository = userRepository,
        super(ProjectsInitial()) {
    on<LoadProjects>(_onLoadProjects);
    on<UpdateProjects>(_onUpdateProjects);
    on<AddProject>(_onAddProject);
    on<AddUserToProject>(_onAddUserToProject);
  }
  final ProjectRepository _projectRepository;
  final TaskRepository _taskRepository;
  final UserRepository _userRepository;
  StreamSubscription<List<Project>>? _projectsSubscription;
  Future<void> _onLoadProjects(
    LoadProjects event,
    Emitter<ProjectOverviewState> emit,
  ) async {
    emit(ProjectsLoading());
    try {
      await _projectsSubscription?.cancel();
      _projectsSubscription = _projectRepository
          .getUserProjects(event.userId)
          .listen((projects) async {
        final listProjects = <ProjectViewModel>[];
        for (final project in projects) {
          try {
            final tasks =
                await _taskRepository.getListProjectTasks(project.id).first;

            final members =
                await _userRepository.getUsers(userIds: project.members);
            listProjects.add(ProjectViewModel(project, tasks, members));
          } catch (e) {
            log(e.toString());
          }
        }
        add(UpdateProjects(listProjects));
      });
    } catch (e) {
      rethrow;
    }
  }

  void _onUpdateProjects(
    UpdateProjects event,
    Emitter<ProjectOverviewState> emit,
  ) {
    emit(ProjectsLoaded(projects: event.projects));
  }

  Future<void> _onAddProject(
    AddProject event,
    Emitter<ProjectOverviewState> emit,
  ) async {
    try {
      final newProject =
          await _projectRepository.addProject(project: event.project);
      emit(NewProjectCreated(project: newProject));
      emit(const ProjectsLoaded());
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _onAddUserToProject(
    AddUserToProject event,
    Emitter<ProjectOverviewState> emit,
  ) async {
    try {
      await _projectRepository.addUserToProject(
        project: event.project,
        userId: event.userId,
      );
    } catch (e) {
      log(e.toString());
    }
  }
}
