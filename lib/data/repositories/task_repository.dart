import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:join_me/data/models/notification.dart';
import 'package:join_me/data/models/task.dart';
import 'package:join_me/data/repositories/notification_repository.dart';
import 'package:join_me/utilities/keys/task_keys.dart';

class TaskRepository {
  TaskRepository({
    FirebaseFirestore? firebaseFirestore,
    NotificationRepository? notificationRepository,
  })  : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        _notificationRepository =
            notificationRepository ?? NotificationRepository();

  final FirebaseFirestore _firebaseFirestore;

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
    log(ref.id, name: 'TASK_ID');
    //Check Assignee and notification
    for (final userId in task.assignee) {
      final notification = NotificationModel(
        id: '',
        createdAt: DateTime.now(),
        notificationType: NotificationType.assign,
        actorId: currentUser,
        targetId: ref.id,
        notifierId: userId,
        isRead: false,
      );
      log(notification.toString());
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
  }
}
