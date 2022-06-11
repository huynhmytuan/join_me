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
    on<UpdateSubtask>(_onUpdateSubtask);
    on<TaskNotFound>(_onTaskNotFound);
    on<TaskDeleted>(_onTaskDeleted);
  }
  final TaskRepository _taskRepository;
  final UserRepository _userRepository;
  final ProjectRepository _projectRepository;
  StreamSubscription<Task?>? _taskSubscription;
  StreamSubscription<List<Task>>? _subTaskSubscription;

  Future<void> _onLoadTask(
    LoadTask event,
    Emitter<TaskState> emit,
  ) async {
    emit(state.copyWith(status: TaskStateStatus.loading));
    try {
      await _taskSubscription?.cancel();

      _taskSubscription =
          _taskRepository.getTaskById(event.taskId).listen((task) {
        if (task != null) {
          add(UpdateTask(task));
        } else {
          add(TaskNotFound());
        }
      });
      //Get Subtask List
      await _subTaskSubscription?.cancel();
      _subTaskSubscription =
          _taskRepository.getSubTasks(parentId: event.taskId).listen((tasks) {
        add(UpdateSubtask(tasks));
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
      final project = event.task.projectId != state.project.id
          ? await _projectRepository.getProjectById(event.task.projectId).first
          : null;
      final createdBy = event.task.createdBy != state.createdBy.id
          ? await _userRepository
              .getUserById(userId: event.task.createdBy)
              .first
          : null;
      emit(
        state.copyWith(
          task: event.task,
          project: project,
          assignee: assignee,
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

  void _onUpdateSubtask(
    UpdateSubtask event,
    Emitter<TaskState> emit,
  ) {
    emit(
      state.copyWith(
        subTasks: event.subTasks,
      ),
    );
  }

  Future<void> _onEditTask(
    EditTask event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await _taskRepository.updateTask(
        task: event.task,
        currentUser: event.currentUserId,
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

  Future<void> _onDeleteTask(
    DeleteTask event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await _taskRepository.deleteTask(task: event.task);
      add(TaskDeleted());
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
      emit(
        state.copyWith(
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

  void _onTaskDeleted(
    TaskDeleted event,
    Emitter<TaskState> emit,
  ) {
    close();
    _subTaskSubscription?.cancel();
    _taskSubscription?.cancel();
  }

  void _onTaskNotFound(
    TaskNotFound event,
    Emitter<TaskState> emit,
  ) {
    emit(state.copyWith(status: TaskStateStatus.notFound));
    _subTaskSubscription?.cancel();
    _subTaskSubscription?.cancel();
  }
}
