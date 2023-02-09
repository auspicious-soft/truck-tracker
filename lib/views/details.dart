// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
//
// import 'package:truck_tracker/utils/common_widgets.dart';
// import 'package:truck_tracker/views/pops/progress.dart';
// import 'package:velocity_x/velocity_x.dart';
//
// import '../model/model_license_data.dart';
// import '../model/model_vehicle_license.dart';
// import '../routes/app_routes.dart';
// import '../utils/app_colors.dart';
// import '../utils/app_constants.dart';
// import '../utils/truckbox.dart';
// import 'pops/pop_flagged.dart';
// import '../controller/details_cntrl.dart';
//
// class Details extends StatefulWidget {
//   // LoadCheckIn(this.userMode, {super.key,});
//   const Details({Key? key}) : super(key: key);
//   // VehicleLicense?  vehicleLicenseData;
//   @override
//   State<Details> createState() => _DetailsState();
// }
//
// class _DetailsState extends State<Details> {
//   // _QRScannerState();
//
//   final DetailsController _controller = DetailsController();
//
//   String title = 'Vehicle Details Shown Here';
//   bool modeToAddData = false;
//   ModelLicenseData? vehData;
//   ModelLicenseData? vehQRData;
//   @override
//   void initState() {
//
//     // final transferMap = <String, dynamic>{
//     //   'modetoadd':modeToAddData,
//     //   'licensedata':vehData,
//     //   'qrdata':null,
//     //
//     // };
//     try{
//       final receivedPayload = Get.arguments as Map;
//
//      receivedPayload.forEach((key, value) {
//      //  Fluttertoast.showToast(msg: '--->> $value');
//        if(key == 'modetoadd'){
//          modeToAddData = value as bool;
//        }else if (key == 'licensedata'){
//          vehData = value as ModelLicenseData;
//          if(vehData != null){
//            _controller.setVehicleLicenseData(vehData!);
//
//          }
//        }else{
//
//        }
//
//
//
//
//       });
//
//     }catch(e){
//       Fluttertoast.showToast(msg: 'Payload Error$e');
//     }
//   super.initState();
//     // subscribeToMessages();
//   }
//
//   //final NavHomeController _controller = Get.find();
//   //final NavHomeController _controller = Get.find();
//
//   bool showSubmitView = false;
//
//   @override
//   Widget build(BuildContext context) {
//     final space = SizedBox(height: 10);
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//           child: SingleChildScrollView(
//         child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: IconButton(
//               iconSize: 30.0,
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               icon: Icon(
//                 Icons.arrow_back,
//                 color: AppColors.black,
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   margin: EdgeInsets.only(left: 20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       CommonUtils().setHeader(title),
//                       SizedBox(
//                         height: 30,
//                       ),
//                       Center(
//                           child: CommonUtils()
//                               .setHeader('No ${vehData?.number}', size: 19)),
//                       SizedBox(
//                         height: 30,
//                       ),
//                     ],
//                   ),
//                 ),
//                 for (var i = 0; i < _controller.objVehLicenseData.length; i++)
//                   Container(
//                     margin: EdgeInsets.only(left: 20),
//                     child: Row(
//                       children: [
//                         SizedBox(
//                           width: 150,
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               Align(
//                                   alignment: Alignment.centerLeft,
//                                   child: CommonUtils().setSubHeader(
//                                       _controller.objVehLicenseData[i].title!)),
//                               space
//                             ],
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.only(right: 30.0),
//                         ),
//                         Expanded(
//                           child: Column(
//                             children: [
//                               Align(
//                                 alignment: Alignment.centerLeft,
//                                 child: _controller
//                                     .objVehLicenseData[i].data!.text
//                                     .fontFamily('Manrope')
//                                     .fontWeight(FontWeight.w500)
//                                     .color(AppColors.black)
//                                     .align(TextAlign.start)
//                                     .size(15)
//                                     .maxLines(3)
//                                     .softWrap(false)
//                                     .overflow(TextOverflow.ellipsis)
//                                     .make(),
//                               ),
//
//                               // CommonUtils().setSubHeader( objVehLicenseData[i].data!),
//                               space,
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 space,
//                 space,
//                 space,
//                 space,
//                 Container(
//                   margin: EdgeInsets.only(left: 20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       CommonUtils().setHeader('QR Details Show Here',
//                           align: TextAlign.left),
//                       SizedBox(
//                         height: 30,
//                       ),
//                       Center(
//                           child: CommonUtils()
//                               .setHeader('No ${vehData?.number}', size: 19)),
//                       SizedBox(
//                         height: 30,
//                       ),
//                     ],
//                   ),
//                 ),
//                 for (var i = 0; i < _controller.objVehLicenseData.length; i++)
//                   Container(
//                     margin: EdgeInsets.only(left: 20),
//                     child: Row(
//                       children: [
//                         SizedBox(
//                           width: 150,
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               Align(
//                                   alignment: Alignment.centerLeft,
//                                   child: CommonUtils().setSubHeader(
//                                       _controller.objVehLicenseData[i].title!)),
//                               space
//                             ],
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.only(right: 30.0),
//                         ),
//                         Expanded(
//                           child: Column(
//                             children: [
//                               Align(
//                                 alignment: Alignment.centerLeft,
//                                 child: _controller
//                                     .objVehLicenseData[i].data!.text
//                                     .fontFamily('Manrope')
//                                     .fontWeight(FontWeight.w500)
//                                     .color(AppColors.black)
//                                     .align(TextAlign.start)
//                                     .size(15)
//                                     .maxLines(3)
//                                     .softWrap(false)
//                                     .overflow(TextOverflow.ellipsis)
//                                     .make(),
//                               ),
//
//                               // CommonUtils().setSubHeader( objVehLicenseData[i].data!),
//                               space,
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//               ],
//             ),
//           ),
//
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: CommonUtils.baseButton(
//                 title: 'SUBMIT',
//                 ht: 45,
//                 txtSize: 12,
//                 fontType: AppConstants.fontSubTitle,
//                 function: () {
//                   //onSubmitTest();
//                 }),
//           ),
//
//           //
//         ]),
//       )),
//     );
//   }
//
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
//    // Navigator.pop(context);
//     Navigator.pushNamedAndRemoveUntil(
//         context, AppRoutes.navboard, (Route<dynamic> route) => false);
//   }
// void fetchCheckPoints(){
//   Fluttertoast.showToast(msg: 'App needed to fetch data again');
// }
//
//   void hideProgress() {
//
//     Navigator.of(context).pop();
//
//     //  Navigator.pop(context);
//
//   }
//   // void onSubmitTest()  {
//   //   final createdAt = '';
//   //   final body = BodySubmitCheckPoint( vehData?.licenseno,vehData?.vehregno,
//   //       vehData?.vin,vehData?.engineno,vehData?.fees,vehData?.gvd,vehData?.tare,
//   //       vehData?.make,vehData?.description ,vehData?.expirydate, createdAt);
//   //   // _controller.submitCheckPoint(context, body,(function){
//   //   //
//   //   // });
//   //   showProgressb(context,'Submitting...');
//   //   _controller.submitCheckPoint(context, body, function: (value){
//   //    // if(!mounted) return;
//   //     Navigator.pop(context);
//   //    if(value){
//   //      moveToMainMenu();
//   //    }
//   //
//   //   });
//   // }
// //   void onSubmit() async {
// //     final checkpoints =  await  TruckBox.instance.getCheckPointData();
// //     if(checkpoints != null ){
// //       if(checkpoints.isNotEmpty){
// //        // Fluttertoast.showToast(msg: 'ready to submit ');
// // final createdAt = '';
// //         if(!mounted) return;
// //         //showProgressb(context,'Submitting...');
// //         final body = BodySubmitCheckPoint( vehData?.licenseno,vehData?.vehregno,
// //             vehData?.vin,vehData?.engineno,vehData?.fees,vehData?.gvd,vehData?.tare,
// //             vehData?.make,vehData?.description ,vehData?.expirydate, createdAt);
// //  _controller.submitCheckPoint(context, body);
// //         // for (var element in checkpoints) {
// //         //   final data = element as CheckPointData;
// //         //   Fluttertoast.showToast(msg: data.id.toString());
// //         // }
// //       }else{
// //         fetchCheckPoints();
// //       }
// //     }else{
// //       fetchCheckPoints();
// //     }
// //
// //
// //   }
//   void moveToHomeMenu(){
//     Navigator.pushNamedAndRemoveUntil(
//         context, AppRoutes.homemenu, (Route<dynamic> route) => false);
// //     showFlaggedPopup(context, function: (onpress) {
// // if(onpress ==  EnumFlaggedMenu.startagain ){
// //   Navigator.pop(context);
// // }else{
// //   Navigator.pushNamedAndRemoveUntil(
// //         context, AppRoutes.homemenu, (Route<dynamic> route) => false);
// // }
// //     } );
//   }
// }
