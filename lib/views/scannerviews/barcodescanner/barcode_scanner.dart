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
// class BarCodeScanner extends StatefulWidget {
//   // const BarCodeScanner({Key? key}) : super(key: key);
//   final Function(String? scannedresult) onEventNav;
//
// //final CameraController controller;
// //   const BarCodeScanner({super.key, required this.onEventNav,required this.controller});
//   const BarCodeScanner({super.key, required this.onEventNav});
//
//   @override
//   _BarCodeScannerState createState() => _BarCodeScannerState();
// }
//
// class _BarCodeScannerState extends State<BarCodeScanner> with WidgetsBindingObserver{
//     CameraController? controller;
//     bool controllerReady = false;
//     CodeScannerCameraListener? listener;
//   IconData flashicon = Icons.flash_off; //icon for lashlight button
//   Color flashbtncolor = Colors.deepOrangeAccent; //color for flash button
//   Timer? timer;
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//   String? scanResult; // = "";
//   bool flashStatus = false;
//     late List<CameraDescription> _cameras;
//   //late CodeScannerCameraListener listener;
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//
//     startCamController();
//
//   }
//     @override
//     void didChangeAppLifecycleState(AppLifecycleState state) {
//       final CameraController? cameraController = controller;
//
//       // App state changed before we got the chance to initialize.
//       if (cameraController == null || !cameraController.value.isInitialized) {
//         return;
//       }
//
//       if (state == AppLifecycleState.inactive) {
//         cameraController.dispose();
//       } else if (state == AppLifecycleState.resumed) {
//         //onNewCameraSelected(cameraController.description);
//       }
//     }
//
//
//   startCamController() async {
//
//
//     // _cameras = await availableCameras();
//
//     availableCameras().then((myCameras) {
//       _cameras = myCameras;
//       try{
//         initializeController();
//       }catch(e){
//         AppPops().showAlertOfTypeErrorWithDismiss('Exception at initializeController:\n$e');
//         Navigator.pop(context);
//       }
//
//     });
//  }
//   void initializeController(){
//     CommonMethods().showToast('Cameras${_cameras.length}');
//     print('Cameras${_cameras.length}');
//   //  final cam= _cameras[0];
//     controller = CameraController(_cameras.first, ResolutionPreset.max);
//    // CommonMethods().showToast('controller ${controller}');
//     //AppPops().showAlertOfTypeErrorWithDismiss('controller ${controller}');
//     print('controller ${controller}');
//     controller?.initialize().then((_) {
//       if (!mounted) {
//         CommonMethods().showToast('Unable to mount');
//         return;
//       }
//       listener = CodeScannerCameraListener(
//         controller!,
//
//         formats: const [ BarcodeFormat.all ],
//         interval: const Duration(milliseconds: 500),
//         once: false,
//
//         onScan: (code, details, controller) {
//           _callOnScan(code, details, controller);
//         },
//         //onScanAll: (codes, controller) => ...,
//       );
//       startTimer();
//       setState(() {controllerReady = true;});
//     }).catchError((Object e) {
//       if (e is CameraException) {
//         switch (e.code) {
//           case 'CameraAccessDenied':
//             CommonMethods().showToast('User denied camera access.');
//             break;
//           default:
//             CommonMethods().showToast('Handle other errors.');
//             break;
//         }
//       }
//       // CommonMethods().showToast('Unable to continue$e');
//       AppPops().showAlertOfTypeErrorWithDismiss('Exception at getCamController:\n$e');
//       Navigator.pop(context);
//     });
//   }
//
//   @override
//   void dispose() {
//     cancelTimer();
//
//    // CodeScannerCameraListener(controller!).dispose();
//     WidgetsBinding.instance.removeObserver(this);
//     //controller?.stopImageStream();
//     listener?.stop();
//     controller?.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return (!controllerReady)
//         ? CommonUtils().setProgessLoader(ProgressMessages.Loading)
//         :_buildCodeScannerCameraView();
//   }
//
//   _buildCodeScanner() {
//     //final ff =  BarcodeFormat.ean13;
//     return CodeScanner(
//      controller: controller,
//       overlay: _buildScannerOverLay(),
//       onScan: (code, details, controller) =>
//           _callOnScan(code, details, controller),
//       //onScanAll: (codes, controller) => CommonMethods().showToast('${'Codes: ' + codes.map((code) => code.rawValue).toString()}'),
//       formats: [BarcodeFormat.all],
//       once: true,
//     );
//   }
// _buildCodeScannerCameraView(){
//     return CodeScannerCameraView(
//       controller: controller!,
//       overlay: _buildScannerOverLay(),
//     );
// }
//   Future<void> toggleFlash(BuildContext context) async {
//     try {
//       if (flashStatus) {
//         controller?.setFlashMode(FlashMode.off);
//         setState(() {
//           flashStatus = false;
//         });
//       } else {
//         //CommonMethods().showToast('flash');
//         controller?.setFlashMode(FlashMode.torch);
//         setState(() {
//           flashStatus = true;
//         });
//       }
//     } on Exception catch (e) {
//       print(e);
//       CommonMethods().showToast(e.toString());
//       // _showErrorMes('Could not enable Flashlight', context);
//     }
//   }
//
//
//   // Future<void> onDispose() async {
//   //   try {
//   //     //final waitTodispose = await  widget.controller.dispose();
//   //     cancelTimer();
//   //
//   //   } catch (e) {
//   //     CommonMethods().printException(e);
//   //   }
//   // }
//
//   void _exit() {
//     cancelTimer();
//     Navigator.pop(context);
//     widget.onEventNav(scanResult);
//   }
//     _buildScannerOverLay(){
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
//                       toggleFlash(context);
//                     },
//                     child:
//                     (!flashStatus) ? Text('Flash On') : Text('Flash Off'),
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
//     }
//   void startTimer() {
//     timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
//       // CommonMethods().showToast('ick ${timer.tick}');
//       if (timer.tick == 10) {
//         CommonMethods().showToast('tick done}');
//         _exit();
//       }
//     });
//   }
//
//   void cancelTimer() {
//     timer?.cancel();
//   }
//
//   _callOnScan(
//       String? code, Barcode details, CodeScannerCameraListener controller) {
//     // CommonMethods().showToast('${'Codes: ' + code!} detail ${details.format}');
//     // controller.scanner.close();
//     scanResult = code;
//     _exit();
//   }
// }
