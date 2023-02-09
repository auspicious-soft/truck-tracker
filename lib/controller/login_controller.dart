import 'dart:async';
import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../apis/api_constants.dart';
import '../apis/body_maker.dart';
import '../apis/data_class.dart';
import '../apis/network_util.dart';
import '../app_db/dbsharedpref/db_sharedpref.dart';
import '../firebasehelper/authentication.dart';
import '../firebasehelper/fbactions.dart';

import '../model/model_user.dart';
import '../routes/app_routes.dart';

import '../views/pops/progress.dart';

class LoginController extends GetxController {
  String email = "";
  String password = "";
  RxBool passwordBool = false.obs;
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? handleEmail(String value) {
    if (EmailValidator.validate(value)) {
      email = value;
      return null;
    }
    return "Please Enter Valid Email";
  }

  String? handlePassword(String value) {
    if (value.length >= 6) {
      password = value;

      return null;
    }
    return "Password should be more than 6 digits";
  }

  Future<void> submitEmail() async {
    if (formKey.currentState!.validate()) {
      // Get.toNamed(AppRoutes.emailVerified);
      // await forgotPassword();
      // Navigator.pushNamed(context, MyRoutes.otpPage);
    }
  }

  void loginToFireBase(BuildContext context) async {
    // ConnectivityTracker connectivityTracker = ConnectivityTracker();
    bool ntwork = await NetworkUtil().checkInternet();
    if (ntwork) {
      if (formKey.currentState!.validate()) {
        showProgress(context);
        AuthenticationHelper()
            .signIn(email: email, password: password)
            .then((result) {
          if (result.flagSuccess) {
            //update token
            FireStoreDB().updateTokenInUserDirectory(result.data,
                onupdation: (onupdation) {
              Navigator.pop(context);
              if (onupdation) {
                //  goToHome();
              }
              //updation failed
              //reason first no user created in the firestore please contact to the server backed
              //some exceptions
            });
          } else {
            Navigator.pop(context);
            //show msg
            Get.snackbar(
              "Error",
              result.data,
              icon: const Icon(Icons.person, color: Colors.black),
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        });
      }
    }
  }

  // Future<void> addNewUser() async {
  //   Fluttertoast.showToast(msg: 'FCM');
  //   final token = await  FireStoreDB().getFCMToken();
  //   final docid = FireStoreDB().getPreDocID();
  //   final userRow = <String, dynamic>{
  //     enumDBuser.id.name:'',
  //     enumDBuser.docid.name:docid,
  //     enumDBuser.email.name:'',
  //     enumDBuser.token.name:token
  //   };
  //   FireStoreDB().addNewUser(userRow,docid);
  //   goToHome();
  // }
//   void createOrUpdateUserData(userID) async {
//     // showToast("hiiii");
//     // var  user = await FirebaseAuth.instance.currentUser!;
//     var db = FirebaseFirestore.instance;
//
// // Create a new user with a first and last name
//   //  final uData = modelUserData;
//     final userRow = <String, dynamic>{
//       'id': userID,
//       'email': email,
//      'token': ''
//     };
//
// // Add a new document with a generated ID
//     db.collection("users").add(userRow).then((DocumentReference doc) =>
//        goToHome());
//     // final id = await dbhelper.insert(userRow);
//     // Fluttertoast.showToast(msg: 'row val $id');
//     // saveInLocalDB(userRow);
//     // Navigator.of(context).pop();
//     // Navigator.of(context).pushNamed('/baseScreen');
//   }

  goToHome(ModelUser userData) {
    //
    // Fluttertoast.showToast(msg: 'Login Successfully!');
    DBSharedPref.instance.lockuser(userData);
    Get.toNamed(AppRoutes.navboard, arguments: 1);
  }

  void signIn(BuildContext context) async {
    // ConnectivityTracker _connectivityTracker = ConnectivityTracker();
    // bool ntwork =  await    ConnectivityTracker().checkinternet();
    // if(ntwork){
    if (formKey.currentState!.validate()) {
      // ModelSignIn signInBody =
      //     ModelSignIn(username: email, password: password, devicename: 'test');
      final signInBody  = BodyMaker().bodyOfLogin(email, password);
      var provider = Provider.of<DataClass>(context, listen: false);
      await provider.postData(POSTEndPoints.login, signInBody,convertToJson: true);
      if (provider.isSuccess) {
        parseLoginResponse(provider.responseData);
      }

      // showProgress(context);
      // Network().login(function: (){
      //   Navigator.pop(context);
      //
      // });
    }

    // }
  }

  void parseLoginResponse(http.Response? response) {
    // {"message":"The device name field is required.","errors":{"device_name":["The device name field is required."]}}

    try {
      final jsonData = response?.body;
      print('login data ${jsonData}');
      final parsedJson = jsonDecode(jsonData!);
      final parsedData = ModelUser.fromJson(parsedJson);
      Fluttertoast.showToast(msg: parsedData.token);
      Fluttertoast.showToast(msg: 'Login success');
      goToHome(parsedData);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Received Error while parsing...');
    }
  }
}
