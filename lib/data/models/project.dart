import 'package:equatable/equatable.dart';

import 'package:join_me/utilities/constant.dart';

import 'package:join_me/utilities/keys/project_keys.dart';
import 'package:json_annotation/json_annotation.dart';

part 'project.g.dart';

enum ProjectViewType {
  @JsonValue('dashboard-view')
  dashBoard,
  @JsonValue('list-view')
  listView,
  @JsonValue('calendar-view')
  calendarView,
  unknown,
}

@JsonSerializable()
class Project extends Equatable {
  const Project({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.owner,
    required this.description,
    required this.members,
    required this.categories,
    required this.viewType,
    required this.requests,
  });

  factory Project.empty({
    String? id,
    String? name,
    DateTime? createdAt,
    String? leader,
    String? description,
    List<String>? members,
    List<String>? categories,
    ProjectViewType? viewType,
    List<String>? requests,
  }) =>
      Project(
        id: id ?? '',
        name: name ?? '',
        createdAt: createdAt ?? DateTime.now(),
        categories: categories ?? kDefaultTaskCategories,
        description: description ?? '',
        owner: leader ?? '',
        members: members ?? [],
        viewType: viewType ?? ProjectViewType.dashBoard,
        requests: requests ?? [],
      );

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectToJson(this);
  Project copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    String? owner,
    ProjectViewType? viewType,
    DateTime? lastChangeAt,
    String? description,
    List<String>? members,
    List<String>? categories,
    List<String>? requests,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      owner: owner ?? this.owner,
      viewType: viewType ?? this.viewType,
      description: description ?? this.description,
      members: members ?? this.members,
      categories: categories ?? this.categories,
      requests: requests ?? this.requests,
    );
  }

  ///Return Project ID
  @JsonKey(name: ProjectKeys.id)
  final String id;

  ///Return Project name
  @JsonKey(name: ProjectKeys.name)
  final String name;

  /// Return time when project created
  @JsonKey(name: ProjectKeys.createdAt)
  final DateTime createdAt;

  ///Return User's ID who created this project (aka Owner)
  @JsonKey(name: ProjectKeys.owner)
  final String owner;

  @JsonKey(name: ProjectKeys.description)
  final String description;

  @JsonKey(name: ProjectKeys.viewType)
  final ProjectViewType viewType;

  ///Return list of members's id (UserID)
  @JsonKey(name: ProjectKeys.members)
  final List<String> members;

  @JsonKey(name: ProjectKeys.categories)
  final List<String> categories;

  @JsonKey(name: ProjectKeys.requests)
  final List<String> requests;

  @override
  bool get stringify => true;
  @override
  List<Object> get props {
    return [
      id,
      name,
      createdAt,
      owner,
      viewType,
      description,
      members,
      categories,
      requests,
    ];
  }
}
