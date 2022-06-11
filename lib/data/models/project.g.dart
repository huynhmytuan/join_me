// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Project _$ProjectFromJson(Map<String, dynamic> json) => Project(
      id: json['id'] as String,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      owner: json['owner'] as String,
      description: json['description'] as String,
      members: (json['members'] as List<dynamic>)
          .map((dynamic e) => e as String)
          .toList(),
      categories: (json['categories'] as List<dynamic>)
          .map((dynamic e) => e as String)
          .toList(),
      requests: (json['requests'] as List<dynamic>)
          .map((dynamic e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ProjectToJson(Project instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'createdAt': instance.createdAt.toIso8601String(),
      'owner': instance.owner,
      'description': instance.description,
      'members': instance.members,
      'categories': instance.categories,
      'requests': instance.requests,
    };
