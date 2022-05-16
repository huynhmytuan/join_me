// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppUser _$AppUserFromJson(Map<String, dynamic> json) => AppUser(
      id: json['userId'] as String,
      name: json['displayName'] as String,
      email: json['email'] as String,
      personalBio: json['personalBio'] as String,
      photoUrl: json['photoUrl'] as String,
    );

Map<String, dynamic> _$AppUserToJson(AppUser instance) => <String, dynamic>{
      'userId': instance.id,
      'displayName': instance.name,
      'email': instance.email,
      'personalBio': instance.personalBio,
      'photoUrl': instance.photoUrl,
    };
