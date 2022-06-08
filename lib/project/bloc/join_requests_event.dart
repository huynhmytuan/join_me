part of 'join_requests_bloc.dart';

abstract class JoinRequestsEvent extends Equatable {
  const JoinRequestsEvent();

  @override
  List<Object> get props => [];
}

class LoadRequests extends JoinRequestsEvent {
  const LoadRequests(this.projectId);

  final String projectId;
  @override
  List<Object> get props => [projectId];
}

class UpdateRequests extends JoinRequestsEvent {
  const UpdateRequests(this.projectId);

  final String projectId;
  @override
  List<Object> get props => [projectId];
}

class AcceptRequest extends JoinRequestsEvent {
  const AcceptRequest(this.requestId);

  final String requestId;
  @override
  List<Object> get props => [requestId];
}

class RejectRequest extends JoinRequestsEvent {
  const RejectRequest(this.requestId);

  final String requestId;
  @override
  List<Object> get props => [requestId];
}
