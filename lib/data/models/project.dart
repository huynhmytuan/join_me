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
    required this.leader,
    required this.lastChangeAt,
    required this.description,
    required this.members,
    required this.categories,
    required this.viewType,
  });

  factory Project.empty({
    String? id,
    String? name,
    DateTime? createdAt,
    String? leader,
    DateTime? lastChangeAt,
    String? description,
    List<String>? members,
    List<String>? categories,
    ProjectViewType? viewType,
  }) =>
      Project(
        id: id ?? '',
        name: name ?? '',
        createdAt: createdAt ?? DateTime.now(),
        lastChangeAt: lastChangeAt ?? DateTime.now(),
        categories: categories ?? kDefaultTaskCategories,
        description: description ?? '',
        leader: leader ?? '',
        members: members ?? [],
        viewType: viewType ?? ProjectViewType.dashBoard,
      );

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectToJson(this);
  Project copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    String? leader,
    ProjectViewType? viewType,
    DateTime? lastChangeAt,
    String? description,
    List<String>? members,
    List<String>? categories,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      leader: leader ?? this.leader,
      viewType: viewType ?? this.viewType,
      lastChangeAt: lastChangeAt ?? this.lastChangeAt,
      description: description ?? this.description,
      members: members ?? this.members,
      categories: categories ?? this.categories,
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
  @JsonKey(name: ProjectKeys.leader)
  final String leader;

  ///Return time when the last change
  @JsonKey(name: ProjectKeys.lastChangeAt)
  final DateTime lastChangeAt;

  @JsonKey(name: ProjectKeys.description)
  final String description;

  @JsonKey(name: ProjectKeys.viewType)
  final ProjectViewType viewType;

  ///Return list of members's id (UserID)
  @JsonKey(name: ProjectKeys.members)
  final List<String> members;

  @JsonKey(name: ProjectKeys.categories)
  final List<String> categories;

  @override
  bool get stringify => true;
  @override
  List<Object> get props {
    return [
      id,
      name,
      createdAt,
      leader,
      viewType,
      lastChangeAt,
      description,
      members,
      categories,
    ];
  }
}
