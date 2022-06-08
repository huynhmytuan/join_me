part of 'join_requests_bloc.dart';

enum JoinRequestsStatus { initial, loading, success, failure }

class JoinRequestsState extends Equatable {
  const JoinRequestsState({
    required this.project,
    required this.requesters,
    required this.status,
  });
  factory JoinRequestsState.initial() => JoinRequestsState(
        project: Project.empty(),
        requesters: const [],
        status: JoinRequestsStatus.initial,
      );
  final Project project;
  final List<AppUser> requesters;
  final JoinRequestsStatus status;

  @override
  List<Object> get props => [project, requesters];
  JoinRequestsState copyWith({
    Project? project,
    List<AppUser>? requesters,
    JoinRequestsStatus? status,
  }) {
    return JoinRequestsState(
      project: project ?? this.project,
      requesters: requesters ?? this.requesters,
      status: status ?? this.status,
    );
  }
}
