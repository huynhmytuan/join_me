import 'package:equatable/equatable.dart';
import 'package:join_me/utilities/keys/attachment_keys.dart';
import 'package:json_annotation/json_annotation.dart';

part 'attachment.g.dart';

@JsonSerializable()
class Attachment extends Equatable {
  const Attachment({
    required this.id,
    required this.downloadLink,
    required this.uploaderId,
    required this.fileExt,
    required this.fileName,
    required this.uploadAt,
    required this.size,
  });
  factory Attachment.fromJson(Map<String, dynamic> json) =>
      _$AttachmentFromJson(json);

  Map<String, dynamic> toJson() => _$AttachmentToJson(this);
  //properties
  @JsonKey(name: AttachmentKeys.id)
  final String id;
  @JsonKey(name: AttachmentKeys.uploaderId)
  final String uploaderId;
  @JsonKey(name: AttachmentKeys.uploadAt)
  final DateTime uploadAt;
  @JsonKey(name: AttachmentKeys.fileName)
  final String fileName;
  @JsonKey(name: AttachmentKeys.fileExt)
  final String fileExt;
  @JsonKey(name: AttachmentKeys.downloadLink)
  final String downloadLink;
  @JsonKey(name: AttachmentKeys.size)
  final String size;

  @override
  bool get stringify => true;
  @override
  List<Object> get props {
    return [
      id,
      uploaderId,
      uploadAt,
      fileName,
      fileExt,
      downloadLink,
      size,
    ];
  }

  Attachment copyWith({
    String? id,
    String? uploaderId,
    DateTime? uploadAt,
    String? fileName,
    String? fileExt,
    String? downloadLink,
    String? size,
  }) {
    return Attachment(
      id: id ?? this.id,
      uploaderId: uploaderId ?? this.uploaderId,
      uploadAt: uploadAt ?? this.uploadAt,
      fileName: fileName ?? this.fileName,
      fileExt: fileExt ?? this.fileExt,
      downloadLink: downloadLink ?? this.downloadLink,
      size: size ?? this.size,
    );
  }
}
