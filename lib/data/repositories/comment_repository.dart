import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:join_me/data/models/models.dart';
import 'package:join_me/data/models/notification.dart';
import 'package:join_me/data/repositories/notification_repository.dart';
import 'package:join_me/utilities/keys/comment_keys.dart';
import 'package:join_me/utilities/keys/post_keys.dart';

class CommentRepository {
  CommentRepository({
    FirebaseFirestore? firebaseFirestore,
    NotificationRepository? notificationRepository,
  })  : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        _notificationRepository =
            notificationRepository ?? NotificationRepository();

  final FirebaseFirestore _firebaseFirestore;
  final NotificationRepository _notificationRepository;

  Stream<List<Comment>> fetchAllPostComment({required String postId}) {
    return _firebaseFirestore
        .collection(CommentKeys.collection)
        .doc(postId)
        .collection(CommentKeys.collection)
        .orderBy(CommentKeys.createdAt, descending: true)
        .snapshots()
        .map(
          (queySnapshot) => queySnapshot.docs
              .map(
                (doc) => Comment.fromJson(doc.data()),
              )
              .toList(),
        );
  }

  Future<Comment?> getCommentById(String postId, String commentId) async {
    final doc = await _firebaseFirestore
        .collection(CommentKeys.collection)
        .doc(postId)
        .collection(CommentKeys.collection)
        .doc(commentId)
        .get();
    return doc.exists ? Comment.fromJson(doc.data()!) : null;
  }

  //Add Comment
  Future<void> addComment(Comment comment, Post post) async {
    final ref = await _firebaseFirestore
        .collection(CommentKeys.collection)
        .doc(comment.postId)
        .collection(CommentKeys.collection)
        .add(comment.toJson());
    await ref.set(
      <String, dynamic>{
        CommentKeys.id: ref.id,
      },
      SetOptions(
        merge: true,
      ),
    );

    //Increase post's comments count
    final postRef =
        _firebaseFirestore.collection(PostKeys.collection).doc(comment.postId);
    await postRef.update(<String, dynamic>{
      PostKeys.commentCount: FieldValue.increment(1),
      PostKeys.follower: FieldValue.arrayUnion(<String>[post.authorId]),
    });

    //Add Notification
    if (comment.authorId != post.authorId) {
      // Add comment author to post follower
      unawaited(
        _notificationRepository.addNotification(
          notification: NotificationModel(
            id: '',
            createdAt: comment.createdAt,
            notificationType: NotificationType.comment,
            actorId: comment.authorId,
            targetId: '${post.id}/${ref.id}'.trim(),
            notifierId: post.authorId,
            isRead: false,
          ),
        ),
      );
    }
  }

  //Delete Comment
  Future<void> deleteComment(Comment comment) async {
    final ref = _firebaseFirestore
        .collection(CommentKeys.collection)
        .doc(comment.postId)
        .collection(CommentKeys.collection)
        .doc(comment.id);
    await ref.delete();
    //Decrease post's comments count
    final postRef =
        _firebaseFirestore.collection(PostKeys.collection).doc(comment.postId);
    await postRef.update(<String, dynamic>{
      PostKeys.commentCount: FieldValue.increment(-1),
    });
  }

  Future<void> likeUnlikeComment({
    required Comment comment,
    required String userId,
  }) async {
    final likes = List.of(comment.likes);
    if (likes.contains(userId)) {
      likes.remove(userId);
    } else {
      likes.add(userId);
    }
    await _firebaseFirestore
        .collection(CommentKeys.collection)
        .doc(comment.postId)
        .collection(CommentKeys.collection)
        .doc(comment.id)
        .set(
      <String, dynamic>{CommentKeys.likes: likes},
      SetOptions(
        merge: true,
      ),
    );
    if (userId != comment.authorId && likes.contains(userId)) {
      final notification = await _notificationRepository.findNotification(
        type: NotificationType.likeComment,
        actorId: userId,
        targetId: '${comment.postId}/${comment.id}'.trim(),
        notifier: comment.authorId,
      );
      if (notification == null) {
        unawaited(
          _notificationRepository.addNotification(
            notification: NotificationModel(
              id: '',
              createdAt: DateTime.now(),
              notificationType: NotificationType.likeComment,
              actorId: userId,
              targetId: '${comment.postId}/${comment.id}'.trim(),
              notifierId: comment.authorId,
              isRead: false,
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
