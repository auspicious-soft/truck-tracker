// import 'dart:async';
//
// import 'package:camera/camera.dart';
//
// import 'package:code_scan/code_scan.dart';
// import 'package:flutter/material.dart';
// import 'package:google_mlkit_barcode_scanning/src/barcode_scanner.dart';
//
// import 'package:truck_tracker/utils/common_methods.dart';
//
// import '../../../utils/app_pops.dart';
// import '../../../utils/common_widgets.dart';
// import '../../../utils/enumeration_mem.dart';
//
// class TempScanner extends StatefulWidget {
//   // const BarCodeScanner({Key? key}) : super(key: key);
//   final Function(String? scannedresult) onEventNav;
//
// //final CameraController controller;
// //   const BarCodeScanner({super.key, required this.onEventNav,required this.controller});
//   const TempScanner({super.key, required this.onEventNav});
//
//   @override
//   _TempScannerState createState() => _TempScannerState();
// }
//
// class _TempScannerState extends State<TempScanner> with WidgetsBindingObserver{
//
//   CodeScannerCameraListener? listener;
//
//   String? scanResult; // = "";
//
//   @override
//   void initState() {
//     super.initState();
//
//   }
//
//
//    void initializeController(){
//      // listener = CodeScannerCameraListener(
//      //
//      //
//      //   formats: const [ BarcodeFormat.all ],
//      //   interval: const Duration(milliseconds: 500),
//      //   once: false,
//      //
//      //   onScan: (code, details, controller) {
//      //     _callOnScan(code, details, controller);
//      //   },
//      //   //onScanAll: (codes, controller) => ...,
//      // );
//
//    }
//
//   @override
//   void dispose() {
//
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return _buildCodeScanner();
//   }
//
//   _buildCodeScanner() {
//     //final ff =  BarcodeFormat.ean13;
//     return CodeScanner(
//      // controller: controller,
//       overlay: _buildScannerOverLay(),
//       onScan: (code, details, controller) =>
//           _callOnScan(code, details, controller),
//       //onScanAll: (codes, controller) => CommonMethods().showToast('${'Codes: ' + codes.map((code) => code.rawValue).toString()}'),
//       formats: [BarcodeFormat.all],
//       once: true,
//     );
//   }
//
//
//
//
//   _buildScannerOverLay(){
//     return SizedBox(
//       child: Container(
//         child: Stack(
//           children: [
//             Center(
//               child: Container(
//                 height: MediaQuery.of(context).size.height * 0.40,
//                 width: MediaQuery.of(context).size.width * 0.80,
//                 decoration: BoxDecoration(
//                     border: Border.all(width: 1, color: Colors.deepOrange)),
//               ),
//             ),
//             Positioned(
//               bottom: 1,
//               left: 1,
//               right: 1,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   TextButton(
//                     onPressed: () {
//                      // toggleFlash(context);
//                     },
//                     child:
//                     Text('Flash On')
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       _exit();
//                       CommonMethods().showToast('exit');
//                     },
//                     child: Text('End'),
//                   )
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//
//   _callOnScan(
//       String? code, Barcode details, CodeScannerCameraListener controller) {
//     // CommonMethods().showToast('${'Codes: ' + code!} detail ${details.format}');
//     // controller.scanner.close();
//     scanResult = code;
//
//   }
//
//   void _exit() {
//     Navigator.pop(context);
//   }
// }
