import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:join_me/data/models/app_user.dart';
import 'package:join_me/utilities/keys/user_keys.dart';

class UserRepository {
  UserRepository({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  ///Get user data from firestore with given user id
  Future<AppUser> getUserById({required String userId}) async {
    try {
      final userQuerySnap =
          await _firestore.collection(UserKeys.collection).doc(userId).get();
      if (userQuerySnap.exists) {
        final user = AppUser.fromJson(userQuerySnap.data()!);
        return user;
      }
      return AppUser.empty;
    } catch (e) {
      return AppUser.empty;
    }
  }

  Future<AppUser> createNewUserDetail({required AppUser user}) async {
    try {
      final ref = _firestore.collection(UserKeys.collection).doc(user.id);
      final userExists = await ref.snapshots().isEmpty;
      //Check if user data created? Then create new.
      if (!userExists) {
        await ref.set(user.toJson());
      }
      final userData = await ref.get();
      return AppUser.fromJson(userData.data()!);
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
}
