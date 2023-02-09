// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
//
// import 'package:truck_tracker/utils/common_widgets.dart';
// import 'package:truck_tracker/utils/stringsref.dart';
// import 'package:truck_tracker/views/pops/progress.dart';
//
//
// import '../controller/details_cntrl.dart';
//
// import '../model/model_license_data.dart';
// import '../model/model_vehicle_license.dart';
// import '../routes/app_routes.dart';
// import '../utils/app_colors.dart';
// import '../utils/app_constants.dart';
// import '../utils/app_screens.dart';
//
//
// class DetailsVehCheckIN extends StatefulWidget {
//
//   final Function( AppScreens? moveTo ) onEventNav;
//
//  // DetailsVehCheckIN({super.key, required this.onEventNav});
//   ModelLicenseData?   _vehData  ;
//   // LoadCheckIn(this.userMode, {super.key,});
//       DetailsVehCheckIN(this._vehData,{required this.onEventNav});
//
//
//  ///  VehicleLicense?  vehicleLicenseData;
//   @override
//   State<DetailsVehCheckIN> createState() => _DetailsVehState();
// }
//
// class _DetailsVehState extends State<DetailsVehCheckIN> {
//   //  _DetailsVehState(Map<String, dynamic>? vehData  )  ;
//  // VehicleLicense?  vehicleLicenseData;
//   final DetailsController _controller = DetailsController();
//
//   final title = 'Vehicle Details Shown Here';
//   final modeToAddData = false;
//   // VehicleLicense? vehData;
//   // VehicleLicense? vehQRData;
//   //
//   @override
//   void initState() {
//     super.initState();
//     // final transferMap = <String, dynamic>{
//     //   'modetoadd':modeToAddData,
//     //   'licensedata':vehData,
//     //   'qrdata':null,
//     //
//     // };
//     try {
//       _controller.setVehicleLicenseData(widget._vehData!);
//       Fluttertoast.showToast(msg: 'Setup done');
//       // final receivedPayload = Get.arguments as VehicleLicense;
//       //
//       // receivedPayload.forEach((key, value) {
//       //   //  Fluttertoast.showToast(msg: '--->> $value');
//       //   if (key == 'modetoadd') {
//       //     modeToAddData = value as bool;
//       //   } else if (key == 'licensedata') {
//       //     vehData = value as VehicleLicense;
//       //     if (vehData != null) {
//       //       _controller.setVehicleLicenseData(vehData!);
//       //     }
//       //   } else {}
//       // });
//     } catch (e) {
//       Fluttertoast.showToast(msg: 'Payload Error$e');
//     }
//
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
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//           child: SingleChildScrollView(
//         child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           // Padding(
//           //   padding: const EdgeInsets.all(8.0),
//           //   child: IconButton(
//           //     iconSize: 30.0,
//           //     onPressed: () {
//           //       Navigator.pop(context);
//           //     },
//           //     icon: Icon(
//           //       Icons.arrow_back,
//           //       color: AppColors.black,
//           //     ),
//           //   ),
//           // ),
//           Padding(
//             padding: const EdgeInsets.all(15.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//
//
//
//                 space,
//                 CommonUtils().setHeader('VEHICLE DETAILS'),
//                 space,
//                 Container(
//                   //
//                     width: 400,
//                     height: 170,
//                 decoration: BoxDecoration(
//                     color: AppColors.base,
//                     borderRadius: const BorderRadius.all(
//                         Radius.elliptical(10, 10.0)),
//                     border: Border.all(
//                         width: 1.0, color: AppColors.base)),
//                     child: Center(
//                       child: Padding(padding: EdgeInsets.all(10),child:
//                       lbuild() ,),
//                     )  ),
//                SizedBox(
//                  height: 30,
//                ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       CommonUtils().setSubHeader('Time Stamp:XXXX7789',size: 17),
//                       CommonUtils().setSubHeader('GPS Location:31,8797696969699',size: 17),
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   height: 50,
//                 ),
//                 CommonUtils().setSubHeader(StringsRef.clickthisifchekpt,size: 17,align: TextAlign.center),
//                 Padding(
//                   padding: const EdgeInsets.all(15.0),
//                   child: Column(
//                     children: [
//                       CommonUtils.baseButton(
//                           title: 'SAVE',
//                           ht: 45,
//                           txtSize: 12,
//                           fontType: AppConstants.fontSubTitle,
//                           function: () {
//                            // onSubmitTest(context);
//                           }),
//                       SizedBox(height: 10,),
//                       CommonUtils.baseButton(
//                           title: 'CONTINUE',
//                           ht: 45,
//                           txtSize: 12,
//                           fontType: AppConstants.fontSubTitle,
//                           function: () {
//                           //  onSubmitTest(context);
//                           }),
//                       // CommonUtils.baseButton(
//                       //     title: 'SUBMIT',
//                       //     ht: 45,
//                       //     txtSize: 12,
//                       //     fontType: AppConstants.fontSubTitle,
//                       //     function: () {
//                       //       onSubmitTest(context);
//                       //     }),
//                       SizedBox(height: 10,),
//                       CommonUtils.baseButton(
//                           title: 'TRUCK EXIT',
//                           ht: 45,
//                           txtSize: 12,
//                           fontType: AppConstants.fontSubTitle,
//                           function: () {
//                          //   final vehData = widget._vehData;
//                             //Navigator.pop(context);
//                             widget.onEventNav(AppScreens.Home);
//                           }),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//                 // for (var i = 0; i < _controller.objVehLicenseData.length; i++)
//                 //   Container(
//                 //     color: AppColors.base,
//                 //
//                 //     child: Row(
//                 //       children: [
//                 //         SizedBox(
//                 //           width: 150,
//                 //           child: Column(
//                 //             mainAxisAlignment: MainAxisAlignment.start,
//                 //             children: [
//                 //               Align(
//                 //                   alignment: Alignment.centerLeft,
//                 //                   child: CommonUtils().setSubHeader(
//                 //                       _controller.objVehLicenseData[i].title!,color: AppColors.white)),
//                 //               space
//                 //             ],
//                 //           ),
//                 //         ),
//                 //         Padding(
//                 //           padding: EdgeInsets.only(right: 30.0),
//                 //         ),
//                 //         Expanded(
//                 //           child: Column(
//                 //             children: [
//                 //               Align(
//                 //                 alignment: Alignment.centerLeft,
//                 //                 child: _controller
//                 //                     .objVehLicenseData[i].data!.text
//                 //                     .fontFamily('Manrope')
//                 //                     .fontWeight(FontWeight.w500)
//                 //                     .color(AppColors.black)
//                 //                     .align(TextAlign.start)
//                 //                     .size(15)
//                 //                     .maxLines(3)
//                 //                     .softWrap(false)
//                 //                     .overflow(TextOverflow.ellipsis)
//                 //                     .make(),
//                 //               ),
//                 //
//                 //               // CommonUtils().setSubHeader( objVehLicenseData[i].data!),
//                 //               space,
//                 //             ],
//                 //           ),
//                 //         )
//                 //       ],
//
//                    ),
//                 // space,
//               ],
//
//
//
//
//
//           //
//          ),
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
//   lbuild(){
//    return  ListView.builder(
//       itemCount: _controller.objVehLicenseData.length , // +1 because you are showing one extra widget.
//       itemBuilder: (BuildContext context, int index) {
//        // if (index == 0) {
//         String? title = _controller.objVehLicenseData[index].title;
//         String? data = _controller.objVehLicenseData[index].data;
//         final fulldata = '${title!}=${data!}';
//           return Row(
//             children: [
//               CommonUtils().setSubHeader(fulldata,color: AppColors.white,size: 17),
//             ],
//           );
//       //  }
//        // int numberOfExtraWidget = 1; // here we have 1 ExtraWidget i.e Container.
//       //  index = index - numberOfExtraWidget; // index of actual post.
//
//       },
//     );
//   }
//   void moveToMainMenu(BuildContext context) {
//     // Navigator.pop(context);
//     Navigator.pushNamedAndRemoveUntil(
//         context, AppRoutes.navboard, (Route<dynamic> route) => false);
//   }
//
//   void fetchCheckPoints() {
//     Fluttertoast.showToast(msg: 'App needed to fetch data again');
//   }
//
//   void hideProgress(BuildContext context) {
//     Navigator.of(context).pop();
//
//   }
//
//   // void onSubmitTest(BuildContext context){
//   //   final createdAt = '';
//   //   final vehData = widget._vehData;
//   //   final body = BodySubmitCheckPoint(
//   //       vehData?.licenseno,
//   //       vehData?.vehregno,
//   //       vehData?.vin,
//   //       vehData?.engineno,
//   //       vehData?.fees,
//   //       vehData?.gvd,
//   //       vehData?.tare,
//   //       vehData?.make,
//   //       vehData?.description,
//   //       vehData?.expirydate,
//   //       createdAt);
//   //   // _controller.submitCheckPoint(context, body,(function){
//   //   //
//   //   // });
//   //   showProgressb(context, 'Submitting...');
//   //   // _controller.submitCheckPoint(context, body, function: (value) {
//   //   //   // if(!mounted) return;
//   //   //   Navigator.pop(context);
//   //   //   if (value) {
//   //   //     moveToMainMenu(context);
//   //   //   }
//   //   // });
//   // }
//
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
//   void moveToHomeMenu(BuildContext context) {
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
