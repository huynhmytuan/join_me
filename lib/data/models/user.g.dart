// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['userId'] as String,
      displayName: json['displayName'] as String,
      email: json['email'] as String,
      personalBio: json['personalBio'] as String,
      photoUrl: json['photoUrl'] as String,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'userId': instance.id,
      'displayName': instance.displayName,
      'email': instance.email,
      'personalBio': instance.personalBio,
      'photoUrl': instance.photoUrl,
    };
