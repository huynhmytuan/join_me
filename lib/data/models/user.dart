import 'package:equatable/equatable.dart';
import 'package:join_me/utilities/keys/user_keys.dart';

import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends Equatable {
  const User({
    required this.id,
    required this.displayName,
    required this.email,
    required this.personalBio,
    required this.photoUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  //AppUser properties:
  @JsonKey(name: UserKeys.id)
  final String id;
  @JsonKey(name: UserKeys.displayName)
  final String displayName;
  @JsonKey(name: UserKeys.email)
  final String email;
  @JsonKey(name: UserKeys.personalBio)
  final String personalBio;
  @JsonKey(name: UserKeys.photoUrl)
  final String photoUrl;

  User copyWith({
    String? id,
    String? displayName,
    String? email,
    String? personalBio,
    String? photoUrl,
  }) {
    return User(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      personalBio: personalBio ?? this.personalBio,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  @override
  String toString() {
    // ignore: lines_longer_than_80_chars
    return 'AppUser(uid: $id, displayName: $displayName, email: $email, photoUrl: $photoUrl)';
  }

  @override
  List<Object> get props => [id, displayName, email, personalBio, photoUrl];
}
