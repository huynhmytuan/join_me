// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
      projectId: json['projectIid'] as String,
      name: json['name'] as String,
      createdBy: json['createdBy'] as String,
      description: json['description'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      dueDate: DateTime.parse(json['dueDate'] as String),
      type: $enumDecode(_$TaskTypeEnumMap, json['type']),
      status: $enumDecode(_$TaskStatusEnumMap, json['status']),
      priority: $enumDecode(_$TaskPriorityEnumMap, json['priority']),
      assignTo: (json['assignTo'] as List<dynamic>)
          .map((dynamic e) => e as String)
          .toList(),
      subTasks: (json['subTasks'] as List<dynamic>)
          .map((dynamic e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'projectIid': instance.projectId,
      'name': instance.name,
      'createdBy': instance.createdBy,
      'description': instance.description,
      'createdAt': instance.createdAt.toIso8601String(),
      'dueDate': instance.dueDate.toIso8601String(),
      'type': _$TaskTypeEnumMap[instance.type],
      'status': _$TaskStatusEnumMap[instance.status],
      'priority': _$TaskPriorityEnumMap[instance.priority],
      'assignTo': instance.assignTo,
      'subTasks': instance.subTasks,
    };

const _$TaskTypeEnumMap = {
  TaskType.task: 'task',
  TaskType.subTask: 'sub-task',
  TaskType.unknown: 'unknown',
};

const _$TaskStatusEnumMap = {
  TaskStatus.toTo: 'to-do',
  TaskStatus.inProcess: 'in-process',
  TaskStatus.complete: 'complete',
  TaskStatus.unknown: 'unknown',
};

const _$TaskPriorityEnumMap = {
  TaskPriority.none: 'none',
  TaskPriority.high: 'high',
  TaskPriority.medium: 'medium',
  TaskPriority.low: 'low',
  TaskPriority.unknown: 'unknown',
};
