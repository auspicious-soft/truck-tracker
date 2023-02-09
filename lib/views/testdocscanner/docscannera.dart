// import 'dart:io';
// import 'dart:typed_data';
//
// //import 'package:cunning_document_scanner/cunning_document_scanner.dart';
// //import 'package:cuervo_document_scanner/cuervo_document_scanner.dart';
// // import 'package:document_scanner_flutter/configs/configs.dart';
// // import 'package:document_scanner_flutter/document_scanner_flutter.dart';
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
// class DocScanner extends StatefulWidget {
//   final Function(File? moveTo  ) onEventNav;
//   DocScanner({super.key, required this.onEventNav});
//   @override
//   _DocScannerState createState() => _DocScannerState();
// }
//
// class _DocScannerState extends State<DocScanner> {
//   OverlayFormat format = OverlayFormat.cardID1;
//   int tab = 0;
// //CardOverlay(ratio: 0.5,cornerRadius: 0.00,orientation: OverlayOrientation.portrait);
//   final customOverlay = CardOverlay(ratio: 0.0,cornerRadius: 0.00,orientation: OverlayOrientation.portrait);
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         home: Scaffold(
//           bottomSheet: Container(child:Text( 'Position your Document card within the rectangle and ensure the image is perfectly readable.') ,),
//           // bottomNavigationBar: BottomNavigationBar(
//           //   currentIndex: tab,
//           //   onTap: (value) {
//           //     setState(() {
//           //       tab = value;
//           //     });
//           //     switch (value) {
//           //       case (0):
//           //         setState(() {
//           //           format = OverlayFormat.cardID1;
//           //         });
//           //         break;
//           //       case (1):
//           //         setState(() {
//           //           format = OverlayFormat.cardID3;
//           //         });
//           //         break;
//           //       case (2):
//           //         setState(() {
//           //           format = OverlayFormat.simID000;
//           //         });
//           //         break;
//           //     }
//           //   },
//           //   items: const [
//           //     BottomNavigationBarItem(
//           //       icon: Icon(Icons.credit_card),
//           //       label: 'Bankcard',
//           //     ),
//           //     BottomNavigationBarItem(
//           //         icon: Icon(Icons.contact_mail), label: 'US ID'),
//           //     BottomNavigationBarItem(icon: Icon(Icons.sim_card), label: 'Sim'),
//           //   ],
//           // ),
//           backgroundColor: Colors.white,
//           body: FutureBuilder<List<CameraDescription>?>(
//             future: availableCameras(),
//             builder: (context, snapshot) {
//               if (snapshot.hasData) {
//                 if (snapshot.data == null) {
//                   return const Align(
//                       alignment: Alignment.center,
//                       child: Text(
//                         'No camera found',
//                         style: TextStyle(color: Colors.black),
//                       ));
//                 }
//                 return CameraOverlay(
//                     snapshot.data!.first,
//                     CardOverlay(ratio: 0.6, cornerRadius: 0.01),
//                         (XFile file) => showDialog(
//                       context: context,
//                       barrierColor: Colors.black,
//                       builder: (context) {
//                         CardOverlay overlay = CardOverlay(ratio: 0.8, cornerRadius: 0.01,orientation: OverlayOrientation.portrait);
//                         return AlertDialog(
//                             actionsAlignment: MainAxisAlignment.center,
//                             backgroundColor: Colors.black,
//                             title: const Text('Capture',
//                                 style: TextStyle(color: Colors.white),
//                                 textAlign: TextAlign.center),
//                             actions: [
//                               OutlinedButton(
//                                   onPressed: () => Navigator.of(context).pop(),
//                                   child: const Icon(Icons.close))
//                             ],
//                             content: SizedBox(
//                                 width: double.infinity,
//                                 child: AspectRatio(
//                                   aspectRatio: overlay.ratio!,
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                         image: DecorationImage(
//                                           fit: BoxFit.fitWidth,
//                                           alignment: FractionalOffset.center,
//                                           image: FileImage(
//                                             File(file.path),
//                                           ),
//                                         )),
//                                   ),
//                                 )));
//                       },
//                     ),
//                     info:
//                     '',
//                     label: 'Scanning Document');
//               } else {
//                 return const Align(
//                     alignment: Alignment.center,
//                     child: Text(
//                       'Fetching cameras',
//                       style: TextStyle(color: Colors.black),
//                     ));
//               }
//             },
//           ),
//         ));
//   }
//
// }