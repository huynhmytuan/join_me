import 'package:equatable/equatable.dart';
import 'package:join_me/utilities/keys/task_keys.dart';
import 'package:json_annotation/json_annotation.dart';

part 'task.g.dart';

enum TaskType {
  @JsonValue('task')
  task,
  @JsonValue('sub-task')
  subTask,
  unknown,
}

enum TaskStatus {
  @JsonValue('to-do')
  toTo,
  @JsonValue('in-process')
  inProcess,
  complete,
  unknown,
}

enum TaskPriority {
  none,
  high,
  medium,
  low,
  unknown,
}

@JsonSerializable()
class Task extends Equatable {
  const Task({
    required this.projectId,
    required this.name,
    required this.createdBy,
    required this.description,
    required this.createdAt,
    required this.dueDate,
    required this.type,
    required this.status,
    required this.priority,
    required this.assignTo,
    required this.subTasks,
  });

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  Map<String, dynamic> toJson() => _$TaskToJson(this);

  @JsonKey(name: TaskKeys.projectIid)
  final String projectId;
  @JsonKey(name: TaskKeys.name)
  final String name;
  @JsonKey(name: TaskKeys.createdBy)
  final String createdBy;
  @JsonKey(name: TaskKeys.description)
  final String description;
  @JsonKey(name: TaskKeys.createdAt)
  final DateTime createdAt;
  @JsonKey(name: TaskKeys.dueDate)
  final DateTime dueDate;
  @JsonKey(name: TaskKeys.type)
  final TaskType type;
  @JsonKey(name: TaskKeys.status)
  final TaskStatus status;
  @JsonKey(name: TaskKeys.priority)
  final TaskPriority priority;
  @JsonKey(name: TaskKeys.assignTo)
  final List<String> assignTo;
  @JsonKey(name: TaskKeys.subTasks)
  final List<String> subTasks;

  Task copyWith({
    String? projectId,
    String? name,
    String? createdBy,
    String? description,
    DateTime? createdAt,
    DateTime? dueDate,
    TaskType? type,
    TaskStatus? status,
    TaskPriority? priority,
    List<String>? assignTo,
    List<String>? subTasks,
  }) {
    return Task(
      projectId: projectId ?? this.projectId,
      name: name ?? this.name,
      createdBy: createdBy ?? this.createdBy,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      type: type ?? this.type,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      assignTo: assignTo ?? this.assignTo,
      subTasks: subTasks ?? this.subTasks,
    );
  }

  @override
  bool get stringify => true;
  @override
  List<Object> get props {
    return [
      projectId,
      name,
      createdBy,
      description,
      createdAt,
      dueDate,
      type,
      status,
      priority,
      assignTo,
      subTasks,
    ];
  }
}
