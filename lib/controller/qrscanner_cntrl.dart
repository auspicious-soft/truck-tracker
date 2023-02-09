// import 'package:flutter/material.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
//
// import '../model/model_license_data.dart';
// import '../model/model_vehicle_license.dart';
//
// class QRScannerController extends GetxController {
//   @override
//   void onInit() {
//     super.onInit();
//     Fluttertoast.showToast(msg: 'CheckInActivated..');
//   }
//
//   Future<void> scanVehicleLicense({required Function function}) async {
//     // Fluttertoast.showToast(msg: 'jjh');
//     try {
//       String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
//           "#ff6666", "Cancel", true, ScanMode.QR);
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
//   void analyseVehicleLicense(BuildContext context, String vehicleLicense,
//       {required Function(ModelLicenseData? vehData) onCompletion}) {
//     try {
//       var data = vehicleLicense
//           .split('%') // split the text into an array
//           .map((String text) => text) // put the text inside a widget
//           .toList();
//
//       //  print('$data');
//       data.removeAt(0);
//       //  showSimpleAlert(data.toString(),context);
//       // Fluttertoast.showToast(msg:'Invalid QRCode ${data.length}');
//       if (data.length < 10) {
//         Fluttertoast.showToast(msg: 'Invalid QRCode ${data.length}');
//         onCompletion(null);
//       } else {
//         final number = data[4];
//         final licenseNo = data[5].toString();
//         final vehRegNo = data[6].toString();
//         final vin = data[11].toString();
//         final engineno = data[12].toString();
//         final make = data[8].toString();
//         final description = data[7].toString();
//         final expirydate = data[13].toString();
//         final obj = ModelLicenseData(number, licenseNo, vehRegNo, vin, engineno,
//             '', '', '', make, description, '', '', '', expirydate);
//
//         onCompletion(obj);
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: 'getting crash $e ');
//       onCompletion(null);
//     }
//   }
// }
