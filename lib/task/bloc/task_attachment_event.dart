part of 'task_attachment_bloc.dart';

abstract class TaskAttachmentEvent extends Equatable {
  const TaskAttachmentEvent();

  @override
  List<Object?> get props => [];
}

class FetchAllAttachments extends TaskAttachmentEvent {
  const FetchAllAttachments(this.taskId, this.uploaderId);
  final String taskId;
  final String uploaderId;

  @override
  List<Object?> get props => [taskId, uploaderId];
}

class PickAttachment extends TaskAttachmentEvent {}

class UploadAttachment extends TaskAttachmentEvent {
  const UploadAttachment(this.file);

  final File file;
  @override
  List<Object?> get props => [file];
}

class UpdateAttachments extends TaskAttachmentEvent {
  const UpdateAttachments(this.attachments);

  final List<Attachment> attachments;
  @override
  List<Object?> get props => [attachments];
}

class DownloadAttachments extends TaskAttachmentEvent {
  const DownloadAttachments(this.attachment);

  final Attachment attachment;
  @override
  List<Object?> get props => [attachment];
}

class DeleteAttachment extends TaskAttachmentEvent {
  const DeleteAttachment(this.attachment);

  final Attachment attachment;
  @override
  List<Object?> get props => [attachment];
}
