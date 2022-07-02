import 'dart:async';
import 'dart:developer';

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as fire_storage;

import 'package:join_me/data/models/models.dart';
import 'package:join_me/data/models/notification.dart';
import 'package:join_me/data/repositories/notification_repository.dart';
import 'package:join_me/utilities/extensions/extensions.dart';
import 'package:join_me/utilities/keys/attachment_keys.dart';
import 'package:join_me/utilities/keys/task_keys.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class TaskRepository {
  TaskRepository({
    FirebaseFirestore? firebaseFirestore,
    fire_storage.FirebaseStorage? firebaseStorage,
    NotificationRepository? notificationRepository,
  })  : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        _firebaseStorage =
            firebaseStorage ?? fire_storage.FirebaseStorage.instance,
        _notificationRepository =
            notificationRepository ?? NotificationRepository();

  final FirebaseFirestore _firebaseFirestore;
  final fire_storage.FirebaseStorage _firebaseStorage;
  final NotificationRepository _notificationRepository;

  Stream<Task?> getTaskById(String taskId) {
    try {
      final querySnapshots = _firebaseFirestore
          .collection(TaskKeys.collection)
          .doc(taskId)
          .snapshots();

      return querySnapshots.map(
        (doc) => doc.exists ? Task.fromJson(doc.data()!) : null,
      );
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<Task>> getListProjectTasks(String projectId) {
    return _firebaseFirestore
        .collection(TaskKeys.collection)
        .where(TaskKeys.projectId, isEqualTo: projectId)
        .where(TaskKeys.type, isEqualTo: 'task')
        .orderBy(TaskKeys.createdAt, descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((data) => Task.fromJson(data.data())).toList();
    });
  }

  Stream<List<Task>> getSubTasks({required String parentId}) {
    return _firebaseFirestore
        .collection(TaskKeys.collection)
        .where(TaskKeys.subTaskOf, isEqualTo: parentId)
        .where(TaskKeys.type, isEqualTo: 'sub-task')
        .orderBy(TaskKeys.createdAt, descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((data) => Task.fromJson(data.data())).toList();
    });
  }

  Future<void> addTask(Task task, String currentUser) async {
    final ref = await _firebaseFirestore
        .collection(TaskKeys.collection)
        .add(task.toJson());
    await ref.set(
      <String, String>{
        TaskKeys.id: ref.id,
      },
      SetOptions(
        merge: true,
      ),
    );

    //Check Assignee and notification
    for (final userId in task.assignee) {
      if (userId == currentUser) {
        break;
      }
      final notification = NotificationModel(
        id: '',
        createdAt: DateTime.now(),
        notificationType: NotificationType.assign,
        actorId: currentUser,
        targetId: ref.id,
        notifierId: userId,
        isRead: false,
      );

      await _notificationRepository.addNotification(
        notification: notification,
      );
    }
  }

  ///Delete Task
  Future<void> deleteTask({required Task task}) async {
    final ref = _firebaseFirestore.collection(TaskKeys.collection).doc(task.id);
    await ref.delete();
  }

  ///Update Task
  Future<void> updateTask({
    required Task task,
    required String currentUser,
  }) async {
    final ref = _firebaseFirestore.collection(TaskKeys.collection).doc(task.id);
    final previousData = Task.fromJson((await ref.get()).data()!);
    await ref.set(
      task.toJson(),
      SetOptions(
        merge: true,
      ),
    );
    //Check Assignee and notification
    for (final userId in task.assignee) {
      if (userId == currentUser) {
        break;
      }
      if (!previousData.assignee.contains(userId)) {
        final notification = NotificationModel(
          id: '',
          createdAt: DateTime.now(),
          notificationType: NotificationType.assign,
          actorId: currentUser,
          targetId: task.id,
          notifierId: userId,
          isRead: false,
        );
        unawaited(
          _notificationRepository.addNotification(notification: notification),
        );
      }
    }
  }

  ///Add Sub-task
  Future<void> addSubTask({required Task parent, required Task subTask}) async {
    //Add new subTask
    final refSubtask = await _firebaseFirestore
        .collection(TaskKeys.collection)
        .add(subTask.toJson());
    await refSubtask.set(
      <String, String>{
        TaskKeys.id: refSubtask.id,
        TaskKeys.subTaskOf: parent.id,
      },
      SetOptions(
        merge: true,
      ),
    );
    //Get Parent Task
    final refParent =
        _firebaseFirestore.collection(TaskKeys.collection).doc(parent.id);
    await refParent.set(
      <String, dynamic>{
        TaskKeys.subTasks: parent.subTasks..add(refSubtask.id),
      },
      SetOptions(
        merge: true,
      ),
    );
    //Check Assignee and notification
    for (final userId in subTask.assignee) {
      if (userId == subTask.createdBy) {
        break;
      }
      final notification = NotificationModel(
        id: '',
        createdAt: DateTime.now(),
        notificationType: NotificationType.assign,
        actorId: subTask.createdBy,
        targetId: refSubtask.id,
        notifierId: userId,
        isRead: false,
      );
      unawaited(
        _notificationRepository.addNotification(notification: notification),
      );
    }
  }

  Stream<List<Attachment>> getAttachments({required String taskId}) {
    return _firebaseFirestore
        .collection(TaskKeys.collection)
        .doc(taskId)
        .collection(AttachmentKeys.collection)
        .orderBy(AttachmentKeys.uploadAt)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((data) => Attachment.fromJson(data.data()))
          .toList();
    });
  }

  Future<void> uploadAttachment(
    File file,
    String taskId,
    String uploaderId,
  ) async {
    final fileBaseName = basename(file.path);
    final fileRef = _firebaseStorage
        .ref(AttachmentKeys.collection)
        .child(taskId)
        .child(fileBaseName);
    await fileRef.putFile(file);
    final downloadLink = await fileRef.getDownloadURL();
    final fileSize = await ''.getFileSize(file, 1);
    final attachmentRecord = Attachment(
      id: '',
      downloadLink: downloadLink,
      uploaderId: uploaderId,
      fileExt: extension(file.path),
      fileName: fileBaseName,
      uploadAt: DateTime.now(),
      size: fileSize,
    );
    final ref = await _firebaseFirestore
        .collection(TaskKeys.collection)
        .doc(taskId)
        .collection(AttachmentKeys.collection)
        .add(attachmentRecord.toJson());
    await ref.update({'id': ref.id});
  }

  Future<File?> downloadAttachment(
    Attachment attachment,
    String taskId,
  ) async {
    final fileRef = _firebaseStorage.refFromURL(attachment.downloadLink);
    //Get application directory
    final appDir = await path_provider.getApplicationDocumentsDirectory();
    final file = File('${appDir.path}/${attachment.fileName}');
    await fileRef.writeToFile(file);
    log(file.path);
    return file;
  }

  Future<void> deleteAttachment(
    Attachment attachment,
    String taskId,
  ) async {
    final fileRef = _firebaseStorage
        .ref(AttachmentKeys.collection)
        .child(taskId)
        .child(attachment.fileName);

    await fileRef.delete();
    final ref = _firebaseFirestore
        .collection(TaskKeys.collection)
        .doc(taskId)
        .collection(AttachmentKeys.collection)
        .doc(attachment.id);
    await ref.delete();
    //Get application directory
    final appDir = await path_provider.getApplicationDocumentsDirectory();
    final file = File('${appDir.path}/${attachment.fileName}');
    if (file.existsSync()) {
      unawaited(file.delete());
    }
  }
}
