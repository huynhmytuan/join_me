import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:join_me/app/cubit/app_message_cubit.dart';
import 'package:join_me/data/models/models.dart';

import 'package:join_me/data/repositories/repositories.dart';

part 'project_event.dart';
part 'project_state.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  ProjectBloc({
    required ProjectRepository projectRepository,
    required UserRepository userRepository,
    required AppMessageCubit appMessageCubit,
  })  : _projectRepository = projectRepository,
        _userRepository = userRepository,
        _appMessageCubit = appMessageCubit,
        super(
          ProjectState(
            project: Project.empty(),
            members: const [],
            owner: AppUser.empty,
          ),
        ) {
    on<LoadProject>(_onLoadProject);
    on<UpdateProject>(_onUpdateProject);
    on<EditProject>(_onEditProject);
    on<DeleteProject>(_onDeleteProject);
    on<AddJoinRequest>(_onAddJoinRequest);
  }
  final ProjectRepository _projectRepository;
  final UserRepository _userRepository;
  StreamSubscription<Project?>? _projectSubscription;
  final AppMessageCubit _appMessageCubit;
  void _onLoadProject(
    LoadProject event,
    Emitter<ProjectState> emit,
  ) {
    emit(state.copyWith(status: ProjectStatus.loading));
    try {
      _projectSubscription?.cancel();
      _projectSubscription =
          _projectRepository.getProjectById(event.projectId).listen((project) {
        add(UpdateProject(project));
      });
    } catch (e) {
      emit(
        state.copyWith(
          status: ProjectStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onUpdateProject(
    UpdateProject event,
    Emitter<ProjectState> emit,
  ) async {
    try {
      final members = event.project != null
          ? await _userRepository.getUsers(userIds: event.project!.members)
          : null;
      final leader = event.project != null
          ? members!.firstWhere((user) => user.id == event.project!.owner)
          : null;
      emit(
        state.copyWith(
          project: event.project,
          members: members,
          owner: leader,
          status: ProjectStatus.success,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ProjectStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onEditProject(
    EditProject event,
    Emitter<ProjectState> emit,
  ) async {
    try {
      await _projectRepository.updateProject(project: event.project);
    } catch (e) {
      emit(
        state.copyWith(
          status: ProjectStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onDeleteProject(
    DeleteProject event,
    Emitter<ProjectState> emit,
  ) async {
    try {
      await _projectRepository.deleteProject(project: event.project);
      emit(
        state.copyWith(
          status: ProjectStatus.deleted,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ProjectStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onAddJoinRequest(
    AddJoinRequest event,
    Emitter<ProjectState> emit,
  ) async {
    await _projectRepository.addJoinRequest(
      project: event.project,
      requester: event.userId,
    );
    _appMessageCubit.showInfoSnackbar(message: 'Your request has been sent');
  }
}
