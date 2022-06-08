import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:join_me/data/models/models.dart';

import 'package:join_me/utilities/keys/project_keys.dart';
import 'package:join_me/utilities/keys/task_keys.dart';

class ProjectRepository {
  ProjectRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firebaseFirestore;

  Stream<Project?> getProjectById(String projectId) {
    try {
      final querySnapshots = _firebaseFirestore
          .collection(ProjectKeys.collection)
          .doc(projectId)
          .snapshots();

      return querySnapshots
          .map((doc) => doc.exists ? Project.fromJson(doc.data()!) : null);
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<Project>> getUserProjects(String userId) {
    return _firebaseFirestore
        .collection(ProjectKeys.collection)
        .where(
          ProjectKeys.members,
          arrayContains: userId,
        )
        .orderBy(ProjectKeys.createdAt, descending: true)
        .snapshots()
        .map(
      (snapshot) {
        return snapshot.docs
            .map((doc) => Project.fromJson(doc.data()))
            .toList();
      },
    );
  }

  Future<Project> addProject({required Project project}) async {
    try {
      final ref = await _firebaseFirestore
          .collection(ProjectKeys.collection)
          .add(project.toJson());
      await ref.set(
        <String, String>{
          ProjectKeys.id: ref.id,
        },
        SetOptions(
          merge: true,
        ),
      );
      final documentSnapshot = await ref.get();
      return Project.fromJson(documentSnapshot.data()!);
    } catch (e) {
      rethrow;
    }
  }

  Future<Project> updateProject({required Project project}) async {
    try {
      final ref =
          _firebaseFirestore.collection(ProjectKeys.collection).doc(project.id);

      await ref.set(
        project.toJson(),
        SetOptions(merge: true),
      );
      final documentSnapshot = await ref.get();
      return Project.fromJson(documentSnapshot.data()!);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteProject({required Project project}) async {
    try {
      //Get Project referent and delete all.
      final ref =
          _firebaseFirestore.collection(ProjectKeys.collection).doc(project.id);
      await ref.delete();
      //Get All Project's tasks and delete all
      final tasks = await _firebaseFirestore
          .collection(TaskKeys.collection)
          .where(TaskKeys.projectId, isEqualTo: project.id)
          .get();
      for (final task in tasks.docs) {
        await task.reference.delete();
      }
    } catch (e) {
      rethrow;
    }
  }

  ///Add a new request
  Future<void> addJoinRequest({
    required Project project,
    required String requester,
  }) async {
    try {
      //Get Project request referent and delete all.
      final ref =
          _firebaseFirestore.collection(ProjectKeys.collection).doc(project.id);
      //Update request Id
      await ref.set(
        <String, dynamic>{
          ProjectKeys.requests: FieldValue.arrayUnion(<String>[requester])
        },
        SetOptions(merge: true),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> acceptJoinRequest({
    required String projectId,
    required String requesterId,
  }) async {
    try {
      //Get Project request referent and delete all.
      final ref =
          _firebaseFirestore.collection(ProjectKeys.collection).doc(projectId);
      //Update request Id
      await ref.set(
        <String, dynamic>{
          ProjectKeys.members: FieldValue.arrayUnion(<String>[requesterId]),
          ProjectKeys.requests: FieldValue.arrayRemove(<String>[requesterId]),
        },
        SetOptions(merge: true),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> rejectJoinRequest({
    required String projectId,
    required String requesterId,
  }) async {
    try {
      //Get Project request referent and delete all.
      final ref =
          _firebaseFirestore.collection(ProjectKeys.collection).doc(projectId);
      //Update request Id
      await ref.set(
        <String, dynamic>{
          ProjectKeys.requests: FieldValue.arrayRemove(<String>[requesterId])
        },
        SetOptions(merge: true),
      );
    } catch (e) {
      rethrow;
    }
  }
}
