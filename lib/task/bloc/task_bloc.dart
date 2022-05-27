import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:join_me/data/models/models.dart';
import 'package:join_me/data/repositories/repositories.dart';
part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc({
    required TaskRepository taskRepository,
    required UserRepository userRepository,
    required ProjectRepository projectRepository,
  })  : _taskRepository = taskRepository,
        _userRepository = userRepository,
        _projectRepository = projectRepository,
        super(
          TaskState(
            task: Task.empty(),
            project: Project.empty(),
          ),
        ) {
    on<LoadTask>(_onLoadTask);
    on<UpdateTask>(_onUpdateTask);
    on<EditTask>(_onEditTask);
    on<AddSubTask>(_onAddSubTask);
    on<DeleteTask>(_onDeleteTask);
  }
  final TaskRepository _taskRepository;
  final UserRepository _userRepository;
  final ProjectRepository _projectRepository;
  StreamSubscription<Task>? _taskSubscription;

  Future<void> _onLoadTask(
    LoadTask event,
    Emitter<TaskState> emit,
  ) async {
    emit(state.copyWith(status: TaskStateStatus.loading));
    try {
      await _taskSubscription?.cancel();
      _taskSubscription =
          _taskRepository.getTaskById(event.taskId).listen((task) {
        add(UpdateTask(task));
      });
    } catch (e) {
      emit(
        state.copyWith(
          status: TaskStateStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onUpdateTask(
    UpdateTask event,
    Emitter<TaskState> emit,
  ) async {
    try {
      final assignee = event.task.assignee.isEmpty
          ? <AppUser>[]
          : await _userRepository.getUsers(userIds: event.task.assignee);
      final parent = event.task.subTaskOf.isNotEmpty
          ? await _taskRepository.getTaskById(event.task.subTaskOf).first
          : null;
      final subTasks = event.task.subTasks.isEmpty
          ? <Task>[]
          : await _taskRepository.getSubTask(taskIds: event.task.subTasks);

      final project = event.task.projectId != state.project.id
          ? await _projectRepository.getProjectById(event.task.projectId).first
          : null;
      final createdBy = event.task.createdBy != state.createdBy.id
          ? await _userRepository.getUserById(userId: event.task.createdBy)
          : null;
      emit(
        state.copyWith(
          task: event.task,
          project: project,
          assignee: assignee,
          subTasks: subTasks,
          parent: parent,
          createdBy: createdBy,
          status: TaskStateStatus.success,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: TaskStateStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onEditTask(
    EditTask event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await _taskRepository.updateTask(task: event.task);
    } catch (e) {
      emit(
        state.copyWith(
          status: TaskStateStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onDeleteTask(
    DeleteTask event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await _taskRepository.deleteTask(task: event.task);
    } catch (e) {
      emit(
        state.copyWith(
          status: TaskStateStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onAddSubTask(
    AddSubTask event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await _taskRepository.addSubTask(parent: state.task, subTask: event.task);
    } catch (e) {
      emit(
        state.copyWith(
          status: TaskStateStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
