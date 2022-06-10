import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:join_me/data/models/models.dart';
import 'package:join_me/data/repositories/repositories.dart';

part 'join_requests_event.dart';
part 'join_requests_state.dart';

class JoinRequestsBloc extends Bloc<JoinRequestsEvent, JoinRequestsState> {
  JoinRequestsBloc({
    required ProjectRepository projectRepository,
    required UserRepository userRepository,
  })  : _projectRepository = projectRepository,
        _userRepository = userRepository,
        super(JoinRequestsState.initial()) {
    on<LoadRequests>(_onLoadRequests);
    on<AcceptRequest>(_onAcceptRequest);
    on<RejectRequest>(_onRejectRequest);
    on<UpdateRequests>(_onUpdateRequests);
  }

  final ProjectRepository _projectRepository;
  final UserRepository _userRepository;

  Future<void> _onLoadRequests(
    LoadRequests event,
    Emitter<JoinRequestsState> emit,
  ) async {
    emit(state.copyWith(status: JoinRequestsStatus.loading));
    try {
      final project =
          await _projectRepository.getProjectById(event.projectId).first;
      final requesters =
          await _userRepository.getUsers(userIds: project!.requests);
      emit(
        state.copyWith(
          project: project,
          requesters: requesters,
          status: JoinRequestsStatus.success,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: JoinRequestsStatus.failure));
    }
  }

  Future<void> _onAcceptRequest(
    AcceptRequest event,
    Emitter<JoinRequestsState> emit,
  ) async {
    await _projectRepository.acceptJoinRequest(
      projectId: state.project.id,
      requesterId: event.requestId,
    );
    add(UpdateRequests(state.project.id));
  }

  Future<void> _onRejectRequest(
    RejectRequest event,
    Emitter<JoinRequestsState> emit,
  ) async {
    await _projectRepository.deleteJoinRequest(
      projectId: state.project.id,
      requesterId: event.requestId,
    );
    add(UpdateRequests(state.project.id));
  }

  Future<void> _onUpdateRequests(
    UpdateRequests event,
    Emitter<JoinRequestsState> emit,
  ) async {
    add(LoadRequests(event.projectId));
  }
}
