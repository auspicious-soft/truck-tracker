import 'package:firebase_messaging/firebase_messaging.dart';


class PushNotificationsManager {

  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance = PushNotificationsManager._();

  late FirebaseMessaging _firebaseMessaging;
  //final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _initialized = false;

  Future<void> init() async {
    if (!_initialized) {
      _firebaseMessaging = FirebaseMessaging.instance;
      // For iOS request permission first.
      _firebaseMessaging.requestPermission();
    //  _firebaseMessaging.configure();
      String? token = '';
      // For testing purposes print the Firebase Messaging token
      _firebaseMessaging.getToken().then((value){
        print(value);
        token = value;
      });
     // String? token = await _firebaseMessaging.getAPNSToken();
      print("FirebaseMessaging token: $token");

      _initialized = true;
    }
  }
}