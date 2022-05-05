import 'package:equatable/equatable.dart';
import 'package:join_me/utilities/keys/project_keys.dart';

import 'package:json_annotation/json_annotation.dart';

part 'project.g.dart';

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
  });
  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectToJson(this);
  Project copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    String? leader,
    DateTime? lastChangeAt,
    String? description,
    List<String>? members,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      leader: leader ?? this.leader,
      lastChangeAt: lastChangeAt ?? this.lastChangeAt,
      description: description ?? this.description,
      members: members ?? this.members,
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

  ///Return list of members's id (UserID)
  @JsonKey(name: ProjectKeys.members)
  final List<String> members;

  @override
  bool get stringify => true;
  @override
  List<Object> get props {
    return [
      id,
      name,
      createdAt,
      leader,
      lastChangeAt,
      description,
      members,
    ];
  }
}
