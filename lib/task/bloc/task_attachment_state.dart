part of 'task_attachment_bloc.dart';

enum TaskAttachmentStatus {
  initial,
  loading,
  uploading,
  loaded,
  error,
}

class TaskAttachmentState extends Equatable {
  const TaskAttachmentState({
    required this.attachments,
    required this.status,
    required this.taskId,
    required this.uploaderId,
    this.selectedFile,
  });
  factory TaskAttachmentState.initial() => const TaskAttachmentState(
        attachments: [],
        status: TaskAttachmentStatus.initial,
        taskId: '',
        uploaderId: '',
      );
  final List<Attachment> attachments;
  final String taskId;
  final String uploaderId;
  final TaskAttachmentStatus status;
  final File? selectedFile;

  TaskAttachmentState copyWith({
    List<Attachment>? attachments,
    TaskAttachmentStatus? status,
    String? taskId,
    String? uploaderId,
    File? selectedFile,
  }) {
    return TaskAttachmentState(
      attachments: attachments ?? this.attachments,
      status: status ?? this.status,
      taskId: taskId ?? this.taskId,
      uploaderId: uploaderId ?? this.uploaderId,
      selectedFile: selectedFile,
    );
  }

  @override
  List<Object?> get props =>
      [attachments, status, taskId, uploaderId, selectedFile];
}
