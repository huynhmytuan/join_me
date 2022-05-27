part of 'tasks_overview_bloc.dart';

abstract class TasksOverviewState extends Equatable {
  const TasksOverviewState();

  @override
  List<Object> get props => [];
}

class TasksOverviewInitial extends TasksOverviewState {}

class TasksOverviewLoading extends TasksOverviewState {}

class TasksOverviewLoadSuccess extends TasksOverviewState {
  const TasksOverviewLoadSuccess(this.tasks);

  final List<TaskViewModel> tasks;

  @override
  List<Object> get props => [tasks];
}

class TasksOverviewLoadFailure extends TasksOverviewState {}

class TaskViewModel {
  TaskViewModel({
    required this.task,
    required this.assignee,
  });

  final Task task;
  final List<AppUser> assignee;
}
