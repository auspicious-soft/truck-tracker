import 'dart:async';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';
import 'package:truck_tracker/utils/app_pops.dart';

import '../app_db/dbsharedpref/db_sharedpref.dart';
import '../routes/app_routes.dart';


class SplashScreenController extends GetxController {

  Future<void> goto() async {
    Timer(const Duration(seconds: 2), () {
      checkUserLocking();
 // checkIsUserLogged();
     // Get.offNamed(AppRoutes.login);
    });
  }
  void checkUserLocking() async {
    var signed =   await  DBSharedPref.instance.isUserSigned();
   // signed = false;
   // showToast('Mode rest $signed');
    if (signed == null || signed == false) {
      Get.offNamed(AppRoutes.login);
    } else {
      final user = FirebaseAuth.instance.currentUser;
      if(user == null){
        await FirebaseAuth.instance.signInAnonymously().then((value) {
          print("signInAnonymously Success ");
          Get.toNamed(AppRoutes.navboard, arguments: 1);
        }).onError((error, stackTrace) {
          AppPops().showAlertOfTypeErrorWithDismiss('Error while login in firebase\n$error');
         // print(" error signInAnonymously ${error.toString()} ");

        });

      }else{
        print("Anonymous user found ");
        Get.toNamed(AppRoutes.navboard, arguments: 1);
      }

  }
  }


  void showToast(String m) {
    Fluttertoast.showToast(msg: m);
  }
  void checkIsUserLogged() {
    var user = FirebaseAuth.instance.currentUser;
  // FirebaseAuth.instance.signOut();
    //Get.back();
   // SystemNavigator.pop();
   // Navigator.of(context).pop();
    //Navigator.of(context).pushNamed('/baseScreen');
    if (user == null) {
      Get.offNamed(AppRoutes.login);
     // Navigator.of(context).pushNamed('/firstScreen');
    } else {
     // Get.off(() => NavigationDashBoard());
      //Get.off(SplashScreen());
     Get.toNamed(AppRoutes.navboard, arguments: 1);

    //  Navigator.of(context).pushNamed('/baseScreen');
    }
  }
  @override
  void onInit() {
   goto();
    super.onInit();
  }
}
