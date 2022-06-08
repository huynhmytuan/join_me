import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:join_me/data/models/conversation.dart';
import 'package:join_me/data/models/message.dart';
import 'package:join_me/utilities/keys/conversation_keys.dart';
import 'package:join_me/utilities/keys/message_keys.dart';

class MessageRepository {
  MessageRepository({
    FirebaseFirestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firebaseFirestore;

  Stream<Conversation?> getConversationById(String conversationId) {
    try {
      final querySnapshots = _firebaseFirestore
          .collection(ConversationKeys.collection)
          .doc(conversationId)
          .snapshots();

      return querySnapshots.map((doc) {
        if (doc.exists) {
          return Conversation.fromJson(doc.data()!);
        }
        return null;
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<Conversation?> getConversationByMembers(List<String> members) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshots;

      querySnapshots = await _firebaseFirestore
          .collection(ConversationKeys.collection)
          .where(
        ConversationKeys.members,
        whereIn: [members, members.reversed.toList()],
      ).get();
      if (querySnapshots.docs.isEmpty) {
        return null;
      }
      return Conversation.fromJson(querySnapshots.docs.first.data());
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<Conversation>> getUserConversations({
    String? userId,
  }) {
    return _firebaseFirestore
        .collection(ConversationKeys.collection)
        .where(
          ConversationKeys.members,
          arrayContains: userId,
        )
        .orderBy(ConversationKeys.lastModified, descending: true)
        .snapshots()
        .map(
      (snapshot) {
        return snapshot.docs
            .map((doc) => Conversation.fromJson(doc.data()))
            .toList();
      },
    );
  }

  //Add Post
  Future<Conversation> addConversation({
    required Conversation conversation,
    required Message firstMessage,
  }) async {
    final ref = await _firebaseFirestore
        .collection(ConversationKeys.collection)
        .add(conversation.toJson());
    await ref.set(
      <String, dynamic>{
        ConversationKeys.id: ref.id,
      },
      SetOptions(
        merge: true,
      ),
    );
    //AddMessage
    final messageRef = await _firebaseFirestore
        .collection(MessageKeys.collection)
        .doc(ref.id)
        .collection(MessageKeys.collection)
        .add(firstMessage.toJson());
    await messageRef.set(
      <String, dynamic>{
        MessageKeys.id: messageRef.id,
      },
      SetOptions(
        merge: true,
      ),
    );

    final doc = await ref.get();
    return Conversation.fromJson(doc.data()!);
  }

  Future<Message?> getConversationLastMessage({
    required String conversationId,
  }) async {
    final ref = await _firebaseFirestore
        .collection(MessageKeys.collection)
        .doc(conversationId)
        .collection(MessageKeys.collection)
        .orderBy(MessageKeys.createdAt, descending: true)
        .limit(1)
        .get();
    if (ref.docs.isEmpty) {
      return null;
    }
    return Message.fromJson(ref.docs.first.data());
  }

  Stream<List<Message>> loadAllConversationMessages({
    required String conversationId,
    String? userId,
  }) {
    //Update Conversation last change
    unawaited(
      _firebaseFirestore
          .collection(ConversationKeys.collection)
          .doc(conversationId)
          .set(
        <String, dynamic>{
          ConversationKeys.lastModified: DateTime.now().toIso8601String(),
        },
        SetOptions(
          merge: true,
        ),
      ),
    );
    return _firebaseFirestore
        .collection(MessageKeys.collection)
        .doc(conversationId)
        .collection(MessageKeys.collection)
        .orderBy(MessageKeys.createdAt, descending: true)
        .snapshots()
        .map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          if (userId != null) {
            final seenBy = doc.get(MessageKeys.seenBy) as List;
            if (!seenBy.contains(userId)) {
              unawaited(
                doc.reference.set(
                  <String, dynamic>{
                    MessageKeys.seenBy: FieldValue.arrayUnion(<String>[userId]),
                  },
                  SetOptions(merge: true),
                ),
              );
            }
          }
          return Message.fromJson(doc.data());
        }).toList();
      },
    );
  }

  Future<void> sendMessage({
    required Message message,
  }) async {
    final messageRef = await _firebaseFirestore
        .collection(MessageKeys.collection)
        .doc(message.conversationId)
        .collection(MessageKeys.collection)
        .add(message.toJson());
    await messageRef.set(
      <String, dynamic>{
        MessageKeys.id: messageRef.id,
      },
      SetOptions(
        merge: true,
      ),
    );
    //Update Conversation last change
    final conversationRef = _firebaseFirestore
        .collection(ConversationKeys.collection)
        .doc(message.conversationId);
    await conversationRef.set(
      <String, dynamic>{
        ConversationKeys.lastModified: message.createdAt.toIso8601String(),
      },
      SetOptions(
        merge: true,
      ),
    );
  }
}
