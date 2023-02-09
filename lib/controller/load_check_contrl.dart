// import 'package:flutter/material.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
//
// import '../views/pops/progress.dart';
//
// class LoadCheckINController extends GetxController {
//   // @override
//   // void onInit() {
//   //   // AppStrings.userType = "2";
//   //     Fluttertoast.showToast(msg:'testing..');
//   //   final modeType = Get.arguments as int;
//   //   // Fluttertoast.showToast(msg:'$modeType');
//   //   if(modeType == 0){
//   //     //add details
//   //     modeToAddData = true;
//   //   }else{
//   //     //checkin
//   //     modeToAddData = false;
//   //   }
//   //   super.onInit();
//   // }
//   Future<void> scanVehicleLicense({required Function function}) async {
//     // Fluttertoast.showToast(msg: 'jjh');
//     try {
//       String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
//           "#ff6666", "Cancel", false, ScanMode.QR);
//
//       if (barcodeScanRes.isNotEmpty) {
//         if (barcodeScanRes.length > 3) {
//           function(barcodeScanRes.toString());
//           //  Fluttertoast.showToast(msg: barcodeScanRes.toString());
//           //  processCasseteeID(barcodeScanRes);
//         } else {
//           // Fluttertoast.showToast(msg: barcodeScanRes);
//         }
//       }
//     } catch (e) {
//       //Fluttertoast.showToast(msg: e.toString());
//     }
//   }
//
//   Future<bool> onWillPop() {
//     return Future.value(true);
//     // DateTime now = DateTime.now();
//     // if (currentBackPressTime == null ||
//     //     now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
//     //   currentBackPressTime = now;
//     //   Get.snackbar(
//     //     "",
//     //     "Please Press Again To Exit App",
//     //     icon: const Icon(Icons.person, color: Colors.white),
//     //     snackPosition: SnackPosition.BOTTOM,
//     //   );
//     //   return Future.value(false);
//     // }
//     // return Future.value(true);
//   }
//
//   Future<Position> _determinePosition(BuildContext context) async {
//     bool serviceEnabled;
//     LocationPermission permission;
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       Fluttertoast.showToast(msg: 'Please enable location');
//       Geolocator.openLocationSettings();
//
//       return Future.error('Location services are disabled.');
//     }
//
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         // Permissions are denied, next time you could try
//         // requesting permissions again (this is also where
//         // Android's shouldShowRequestPermissionRationale
//         // returned true. According to Android guidelines
//         // your App should show an explanatory UI now.
//         Fluttertoast.showToast(msg: 'Location permissions are denied');
//         return Future.error('Location permissions are denied');
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       Fluttertoast.showToast(
//           msg:
//               'Location permissions are permanently denied, we cannot request permissions.');
//       // Permissions are denied forever, handle appropriately.
//       return Future.error(
//           'Location permissions are permanently denied, we cannot request permissions.');
//     }
//
//     // When we reach here, permissions are granted and we can
//     // continue accessing the position of the device.
//     showProgress(context);
//     return await Geolocator.getCurrentPosition();
//   }
// }
