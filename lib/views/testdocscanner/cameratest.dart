// import 'package:camera/camera.dart';
//
// import 'package:flutter/material.dart';
//
// import '../../main.dart';
//
// class CameraPage extends StatefulWidget {
//   final int camID;
//   const CameraPage(
//       {Key? key, required this.camID}) : super(key:key);
//   @override
//   State<CameraPage> createState() => _CameraPageState();
// }
// class _CameraPageState extends State<CameraPage> {
//   late CameraController _cameraController;
//   Future initCamera(CameraDescription cameraDescription) async {
// // create a CameraController
//     _cameraController = CameraController(
//         cameraDescription, ResolutionPreset.high);
// // Next, initialize the controller. This returns a Future.
//     try {
//       await _cameraController.initialize().then((_) {
//         if (!mounted) return;
//         setState(() {});
//       });
//     } on CameraException catch (e) {
//       debugPrint("camera error $e");
//     }
//   }
//   @override
//   void initState() {
//     super.initState();
//     // initialize the rear camera
//     initCamera(cameras[widget.camID]);
//   }
//
//   @override
//   void dispose() {
//     // Dispose of the controller when the widget is disposed.
//     _cameraController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: SafeArea(
//             child: _cameraController.value.isInitialized
//                 ?Column(children: [
//                   Expanded(child: CameraPreview(_cameraController)),
//               Row(children: [
//                // TextButton(onPressed: oncam(0), child: Text('Cam 1')),
//                 // TextButton(onPressed: oncam(1), child: Text('Cam 2')),
//                 // TextButton(onPressed: oncam(2), child: Text('Cam 3')),
//                 // TextButton(onPressed: oncam(3), child: Text('Cam 4'))
//               ],)
//             ],)
//                 : const Center(child:
//             CircularProgressIndicator())));
//   }
//
//   oncam(int i) {
//     initCamera(cameras[i]);
//   }
// }