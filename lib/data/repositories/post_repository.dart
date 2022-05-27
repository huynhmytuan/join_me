import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:join_me/data/models/models.dart';
import 'package:join_me/utilities/keys/post_keys.dart';
import 'package:photo_manager/photo_manager.dart';

class PostRepository {
  PostRepository({
    FirebaseFirestore? firebaseFirestore,
    FirebaseStorage? firebaseStorage,
  })  : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance;

  final FirebaseFirestore _firebaseFirestore;
  final FirebaseStorage _firebaseStorage;

  Future<List<Post>> fetchPosts({Post? lastedPost}) async {
    final ref = await _firebaseFirestore
        .collection(PostKeys.collection)
        .orderBy(PostKeys.id)
        .orderBy(PostKeys.createdAt, descending: true)
        .startAt([lastedPost?.id, lastedPost?.createdAt])
        .limit(20)
        .get();
    return ref.docs.map((doc) => Post.fromJson(doc.data())).toList();
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
}
