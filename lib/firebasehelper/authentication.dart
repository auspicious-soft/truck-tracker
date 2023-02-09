import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../model/model_response.dart';

class AuthenticationHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  get user => _auth.currentUser;

  //SIGN UP METHOD
  Future signUp({required String email, required String password}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //SIGN IN METHOD
  Future<ModelResponse> signIn(
      {required String email, required String password}) async {
    print('ok');
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
/*User will be created at server so user directory will also be created there
Then here app will only update token in the user directory after login success.
* */
      // var isnew = userCredential.additionalUserInfo?.isNewUser;
      final userID = userCredential.user?.uid;
      var obj = ModelResponse(false, true, userID);
      if (userID != null) {
        return obj;
      }

      obj = ModelResponse(true, false, 'User id null');
      return obj;
    } on FirebaseAuthException catch (e) {
      final obj = ModelResponse(true, false, e.toString());
      return obj;
    }
  }

  //   onNewtoken({required Function tkn} )     {
  //
  //   Fluttertoast.showToast(msg: 'chk');
  //   FirebaseMessaging.instance.onTokenRefresh
  //       .listen((fcmToken) {
  //     Fluttertoast.showToast(msg: 'lsb $fcmToken');
  //     tkn(fcmToken);
  //     // Note: This callback is fired at each app startup and whenever a new
  //     // token is generated.
  //   })
  //       .onError((err) {
  //     Fluttertoast.showToast(msg: 'err $err');
  //     tkn('');
  //     // Error getting token.
  //   });
  // }

  Future<String?> getFCMToken() async {
  //  Fluttertoast.showToast(msg: 'chk');
    final fcmToken = await FirebaseMessaging.instance.getToken();
    return fcmToken;
  }

  //SIGN OUT METHOD
  Future signOut() async {
    await _auth.signOut();
    print('signout');
  }
}
