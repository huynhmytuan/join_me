import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MessageRepository {
  MessageRepository({
    FirebaseFirestore? firebaseFirestore,
    FirebaseStorage? firebaseStorage,
  })  : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance;

  final FirebaseFirestore _firebaseFirestore;
  final FirebaseStorage _firebaseStorage;
}
