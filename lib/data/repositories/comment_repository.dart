import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:join_me/data/models/models.dart';
import 'package:join_me/utilities/keys/comment_keys.dart';
import 'package:join_me/utilities/keys/post_keys.dart';

class CommentRepository {
  CommentRepository({
    FirebaseFirestore? firebaseFirestore,
    FirebaseStorage? firebaseStorage,
  })  : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance;

  final FirebaseFirestore _firebaseFirestore;
  final FirebaseStorage _firebaseStorage;

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

  //Add Comment
  Future<void> addComment(Comment comment) async {
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
    });
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
  }
}
