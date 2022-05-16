import 'package:equatable/equatable.dart';
import 'package:join_me/utilities/keys/user_keys.dart';

import 'package:json_annotation/json_annotation.dart';

part 'app_user.g.dart';

@JsonSerializable()
class AppUser extends Equatable {
  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.personalBio,
    required this.photoUrl,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);

  Map<String, dynamic> toJson() => _$AppUserToJson(this);

  //AppUser properties:
  @JsonKey(name: UserKeys.id)
  final String id;
  @JsonKey(name: UserKeys.name)
  final String name;
  @JsonKey(name: UserKeys.email)
  final String email;
  @JsonKey(name: UserKeys.personalBio)
  final String personalBio;
  @JsonKey(name: UserKeys.photoUrl)
  final String photoUrl;

  AppUser copyWith({
    String? id,
    String? name,
    String? email,
    String? personalBio,
    String? photoUrl,
  }) {
    return AppUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      personalBio: personalBio ?? this.personalBio,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  /// Empty user which represents an unauthenticated user.
  static const empty = AppUser(
    id: '',
    name: '',
    email: '',
    personalBio: '',
    photoUrl: '',
  );

  /// Convenience getter to determine whether the current user is empty.
  bool get isEmpty => this == AppUser.empty;

  /// Convenience getter to determine whether the current user is not empty.
  bool get isNotEmpty => this != AppUser.empty;

  @override
  String toString() {
    // ignore: lines_longer_than_80_chars
    return 'AppUser(uid: $id, displayName: $name, email: $email, photoUrl: $photoUrl,)';
  }

  @override
  List<Object> get props => [id, name, email, personalBio, photoUrl];
}
