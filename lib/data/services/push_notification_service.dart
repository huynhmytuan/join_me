import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  PushNotificationService({FirebaseMessaging? firebaseMessaging})
      : _firebaseMessaging = firebaseMessaging ?? FirebaseMessaging.instance;

  final FirebaseMessaging _firebaseMessaging;
  Future<void> initialize() async {
    await _firebaseMessaging.requestPermission();
  }

  Future<String?> getToken() {
    return _firebaseMessaging.getToken();
  }
}
