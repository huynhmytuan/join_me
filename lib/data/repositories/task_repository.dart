import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:join_me/data/models/task.dart';
import 'package:join_me/utilities/keys/task_keys.dart';

class TaskRepository {
  TaskRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firebaseFirestore;

  Stream<Task> getTaskById(String taskId) {
    try {
      final querySnapshots = _firebaseFirestore
          .collection(TaskKeys.collection)
          .doc(taskId)
          .snapshots();
      return querySnapshots.map((doc) => Task.fromJson(doc.data()!));
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

  Future<List<Task>> getSubTask({required List<String> taskIds}) async {
    final ref = await _firebaseFirestore
        .collection(TaskKeys.collection)
        .where(TaskKeys.id, whereIn: taskIds)
        .where(TaskKeys.type, isEqualTo: 'sub-task')
        .orderBy(TaskKeys.createdAt, descending: true)
        .get();

    return ref.docs.map((doc) => Task.fromJson(doc.data())).toList();
  }

  Future<void> addTask(Task task) async {
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
  }

  ///Delete Task
  Future<void> deleteTask({required Task task}) async {
    final ref = _firebaseFirestore.collection(TaskKeys.collection).doc(task.id);
    await ref.delete();
  }

  ///Update Task
  Future<void> updateTask({required Task task}) async {
    final ref = _firebaseFirestore.collection(TaskKeys.collection).doc(task.id);
    await ref.set(
      task.toJson(),
      SetOptions(
        merge: true,
      ),
    );
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
