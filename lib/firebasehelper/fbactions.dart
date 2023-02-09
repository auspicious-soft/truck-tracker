import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../model/model_response.dart';
import 'authentication.dart';

enum enumDBuser { docid, id, email, token }

class FireStoreDB {
  //CONFIG
  final FirebaseAuth _auth = FirebaseAuth.instance;

  get user => _auth.currentUser;

  get _dirUser => 'users';
  final _db = FirebaseFirestore.instance;

  //DB REF
  updateTokenInUserDirectory(String docID,
      {required Function onupdation}) async {
    //GET FCM TOKEN
    final fcm = await AuthenticationHelper().getFCMToken();
    if (fcm != null) {
      final updatedData = <String, dynamic>{
        enumDBuser.token.name: fcm,
      };
      //  dataRow.addEntries([MapEntry('docid', docId)]);
      var docRef = _db.collection(_dirUser).doc(docID);
      docRef.update(updatedData).then((value) {
        Fluttertoast.showToast(msg: 'FCM Updated');
        onupdation(true);
      })
      .onError((error, stackTrace){
        Fluttertoast.showToast(msg: 'Error $error');
        onupdation(false);
      });
    } else {
      Fluttertoast.showToast(msg: 'FCM Error');
      onupdation(false);
    }
  }

  //SIGN UP METHOD
  Future addNewUser(Map<String, dynamic> userData, String docId) async {
    try {
      // String docId = _db.collection(_collectionRef).doc().id;
      // dataRow.addEntries([MapEntry(enumDBuser.docid.name, docId)]);

      var docRef = _db.collection(_dirUser).doc(docId);
      docRef.set(userData).then((value) =>
          Fluttertoast.showToast(msg: 'User added to the directory'));
      return true;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  String getPreDocID() {
    String docId = _db.collection(_dirUser).doc().id;
    return docId;
  }

  Future<void> setFCM(String docID) async {
    //GET FCM TOKEN
    final fcm = await AuthenticationHelper().getFCMToken();
    if (fcm != null) {
      final updatedData = <String, dynamic>{
        enumDBuser.token.name: fcm,
      };
      //  dataRow.addEntries([MapEntry('docid', docId)]);
      var docRef = _db.collection(_dirUser).doc(docID);
      docRef
          .update(updatedData)
          .then((value) => Fluttertoast.showToast(msg: 'updated token'));
      // Fluttertoast.showToast(msg: 'fetch $fcm');
      // print(fcm);
    }
  }

  Future<String?> getFCMToken() async {
    Fluttertoast.showToast(msg: 'chk');
    final fcmToken = await FirebaseMessaging.instance.getToken();
    return fcmToken;
  }

  //SIGN OUT METHOD
  Future signOut() async {
    await _auth.signOut();
    print('signout');
  }
}
