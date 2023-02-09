// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:truck_tracker/controller/qrscanner_cntrl.dart';
// import 'package:truck_tracker/model/model_vehicle_license.dart';
// import 'package:truck_tracker/utils/app_colors.dart';
// import 'package:truck_tracker/utils/common_widgets.dart';
//
// import '../utils/app_screens.dart';
// import '../utils/image_paths.dart';
//
// class QRScanner extends StatelessWidget {
//   // LoadCheckIn(this.userMode, {super.key,});
//   // const QRScanner({Key? key}) : super(key: key);
//   final Function(AppScreens? moveTo, VehicleLicense vehLicData) onEventNav;
//
//   QRScanner({super.key, required this.onEventNav});
//
//   // QRScanner({Key? key, required this.modeToAddData}) : super(key: key);
//
// //   @override
// //   State<QRScanner> createState() => _QRScannerState();
// // }
// //
// // class _QRScannerState extends State<QRScanner> {
//   // _QRScannerState();
//
//   final QRScannerController _controller = QRScannerController();
//   String vehicleQRTag = 'QR details show here';
//   String title = 'Adding new load';
//   bool modeToAddData = false;
//   bool showScanQRCode = false;
//   String vehicleLicenseCode = '';
//   String qrCodeTitle = 'Scan Vehicle';
//
//   // @override
//   // void initState() {
//   //   showFirstView();
//   //   super.initState();
//   //   // subscribeToMessages();
//   // }
//
//   //final NavHomeController _controller = Get.find();
//   //final NavHomeController _controller = Get.find();
//   final space = const SizedBox(
//     height: 10,
//   );
//   bool showSubmitView = false;
//
//   VehicleLicense? vehData;
//   VehicleLicense? vehQRData;
//
//   get vehicleLicenseData => null;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//           child: Align(
//         alignment: Alignment.center,
//         child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
//           space,
//           CommonUtils().setHeader(qrCodeTitle),
//           space,
//           InkWell(
//             onTap: () {
//               // Get.toNamed(AppRoutes.vehscandetails, arguments: transferMap);
//               _controller.scanVehicleLicense(function: (scannedData) {
//                 print(scannedData);
//                 Fluttertoast.showToast(msg: scannedData);
//                 _controller.analyseVehicleLicense(context, scannedData,
//                     onCompletion: (vhData) {
//                   if (vhData != null) {
//                     //vehData = vhData;
//                     //Fluttertoast.showToast(msg: 'msg ${vehData?.licenseno}');
//                     onEventNav(AppScreens.VehDetails, vhData);
//                   }
//                   // if (!showScanQRCode) {
//                   //   if (vhData != null) {
//                   //     vehData = vhData;
//                   //     showScanQRCode = true;
//                   //     title = 'Scan QR Code';
//                   //     qrCodeTitle = 'Scan QR tag';
//                   //     vehicleLicenseCode = scannedData;
//                   //   }else{
//                   //     Fluttertoast.showToast(msg: 'Invalid QR');
//                   //   }
//                   // } else {
//                   //   if (vhData != null) {
//                   //     vehQRData = vhData;
//                   //     _controller.moveToSubmitView(
//                   //         modeToAddData, vehData!, vehData!);
//                   //   }else{
//                   //     Fluttertoast.showToast(msg: 'Invalid QR');
//                   //   }
//                   // }
//                 });
//               });
//             },
//             child: Container(
//               width: 200,
//               height: 200,
//               // margin: const EdgeInsets.all( 20),
//               color: AppColors.base,
//               child: Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Image.asset(
//                   ImagePaths.qrscan,
//                 ),
//               ),
//             ),
//           ),
//         ]),
//       )),
//     );
//   }
//
//   // void showFirstView() {
//   //   final modeType = Get.arguments as int;
//   //   // Fluttertoast.showToast(msg:'$modeType');
//   //   if (modeType == 0) {
//   //     //add details
//   //     setState(() {
//   //       modeToAddData = true;
//   //       showScanQRCode = false;
//   //       title = 'Adding new load';
//   //       qrCodeTitle = 'Scan Vehicle license';
//   //     });
//   //   } else {
//   //     //checkin
//   //     setState(() {
//   //       modeToAddData = false;
//   //       showScanQRCode = false;
//   //       title = 'Check in';
//   //     });
//   //   }
//   // }
//
//   void showSecondView() {
//     modeToAddData = true;
//     showScanQRCode = false;
//     title = 'Scan QR Code';
//     qrCodeTitle = 'ScanQR tag';
//   }
//
//   VehicleLicense? analyseLicenseData(scannedData) {
//     if (scannedData.isBlank) {
//       Fluttertoast.showToast(msg: 'No data');
//       return null;
//     } else {
//       final data = scannedData as String;
//       final licenseData = data
//           .split('%') // split the text into an array
//           .map((String text) => Text(text)) // put the text inside a widget
//           .toList();
//
//       if (licenseData.contains('')) {}
//     }
//     return null;
//   }
// }
