// import 'dart:typed_data';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_zxing/flutter_zxing.dart';
//
// class ZingScanner extends StatefulWidget {
//   const ZingScanner({Key? key}) : super(key: key);
//
//   @override
//   State<ZingScanner> createState() => _ZingScannerState();
// }
//
// class _ZingScannerState extends State<ZingScanner> {
//   Uint8List? createdCodeBytes;
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Flutter Zxing Example'),
//           bottom: const TabBar(
//             tabs: [
//               Tab(text: 'Scan Code'),
//               Tab(text: 'Create Code'),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           physics: const NeverScrollableScrollPhysics(),
//           children: [
//             ReaderWidget(
//               codeFormat: Format.PDF417,
//               onScan: (value) {
//                 showMessage(context, 'Scanned: ${value.textString ?? ''}');
//               },
//             ),
//             ListView(
//               children: [
//                 WriterWidget(
//                   messages: const Messages(
//                     createButton: 'Create Code',
//                   ),
//                   onSuccess: (result, bytes) {
//                     setState(() {
//                       createdCodeBytes = bytes;
//                     });
//                   },
//                   onError: (error) {
//                     showMessage(context, 'Error: $error');
//                   },
//                 ),
//                 if (createdCodeBytes != null)
//                   Image.memory(createdCodeBytes ?? Uint8List(0), height: 200),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   showMessage(BuildContext context, String message) {
//     debugPrint(message);
//     ScaffoldMessenger.of(context).hideCurrentSnackBar();
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//       ),
//     );
//   }
// }