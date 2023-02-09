// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
//
//
//   showAlert(dynamic msg,BuildContext? context) {
//     if(context == null){
//       Fluttertoast.showToast(msg: 'no context available');
//       return null;
//     }
//    showDialog(
//       context: context,
//       builder: (context) {
//         AlertDialog(
//           title: const Text('Alert'),
//           content: Text('$msg'),
//           actions: <Widget>[
//             ElevatedButton(
//               onPressed: () {
//                  Navigator.of(context).pop();
//               },
//               child: Text('dismiss'),
//             ),
//
//           ],
//         );
//         throw{
// // unused return value to throw
//         };
//       },
//
//   );
//
// }
// //
// //
// //    exitApp(BuildContext context) {
// //   return showDialog(
// //     context: context,
// //      builder:  AlertDialog(
// //       title: Text('Do you want to exit this application?'),
// //       content: Text('We hate to see you leave...'),
// //       actions: <Widget>[
// //         ElevatedButton(
// //           onPressed: () {
// //             print("you choose no");
// //             Navigator.of(context).pop(false);
// //           },
// //           child: Text('No'),
// //         ),
// //         ElevatedButton(
// //           onPressed: () {
// //             SystemChannels.platform.invokeMethod('SystemNavigator.pop');
// //           },
// //           child: Text('Yes'),
// //         ),
// //       ],
// //     ), builder: (BuildContext context) {  },
// //   ) ??
// //       false;
// // }