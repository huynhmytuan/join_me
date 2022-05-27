part of 'task_bloc.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class LoadTask extends TaskEvent {
  const LoadTask(this.taskId);

  final String taskId;
  @override
  List<Object> get props => [taskId];
}

class UpdateTask extends TaskEvent {
  const UpdateTask(this.task);

  final Task task;
  @override
  List<Object> get props => [task];
}

class EditTask extends TaskEvent {
  const EditTask(this.task);

  final Task task;
  @override
  List<Object> get props => [task];
}

class AddSubTask extends TaskEvent {
  const AddSubTask(this.task);

  final Task task;
  @override
  List<Object> get props => [task];
}

class DeleteTask extends TaskEvent {
  const DeleteTask(this.task);

  final Task task;
  @override
  List<Object> get props => [task];
}
