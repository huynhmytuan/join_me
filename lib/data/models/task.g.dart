// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
      id: json['id'] as String,
      projectId: json['projectId'] as String,
      subTaskOf: json['subTaskOf'] as String,
      name: json['name'] as String,
      createdBy: json['createdBy'] as String,
      description: json['description'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String),
      type: $enumDecode(_$TaskTypeEnumMap, json['type']),
      category: json['category'] as String,
      isComplete: json['isComplete'] as bool,
      priority: $enumDecode(_$TaskPriorityEnumMap, json['priority']),
      assignee: (json['assignee'] as List<dynamic>)
          .map((dynamic e) => e as String)
          .toList(),
      subTasks: (json['subTasks'] as List<dynamic>)
          .map((dynamic e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'id': instance.id,
      'projectId': instance.projectId,
      'subTaskOf': instance.subTaskOf,
      'name': instance.name,
      'createdBy': instance.createdBy,
      'description': instance.description,
      'createdAt': instance.createdAt.toIso8601String(),
      'dueDate': instance.dueDate?.toIso8601String(),
      'type': _$TaskTypeEnumMap[instance.type],
      'category': instance.category,
      'isComplete': instance.isComplete,
      'priority': _$TaskPriorityEnumMap[instance.priority],
      'assignee': instance.assignee,
      'subTasks': instance.subTasks,
    };

const _$TaskTypeEnumMap = {
  TaskType.task: 'task',
  TaskType.subTask: 'sub-task',
  TaskType.unknown: 'unknown',
};

const _$TaskPriorityEnumMap = {
  TaskPriority.none: 'none',
  TaskPriority.high: 'high',
  TaskPriority.medium: 'medium',
  TaskPriority.low: 'low',
  TaskPriority.unknown: 'unknown',
};
