import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:join_me/data/models/models.dart';
import 'package:join_me/data/repositories/repositories.dart';

part 'tasks_overview_event.dart';
part 'tasks_overview_state.dart';

class TasksOverviewBloc extends Bloc<TasksOverviewEvent, TasksOverviewState> {
  TasksOverviewBloc({
    required TaskRepository taskRepository,
    required UserRepository userRepository,
  })  : _taskRepository = taskRepository,
        _userRepository = userRepository,
        super(TasksOverviewInitial()) {
    on<LoadTasksList>(_onLoadTasksList);
    on<UpdateTasksList>(_onUpdateTasksList);
    on<AddNewTask>(_onAddNewTask);
    on<ToggleTaskStatus>(_onToggleTaskStatus);
  }

  final TaskRepository _taskRepository;
  final UserRepository _userRepository;
  StreamSubscription? _streamSubscription;

  Future<void> _onLoadTasksList(
    LoadTasksList event,
    Emitter<TasksOverviewState> emit,
  ) async {
    try {
      await _streamSubscription?.cancel();
      _streamSubscription = _taskRepository
          .getListProjectTasks(event.projectId)
          .listen((tasks) async {
        final listTasks = <TaskViewModel>[];
        for (final task in tasks) {
          final assignee =
              await _userRepository.getUsers(userIds: task.assignee);
          listTasks.add(TaskViewModel(task: task, assignee: assignee));
        }
        add(UpdateTasksList(listTasks));
      });
    } catch (e) {
      log(e.toString());
    }
  }

  void _onUpdateTasksList(
    UpdateTasksList event,
    Emitter<TasksOverviewState> emit,
  ) {
    emit(TasksOverviewLoadSuccess(event.tasks));
  }

  void _onAddNewTask(
    AddNewTask event,
    Emitter<TasksOverviewState> emit,
  ) {
    try {
      _taskRepository.addTask(event.newTask, event.currentUserId);
    } catch (e, stackTrace) {
      log(e.toString(), stackTrace: stackTrace);
    }
  }

  void _onToggleTaskStatus(
    ToggleTaskStatus event,
    Emitter<TasksOverviewState> emit,
  ) {
    try {
      _taskRepository.updateTask(
        task: event.task,
        currentUser: event.currentUserId,
      );
    } catch (e, stackTrace) {
      log(e.toString(), stackTrace: stackTrace);
    }
  }
}
