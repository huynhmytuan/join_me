import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:join_me/data/models/notification.dart';
import 'package:join_me/utilities/keys/notification_keys.dart';

class NotificationRepository {
  NotificationRepository({
    FirebaseFirestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firebaseFirestore;

  Stream<List<NotificationModel>> fetchAllUserNotification({
    required String userId,
  }) {
    return _firebaseFirestore
        .collection(NotificationKeys.collection)
        .doc(userId)
        .collection(NotificationKeys.collection)
        .orderBy(NotificationKeys.createdAt, descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => NotificationModel.fromJson(doc.data()),
              )
              .toList(),
        );
  }

  Future<NotificationModel?> findNotification({
    required NotificationType type,
    required String actorId,
    required String targetId,
    required String notifier,
  }) async {
    final ref = await _firebaseFirestore
        .collection(NotificationKeys.collection)
        .doc(notifier)
        .collection(NotificationKeys.collection)
        .where(
          NotificationKeys.notificationType,
          isEqualTo: _$NotificationTypeEnumMap[type],
        )
        .where(
          NotificationKeys.targetId,
          isEqualTo: targetId,
        )
        .where(
          NotificationKeys.actorId,
          isEqualTo: actorId,
        )
        .limit(1)
        .get();
    return ref.docs.isNotEmpty
        ? NotificationModel.fromJson(ref.docs[0].data())
        : null;
  }

  Future<void> addNotification({
    required NotificationModel notification,
  }) async {
    final ref = await _firebaseFirestore
        .collection(NotificationKeys.collection)
        .doc(notification.notifierId)
        .collection(NotificationKeys.collection)
        .add(notification.toJson());
    await ref.update({NotificationKeys.id: ref.id});
  }

  Future<void> update({
    required NotificationModel notification,
  }) async {
    await _firebaseFirestore
        .collection(NotificationKeys.collection)
        .doc(notification.notifierId)
        .collection(NotificationKeys.collection)
        .doc(notification.id)
        .update(notification.toJson());
  }

  Future<void> deleteNotification({
    required NotificationModel notification,
  }) async {
    await _firebaseFirestore
        .collection(NotificationKeys.collection)
        .doc(notification.notifierId)
        .collection(NotificationKeys.collection)
        .doc(notification.id)
        .delete();
  }
}

const _$NotificationTypeEnumMap = {
  NotificationType.likePost: 'likePost',
  NotificationType.likeComment: 'likeComment',
  NotificationType.comment: 'comment',
  NotificationType.invite: 'invite',
  NotificationType.assign: 'assign',
};
