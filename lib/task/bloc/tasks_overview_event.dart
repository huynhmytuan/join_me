part of 'tasks_overview_bloc.dart';

abstract class TasksOverviewEvent extends Equatable {
  const TasksOverviewEvent();

  @override
  List<Object> get props => [];
}

class LoadTasksList extends TasksOverviewEvent {
  const LoadTasksList(this.projectId);

  final String projectId;
  @override
  List<Object> get props => [projectId];
}

class UpdateTasksList extends TasksOverviewEvent {
  const UpdateTasksList(this.tasks);

  final List<TaskViewModel> tasks;
  @override
  List<Object> get props => [tasks];
}

class AddNewTask extends TasksOverviewEvent {
  const AddNewTask(this.newTask);

  final Task newTask;
  @override
  List<Object> get props => [newTask];
}

class ToggleTaskStatus extends TasksOverviewEvent {
  const ToggleTaskStatus(this.task);

  final Task task;
  @override
  List<Object> get props => [task];
}
