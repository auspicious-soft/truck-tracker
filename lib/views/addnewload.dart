// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:truck_tracker/utils/common_widgets.dart';
// import 'package:velocity_x/velocity_x.dart';
// import '../controller/load_check_contrl.dart';
// import '../utils/app_colors.dart';
// import '../utils/image_paths.dart';
// import '../utils/sizes_config.dart';
// import 'pops/pop_flagged.dart';
//
// class AddNewLoad extends StatefulWidget {
//   // LoadCheckIn(this.userMode, {super.key,});
//   AddNewLoad({Key? key, required this.modeToAddData}) : super(key: key);
//   bool modeToAddData;
//
//   @override
//   State<AddNewLoad> createState() => _AddNewLoadState();
// }
//
// class _AddNewLoadState extends State<AddNewLoad> {
//   _AddNewLoadState();
//
//   final LoadCheckINController _controller = LoadCheckINController();
//   String qrcode = 'QR details show here';
//   String title = 'Adding new load';
//   bool modeToAddData = false;
//
//   @override
//   void initState() {
//     final modeType = Get.arguments as int;
//     // Fluttertoast.showToast(msg:'$modeType');
//     if (modeType == 0) {
//       //add details
//       modeToAddData = true;
//     } else {
//       //checkin
//       modeToAddData = false;
//       qrcode = 'QR details show here';
//       title = 'Check in';
//     }
//
//     super.initState();
//     // subscribeToMessages();
//   }
//
//   //final NavHomeController _controller = Get.find();
//   //final NavHomeController _controller = Get.find();
//   final space = SizedBox(
//     height: 30,
//   );
//   bool showSubmitView = false;
//   final spaceb = SizedBox(
//     height: 40,
//   );
//
//   // @override
//   // Widget build(BuildContext context) {
//   //   return Scaffold(
//   //     appBar: AppBar(
//   //       backgroundColor: Colors.white,
//   //       title: title.text.semiBold.size(17).color(AppColors.black).make(),
//   //       leading: IconButton(
//   //         onPressed: () {
//   //           Navigator.pop(context);
//   //         },
//   //         icon: Icon(
//   //           Icons.arrow_back,
//   //           color: AppColors.black,
//   //         ),
//   //       ),
//   //     ),
//   //     backgroundColor: Colors.white,
//   //     body: SafeArea(
//   //       child: Padding(
//   //         padding: const EdgeInsets.all(30.0),
//   //         child: (!showSubmitView)
//   //             ? Center(
//   //                 child: Column(
//   //                     crossAxisAlignment: CrossAxisAlignment.center,
//   //                     children: [
//   //                       space,
//   //                       space,
//   //                       GestureDetector(
//   //                           onTap: () {
//   //                             print('welcome');
//   //                             // Fluttertoast.showToast(msg: 'fdgdgdg');
//   //                             _controller.scanVehicleLicense(
//   //                                 function: (scannedData) {
//   //                               //Fluttertoast.showToast(msg: scannedData);
//   //                               setState(() {
//   //                                 showSubmitView = true;
//   //                                 qrcode = scannedData;
//   //                               });
//   //                             });
//   //                           },
//   //                           child: Column(
//   //                             children: [
//   //                               Image.asset(
//   //                                 ImagePaths.qrscan,
//   //                                 width: AppSizes.w * 35,
//   //                               ),
//   //                               spaceb,
//   //                               'Scan vehicle license'
//   //                                   .text
//   //                                   .size(AppSizes.basetext)
//   //                                   .semiBold
//   //                                   .make(),
//   //                             ],
//   //                           )),
//   //                       space,
//   //                       space,
//   //                       GestureDetector(
//   //                           onTap: () {
//   //                             print('welcome');
//   //                             // Fluttertoast.showToast(msg: 'fdgdgdg');
//   //                             _controller.scanVehicleLicense(
//   //                                 function: (scannedData) {
//   //                               //Fluttertoast.showToast(msg: scannedData);
//   //                               setState(() {
//   //                                 showSubmitView = true;
//   //                                 qrcode = scannedData;
//   //                               });
//   //                             });
//   //                           },
//   //                           child: Column(
//   //                             children: [
//   //                               Image.asset(
//   //                                 ImagePaths.qrscan,
//   //                                 width: AppSizes.w * 35,
//   //                               ),
//   //                               spaceb,
//   //                               'Scan QR tag'
//   //                                   .text
//   //                                   .size(AppSizes.basetext)
//   //                                   .semiBold
//   //                                   .make()
//   //                             ],
//   //                           )),
//   //                     ]),
//   //               )
//   //             : _buildVehicleDetailView(),
//   //       ),
//   //     ),
//   //   );
//   // }
//
//   // _buildVehicleDetailView() {
//   //   return Center(
//   //     child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
//   //       'Vehicle details shown here'
//   //           .text
//   //           .semiBold
//   //           .size(AppSizes.basetext)
//   //           .make(),
//   //       space,
//   //       space,
//   //       spaceb,
//   //       'Qr Tag: $qrcode'.text.size(AppSizes.basetext).semiBold.make(),
//   //       space,
//   //       space,
//   //       spaceb,
//   //       CommonUtils.baseButton(
//   //           title: 'Submit',
//   //           function: () {
//   //             _controller.checkScannedCodePresense(qrcode,
//   //                 function: (isQrPresent) {
//   //               //  Fluttertoast.showToast(msg: '$modeToAddData');
//   //               if (modeToAddData) {
//   //                 //if user wants to add data
//   //                 //check isqralready present?
//   //                 if (isQrPresent) {
//   //                   Fluttertoast.showToast(msg: 'Data already present');
//   //                 } else {
//   //                   addTruckDataWithGPS();
//   //                 }
//   //               } else {
//   //                 //here user wants to checkin
//   //                 //check isqralready present?
//   //                 if (isQrPresent) {
//   //                   Fluttertoast.showToast(
//   //                       msg: 'Submit event\nWork in progress..');
//   //                 } else {
//   //                   //show popup
//   //                   showFlaggedPopup(context, function: (flaggedMenu) {
//   //                     final menu = flaggedMenu as EnumFlaggedMenu;
//   //                     if (menu == EnumFlaggedMenu.startagain) {
//   //                       moveToMainMenu();
//   //                     } else {
//   //                       Fluttertoast.showToast(msg: 'submit');
//   //                     }
//   //                   });
//   //                 }
//   //               }
//   //             });
//   //           })
//   //     ]),
//   //   );
//   // }
//   //
//   // void addTruckDataWithGPS() {
//   //   _controller.getGPSLocation(qrcode, context, function: (boool) {
//   //     Navigator.pop(context);
//   //     if (boool == true) {
//   //       Fluttertoast.showToast(msg: 'Load Added');
//   //       //back to main menu
//   //       //  Get.toNamed(AppRoutes.home);
//   //       moveToMainMenu();
//   //     }
//   //   });
//   // }
//
//   void moveToMainMenu() {
//     Navigator.pop(context);
//     // Navigator.pushNamedAndRemoveUntil(
//     //     context, AppRoutes.homemenu, (Route<dynamic> route) => false);
//   }
// }
