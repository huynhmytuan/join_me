import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:join_me/data/models/models.dart';
import 'package:join_me/data/models/notification.dart';
import 'package:join_me/data/repositories/notification_repository.dart';
import 'package:join_me/utilities/keys/comment_keys.dart';
import 'package:join_me/utilities/keys/post_keys.dart';
import 'package:photo_manager/photo_manager.dart';

class PostRepository {
  PostRepository({
    FirebaseFirestore? firebaseFirestore,
    FirebaseStorage? firebaseStorage,
    NotificationRepository? notificationRepository,
  })  : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance,
        _notificationRepository =
            notificationRepository ?? NotificationRepository();

  final FirebaseFirestore _firebaseFirestore;
  final FirebaseStorage _firebaseStorage;
  final NotificationRepository _notificationRepository;

  Stream<List<Post>> fetchPosts({
    Post? lastedPost,
    String? userId,
    required int paginationSize,
  }) {
    if (userId != null) {
      return _firebaseFirestore
          .collection(PostKeys.collection)
          .orderBy(PostKeys.id)
          .orderBy(PostKeys.createdAt, descending: true)
          .where(PostKeys.authorId, isEqualTo: userId)
          .startAfter([lastedPost?.id, lastedPost?.createdAt])
          .limit(paginationSize)
          .snapshots()
          .map(
            (snapshotQuery) => snapshotQuery.docs
                .map((doc) => Post.fromJson(doc.data()))
                .toList(),
          );
    }
    return _firebaseFirestore
        .collection(PostKeys.collection)
        .orderBy(PostKeys.id)
        .orderBy(PostKeys.createdAt, descending: true)
        .startAfter([lastedPost?.id, lastedPost?.createdAt])
        .limit(paginationSize)
        .snapshots()
        .map(
          (snapshotQuery) => snapshotQuery.docs
              .map((doc) => Post.fromJson(doc.data()))
              .toList(),
        );
  }

  //Get post
  Stream<Post?> getPostById({required String postId}) {
    return _firebaseFirestore
        .collection(PostKeys.collection)
        .doc(postId)
        .snapshots()
        .map((doc) => doc.exists ? Post.fromJson(doc.data()!) : null);
  }

  //Add Post
  Future<void> addPost({
    required Post post,
    List<AssetEntity?> medias = const [],
  }) async {
    final ref = await _firebaseFirestore
        .collection(PostKeys.collection)
        .add(post.toJson());
    final mediasIds = <String>[];
    if (medias.isNotEmpty) {
      for (final media in medias) {
        final rand = Random().nextInt(10000);
        final file = await media!.file;
        final ext = media.type == AssetType.image ? 'png' : 'mp4';
        final fileRef = _firebaseStorage
            .ref('post_medias')
            .child('${ref.id}}')
            .child('$rand.$ext');
        await fileRef.putFile(file!);
        final downloadLink = await fileRef.getDownloadURL();
        mediasIds.add(downloadLink);
      }
    }
    await ref.set(
      <String, dynamic>{
        PostKeys.id: ref.id,
        PostKeys.medias: mediasIds,
      },
      SetOptions(
        merge: true,
      ),
    );
  }

  ///Delete Post and all it's comments
  Future<void> deletePost({
    required String postId,
  }) async {
    try {
      await _firebaseFirestore
          .collection(PostKeys.collection)
          .doc(postId)
          .delete()
          .then((value) async {
        final collection = await _firebaseFirestore
            .collection(CommentKeys.collection)
            .doc(postId)
            .collection(CommentKeys.collection)
            .get();
        for (final doc in collection.docs) {
          await doc.reference.delete();
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  //Like/Unlike Post
  Future<void> likeUnLikePost({
    required Post post,
    required String userId,
  }) async {
    final ref = _firebaseFirestore.collection(PostKeys.collection).doc(post.id);
    final likes = List.of(post.likes);
    if (post.likes.contains(userId)) {
      likes.remove(userId);
    } else {
      likes.add(userId);
    }
    await ref.set(
      <String, dynamic>{PostKeys.likes: likes},
      SetOptions(
        merge: true,
      ),
    );
    if (userId != post.authorId && !post.likes.contains(userId)) {
      final notification = await _notificationRepository.findNotification(
        type: NotificationType.likePost,
        actorId: userId,
        targetId: post.id,
        notifier: post.authorId,
      );
      if (notification == null) {
        unawaited(
          _notificationRepository.addNotification(
            notification: NotificationModel(
              id: '',
              createdAt: DateTime.now(),
              notificationType: NotificationType.likePost,
              actorId: userId,
              targetId: post.id,
              notifierId: post.authorId,
            ),
          ),
        );
      } else {
        unawaited(
          _notificationRepository.update(
            notification: notification.copyWith(createdAt: DateTime.now()),
          ),
        );
      }
    }
  }
}
