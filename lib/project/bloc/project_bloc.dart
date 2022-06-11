import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:join_me/app/cubit/app_message_cubit.dart';
import 'package:join_me/data/models/models.dart';

import 'package:join_me/data/repositories/repositories.dart';
import 'package:join_me/generated/locale_keys.g.dart';

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
    on<AddUserToProject>(_onAddUserToProject);
    on<RemoveUserFromProject>(_onRemoveUserFromProject);
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
      log(e.toString(), name: 'POST/ON_LOAD');
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
      //Check conflict on member an requests
      if (event.project != null) {
        for (final requester in event.project!.requests) {
          if (event.project!.members.contains(requester)) {
            await _projectRepository.deleteJoinRequest(
              projectId: event.project!.id,
              requesterId: requester,
            );
          }
        }
      }
      log('Project: ${event.project}', name: 'POST/PRO');
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
      log(e.toString(), name: 'POST/ON_UPDATE');
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
      log(e.toString(), name: 'POST/ON_EDIT');
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
      log(e.toString(), name: 'POST/ON_DELETE');
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
    _appMessageCubit.showInfoSnackbar(
      message: LocaleKeys.notice_sentRequest.tr(),
    );
  }

  Future<void> _onAddUserToProject(
    AddUserToProject event,
    Emitter<ProjectState> emit,
  ) async {
    try {
      await _projectRepository.addUserToProject(
        project: state.project,
        userId: event.userId,
      );
      _appMessageCubit.showInfoSnackbar(
        message: LocaleKeys.notice_userAdded.tr(),
      );
    } catch (e) {
      log(e.toString(), name: 'PROJECT_BLOC/ADD_USER');
    }
  }

  Future<void> _onRemoveUserFromProject(
    RemoveUserFromProject event,
    Emitter<ProjectState> emit,
  ) async {
    try {
      await _projectRepository.removeUserToProject(
        project: state.project,
        userId: event.userId,
      );
    } catch (e) {
      log(e.toString(), name: 'PROJECT_BLOC/ADD_USER');
    }
  }
}
