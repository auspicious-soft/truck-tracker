// import 'dart:io';
//
// import 'dart:async';
// import 'dart:typed_data';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
// import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
//
//
// //import 'package:cunning_document_scanner/cunning_document_scanner.dart';
// //import 'package:cuervo_document_scanner/cuervo_document_scanner.dart';
// // import 'package:document_scanner_flutter/configs/configs.dart';
// // import 'package:document_scanner_flutter/document_scanner_flutter.dart';
// // import 'package:blinkid_flutter/microblink_scanner.dart';
// // import 'package:blinkid_flutter/overlay_settings.dart';
// // import 'package:blinkid_flutter/recognizer.dart';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_camera_overlay/flutter_camera_overlay.dart';
// import 'package:flutter_camera_overlay/model.dart';
// import 'package:image_picker/image_picker.dart';
// //import 'package:flutter_document_scanner/flutter_document_scanner.dart';
// //import 'package:document_scanner/document_scanner.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:truck_tracker/utils/common_methods.dart';
//
// import '../vision_detector_views/bar_code_scan_view.dart';
//
// class BlinkScanner extends StatefulWidget {
//   final Function(File? moveTo  ) onEventNav;
//   BlinkScanner({super.key, required this.onEventNav});
//   @override
//   _BlinkScannerrState createState() => _BlinkScannerrState();
// }
//
// class _BlinkScannerrState extends State<BlinkScanner> {
//
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Flutter Firebase ML'),
//         ),
//         body: Container(
//           width: double.infinity,
//           padding: EdgeInsets.symmetric(vertical: 50),
// child:   Padding(
//   padding: const EdgeInsets.all(8.0),
//   child:   CustomCard('Tap to Scan', BarcodeScannerView()),
// ),
//         ),
//       ),
//     );
//   }
//
//   //:::::::::::::::::::BLINK SCANNER
// // String license = 'sRwAAAAcY29tLmVsdWxhb25saW5lLnRydWNrZXJ0cmFja5CGkNgj7pZ3rxI1qmDvZJ5551tUj6EJneFggf/qexL6HcfA/F2QMGSbIfHP6RUycTggj3rXqnFUGm7hpsh0nl1tRPjjmOm876vklX27oEDaWn3c4/EpbYjTlosUCgDlCj9L4aa2YbX5IFd2psRM4g8BBazMkoPjNPM/qpcf0eyZnb1SCq+D/L0IGPY5IcehJ94Rz7NQrKiSlyCu+oDmrcuO2Y2P1qwjxp4ikTMsGHWh';
// // String result = '';
// // //CardOverlay(ratio: 0.5,cornerRadius: 0.00,orientation: OverlayOrientation.portrait);
// //   final customOverlay = CardOverlay(ratio: 0.0,cornerRadius: 0.00,orientation: OverlayOrientation.portrait);
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //         home: Scaffold(
// //
// //           backgroundColor: Colors.white,
// //           body:Container(child: Column(children: [
// //             Text('SCAN RESULT:$result'),
// //             SizedBox(height: 50,),
// //             TextButton(onPressed:scanNow,child:Text('Scan'))
// //
// //           ],),),
// //         ));
// //   }
// //   Future<void>  scanNow()  async {
// //     List<RecognizerResult> results;
// //
// //     Recognizer recognizer = BlinkIdCombinedRecognizer();
// //     OverlaySettings settings = BlinkIdOverlaySettings();
// //
// //     // set your license
// //     // if (Theme.of(context).platform == TargetPlatform.iOS) {
// //     //   license = "";
// //     // } else if (Theme.of(context).platform == TargetPlatform.android) {
// //     //   license = "";
// //     // }
// //
// //     try {
// //       // perform scan and gather results
// //       results = await MicroblinkScanner.scanWithCamera(RecognizerCollection([recognizer]), settings, license);
// //       results.forEach((results) {
// //         final name =  results.resultState.name;
// //         setState(() {
// //           result = result + '\n' + name;
// //         });
// //
// //       });
// //
// //     } on PlatformException {
// //       // handle exception
// //     }
// // }
// }
//
// class CustomCard extends StatelessWidget {
//   final String _label;
//   final Widget _viewPage;
//   final bool featureCompleted;
//
//   const CustomCard(this._label, this._viewPage, {this.featureCompleted = true});
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 5,
//       margin: EdgeInsets.only(bottom: 10),
//       child: ListTile(
//         tileColor: Theme.of(context).primaryColor,
//         title: Text(
//           _label,
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         onTap: () {
//           if (!featureCompleted) {
//             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                 content:
//                 const Text('This feature has not been implemented yet')));
//           } else {
//             Navigator.push(
//                 context, MaterialPageRoute(builder: (context) => _viewPage));
//           }
//         },
//       ),
//     );
//   }
// }
//
//
