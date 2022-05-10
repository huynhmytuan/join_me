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
    required this.id,
    required this.projectId,
    required this.name,
    required this.createdBy,
    required this.description,
    required this.createdAt,
    required this.dueDate,
    required this.type,
    required this.category,
    required this.isComplete,
    required this.priority,
    required this.assignTo,
    required this.subTasks,
  });

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  Map<String, dynamic> toJson() => _$TaskToJson(this);

  @JsonKey(name: TaskKeys.id)
  final String id;
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
  @JsonKey(name: TaskKeys.category)
  final String category;
  @JsonKey(name: TaskKeys.isComplete)
  final bool isComplete;
  @JsonKey(name: TaskKeys.priority)
  final TaskPriority priority;
  @JsonKey(name: TaskKeys.assignTo)
  final List<String> assignTo;
  @JsonKey(name: TaskKeys.subTasks)
  final List<String> subTasks;

  Task copyWith({
    String? id,
    String? projectId,
    String? name,
    String? createdBy,
    String? description,
    DateTime? createdAt,
    DateTime? dueDate,
    TaskType? type,
    String? category,
    bool? isComplete,
    TaskPriority? priority,
    List<String>? assignTo,
    List<String>? subTasks,
  }) {
    return Task(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      name: name ?? this.name,
      createdBy: createdBy ?? this.createdBy,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      type: type ?? this.type,
      category: category ?? this.category,
      isComplete: isComplete ?? this.isComplete,
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
      category,
      isComplete,
      priority,
      assignTo,
      subTasks,
    ];
  }
}
