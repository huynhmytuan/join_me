part of 'task_bloc.dart';

enum TaskStateStatus {
  initial,
  loading,
  success,
  failure,
  deleted,
  notFound,
}

class TaskState extends Equatable {
  const TaskState({
    required this.task,
    required this.project,
    this.status = TaskStateStatus.initial,
    this.assignee = const [],
    this.subTasks = const [],
    this.createdBy = AppUser.empty,
    this.parent,
    this.errorMessage,
  });

  final Task task;
  final TaskStateStatus status;
  final List<AppUser> assignee;
  final List<Task> subTasks;
  final AppUser createdBy;
  final Project project;
  final Task? parent;
  final String? errorMessage;

  @override
  List<Object?> get props => [
        task,
        status,
        assignee,
        subTasks,
        project,
        createdBy,
      ];
  TaskState copyWith({
    Task? task,
    TaskStateStatus? status,
    List<AppUser>? assignee,
    AppUser? createdBy,
    Project? project,
    List<Task>? subTasks,
    Task? parent,
    String? errorMessage,
  }) {
    return TaskState(
      task: task ?? this.task,
      parent: parent ?? this.parent,
      status: status ?? this.status,
      project: project ?? this.project,
      createdBy: createdBy ?? this.createdBy,
      assignee: assignee ?? this.assignee,
      subTasks: subTasks ?? this.subTasks,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
