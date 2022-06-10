import 'dart:developer' as dev;
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:join_me/data/models/app_user.dart';
import 'package:join_me/data/services/push_notification_service.dart';
import 'package:join_me/utilities/keys/user_keys.dart';
import 'package:photo_manager/photo_manager.dart';

class UserRepository {
  UserRepository({
    FirebaseFirestore? firestore,
    FirebaseStorage? firebaseStorage,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance;

  final FirebaseFirestore _firestore;
  final FirebaseStorage _firebaseStorage;

  Future<void> writeUserDeviceToken(String userId) async {
    final ref = _firestore.collection(UserKeys.collection).doc(userId);
    final userNotExists = await ref.snapshots().isEmpty;
    //Check if user data created? Then create new.
    if (!userNotExists) {
      final token = await PushNotificationService().getToken();
      await ref.set(
        <String, dynamic>{'token': token},
        SetOptions(merge: true),
      );
    }
  }

  Future<void> removeUserDeviceToken(String userId) async {
    final ref = _firestore.collection(UserKeys.collection).doc(userId);
    final userNotExists = await ref.snapshots().isEmpty;
    //Check if user data created? Then create new.
    if (!userNotExists) {
      await ref.set(
        <String, dynamic>{'token': ''},
        SetOptions(merge: true),
      );
    }
  }

  ///Get user data from firestore with given user id
  Stream<AppUser> getUserById({required String userId}) {
    return _firestore
        .collection(UserKeys.collection)
        .doc(userId)
        .snapshots()
        .map(
          (doc) => AppUser.fromJson(doc.data()!),
        );
  }

  Future<AppUser> createNewUserDetail({required AppUser user}) async {
    try {
      final refData =
          await _firestore.collection(UserKeys.collection).doc(user.id).get();
      final isExists = refData.exists;
      //Check if user data created? Then create new.
      if (!isExists) {
        await refData.reference.set(user.toJson());
      }
      final doc = await refData.reference.get();
      return AppUser.fromJson(doc.data()!);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<AppUser>> searchUsers(String searchString) async {
    final ref = await _firestore
        .collection(UserKeys.collection)
        .where(
          UserKeys.name,
          isGreaterThanOrEqualTo: searchString,
          isLessThanOrEqualTo:
              searchString.substring(0, searchString.length - 1) +
                  String.fromCharCode(
                    searchString.codeUnitAt(searchString.length - 1) + 1,
                  ),
        )
        .orderBy(UserKeys.name)
        .limitToLast(10)
        .get();

    return ref.docs
        .map(
          (doc) => AppUser.fromJson(doc.data()),
        )
        .toList();
  }

  Future<List<AppUser>> getUsers({required List<String> userIds}) async {
    try {
      final userQuerySnap = await _firestore
          .collection(UserKeys.collection)
          .where(FieldPath.documentId, whereIn: userIds)
          .get();

      if (userQuerySnap.docs.isNotEmpty) {
        final users = userQuerySnap.docs
            .map(
              (snapshot) => AppUser.fromJson(
                snapshot.data(),
              ),
            )
            .toList();
        return users;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<void> updateUserAvatar({
    required AssetEntity imageEntity,
    required AppUser user,
  }) async {
    if (user.photoUrl.isNotEmpty) {
      try {
        final imageRef = _firebaseStorage.refFromURL(user.photoUrl);
        await imageRef.delete();
      } catch (e) {
        dev.log(e.toString());
      }
    }
    try {
      final rand = Random().nextInt(10000);
      final file = await imageEntity.file;
      final fileRef = _firebaseStorage
          .ref('user_avatar')
          .child('${user.id}}')
          .child('${user.id}_$rand.jpg');
      await fileRef.putFile(file!);
      final downloadLink = await fileRef.getDownloadURL();
      final userRef = _firestore.collection(UserKeys.collection).doc(user.id);
      await userRef.set(
        <String, String>{UserKeys.photoUrl: downloadLink},
        SetOptions(merge: true),
      );
    } catch (e) {
      dev.log(e.toString());
    }
  }

  Future<void> updateUserBio({
    required String newBio,
    required AppUser user,
  }) async {
    final userRef = _firestore.collection(UserKeys.collection).doc(user.id);
    await userRef.set(
      <String, String>{UserKeys.personalBio: newBio},
      SetOptions(merge: true),
    );
  }
}
