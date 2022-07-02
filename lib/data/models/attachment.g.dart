// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attachment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Attachment _$AttachmentFromJson(Map<String, dynamic> json) => Attachment(
      id: json['id'] as String,
      downloadLink: json['postId'] as String,
      uploaderId: json['authorId'] as String,
      fileExt: json['fileExt'] as String,
      fileName: json['fileName'] as String,
      uploadAt: DateTime.parse(json['createdAt'] as String),
      size: json['size'] as String,
    );

Map<String, dynamic> _$AttachmentToJson(Attachment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'authorId': instance.uploaderId,
      'createdAt': instance.uploadAt.toIso8601String(),
      'fileName': instance.fileName,
      'fileExt': instance.fileExt,
      'postId': instance.downloadLink,
      'size': instance.size,
    };
