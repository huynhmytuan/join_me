import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:join_me/app/cubit/app_message_cubit.dart';
import 'package:join_me/data/models/attachment.dart';
import 'package:join_me/data/repositories/repositories.dart';
import 'package:join_me/generated/locale_keys.g.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

part 'task_attachment_event.dart';
part 'task_attachment_state.dart';

class TaskAttachmentBloc
    extends Bloc<TaskAttachmentEvent, TaskAttachmentState> {
  TaskAttachmentBloc({
    required TaskRepository taskRepository,
    required AppMessageCubit appMessageCubit,
  })  : _taskRepository = taskRepository,
        _appMessageCubit = appMessageCubit,
        super(
          TaskAttachmentState.initial(),
        ) {
    on<FetchAllAttachments>(_onFetchAllAttachments);
    on<UpdateAttachments>(_onUpdateAttachments);
    on<PickAttachment>(_onPickAttachment);
    on<UploadAttachment>(_onUploadAttachment);
    on<DownloadAttachments>(_onDownloadAttachments);
    on<DeleteAttachment>(_onDeleteAttachment);
  }

  final TaskRepository _taskRepository;
  final AppMessageCubit _appMessageCubit;
  StreamSubscription<List<Attachment>?>? _attachmentsSubscription;

  Future<void> _onFetchAllAttachments(
    FetchAllAttachments event,
    Emitter<TaskAttachmentState> emit,
  ) async {
    emit(
      state.copyWith(
        taskId: event.taskId,
        uploaderId: event.uploaderId,
        status: TaskAttachmentStatus.loading,
      ),
    );
    await _attachmentsSubscription?.cancel();
    _attachmentsSubscription = _taskRepository
        .getAttachments(taskId: event.taskId)
        .listen((attachments) {
      add(UpdateAttachments(attachments));
    });
  }

  Future<void> _onUpdateAttachments(
    UpdateAttachments event,
    Emitter<TaskAttachmentState> emit,
  ) async {
    emit(
      state.copyWith(
        attachments: event.attachments,
        status: TaskAttachmentStatus.loaded,
      ),
    );
  }

  Future<void> _onPickAttachment(
    PickAttachment event,
    Emitter<TaskAttachmentState> emit,
  ) async {
    final pickerResult = await FilePicker.platform.pickFiles();
    if (pickerResult != null) {
      final file = File(pickerResult.files.first.path!);
      emit(state.copyWith(selectedFile: file));
    }
  }

  Future<void> _onUploadAttachment(
    UploadAttachment event,
    Emitter<TaskAttachmentState> emit,
  ) async {
    try {
      _appMessageCubit.showInfoSnackbar(
        message: LocaleKeys.notice_attachment_uploading.tr(),
      );
      emit(state.copyWith(status: TaskAttachmentStatus.uploading));
      await _taskRepository.uploadAttachment(
        event.file,
        state.taskId,
        state.uploaderId,
      );
      _appMessageCubit.showSuccessfulSnackBar(
        message: LocaleKeys.notice_attachment_uploaded.tr(),
      );
      emit(state.copyWith(status: TaskAttachmentStatus.loaded));
    } catch (e) {
      emit(state.copyWith(status: TaskAttachmentStatus.error));
    }
  }

  Future<void> _onDownloadAttachments(
    DownloadAttachments event,
    Emitter<TaskAttachmentState> emit,
  ) async {
    try {
      //Get application directory
      final appDir = await getApplicationDocumentsDirectory();
      final file = File('${appDir.path}/${event.attachment.fileName}');
      if (file.existsSync()) {
        await OpenFile.open(file.path);
      } else {
        _appMessageCubit.showInfoSnackbar(
          message: LocaleKeys.notice_attachment_downloading.tr(),
        );
        await _taskRepository
            .downloadAttachment(
          event.attachment,
          state.taskId,
        )
            .then((file) {
          OpenFile.open(file!.path);
        });
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _onDeleteAttachment(
    DeleteAttachment event,
    Emitter<TaskAttachmentState> emit,
  ) async {
    try {
      await _taskRepository.deleteAttachment(
        event.attachment,
        state.taskId,
      );
      _appMessageCubit.showInfoSnackbar(
        message: LocaleKeys.notice_deleteSuccess.tr(),
      );
    } catch (e) {
      log(e.toString());
    }
  }
}
