// import 'package:flutter/material.dart';
// import 'package:truck_tracker/utils/app_colors.dart';
// import 'package:truck_tracker/utils/app_constants.dart';
// import 'package:velocity_x/velocity_x.dart';
//
// import '../../utils/common_widgets.dart';
//
// enum EnumFlaggedMenu { startagain, submit }
//
// showFlaggedPopup(BuildContext context, {required Function function}) {
//   //:::::::::::::::::::::::::::::WIDGETS::::::::::::::::::::::
//
//   //:::::::::::::::::::::::::::::::::END WIDGETS:::::::::::::::::::::::::
//   final space = const SizedBox(
//     height: 30,
//   );
//
//   return showDialog(
//     barrierDismissible: false,
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: 'Alert'.text.semiBold.align(TextAlign.center).make(),
//         content: Wrap(
//           children: [
//             Column(
//               children: [
//                 Container(
//                   height: 80,
//                   // width: double.infinity,
//                   decoration: BoxDecoration(
//                     borderRadius: const BorderRadius.all(
//                         Radius.elliptical(5.10, 2.0)),
//                     color: AppColors.redDark,
//                   ),
//                   alignment: Alignment.topLeft,
//                   child: Padding(
//                     padding: const EdgeInsets.only(
//                         left: 15, right: 15, top: 10),
//                     child:
//                     CommonUtils()
//                         .setSubHeader(
//                         'The details dont match QR and vehicle  license - do you want to continue anyway ? or restart?',
//                         color: AppColors.white),
//                   ),),
//
//                 space,
//                 Container(
//                   // height: 120,
//                   decoration: BoxDecoration(
//                       borderRadius: const BorderRadius.all(
//                           Radius.elliptical(5.10, 2.0)),
//                       border: Border.all(width: 1.0, color: AppColors.grey1)),
//
//                   child:
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: TextFormField(
//                       maxLines: 5,
//                       style: const TextStyle(
//                           fontSize: 15.0,
//                           color: AppColors.black,
//                           fontStyle: FontStyle.normal,
//                           fontWeight: FontWeight.w500),
//                       cursorColor: Colors.black,
//
//                       autovalidateMode: AutovalidateMode.onUserInteraction,
//                       decoration: const InputDecoration(
//                         contentPadding: EdgeInsets.symmetric(
//                             horizontal: 10),
//                         filled: false,
//                         fillColor: AppColors.grey,
//                         border: InputBorder.none,
//                         hintStyle: TextStyle(
//                             color: Colors.black,
//                             fontStyle: FontStyle.normal,
//                             fontWeight: FontWeight.w500),
//                         hintText: "Optional text box only use if you are submitting.",
//                       ),
//
//                       validator: (value) {
//                         //  return _controller.handleEmail(value!);
//                       },
//                     ),
//                   ),
//
//                 ),
//                 // Padding(
//                 //   padding: const EdgeInsets.all(8.0),
//                 //   child: TextFormField(
//                 //     maxLines: 5,
//                 //     style: const TextStyle(
//                 //         fontSize: 15.0,
//                 //         color: AppColors.black,
//                 //         fontStyle: FontStyle.normal,
//                 //         fontWeight: FontWeight.w500),
//                 //     cursorColor: Colors.black,
//                 //
//                 //     autovalidateMode: AutovalidateMode.onUserInteraction,
//                 //     decoration: const InputDecoration(
//                 //       contentPadding: EdgeInsets.symmetric(
//                 //           horizontal: 10),
//                 //       filled: false,
//                 //       fillColor: AppColors.grey1,
//                 //       border: InputBorder.none,
//                 //       hintStyle: TextStyle(
//                 //           color: Colors.black,
//                 //           fontStyle: FontStyle.normal,
//                 //           fontWeight: FontWeight.w500),
//                 //       hintText: "Optional text box only use if you are submitting.",
//                 //     ),
//                 //
//                 //     validator: (value) {
//                 //       //  return _controller.handleEmail(value!);
//                 //     },
//                 //   ),
//                 // ),
//                 space,
//                  Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                      crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         SizedBox(
//                           width: 100,
//                           child: TextButton(
//
//                             onPressed: () {
//                               Navigator.pop(context);
//                               function(EnumFlaggedMenu.startagain);
//
//                             },
//                             style:ButtonStyle(
//                               backgroundColor: MaterialStateProperty.all(AppColors.base),
//                             ),
//                             child:'START AGAIN'.text.fontFamily(AppConstants.fontSubTitle)
//                                 .fontWeight(FontWeight.w500)
//                                 .color(AppColors.white)
//                                 .size(13).make(),
//                             // child:CommonUtils().setHeader(title,color:AppColors.white,size: 13),
//                           ),
//                         ),
//                         SizedBox(
//                           width: 100,
//                           child: TextButton(
//
//                             onPressed: () {
//                               Navigator.pop(context);
//                               function(EnumFlaggedMenu.submit);
//
//                             },
//                             style:ButtonStyle(
//                               backgroundColor: MaterialStateProperty.all(AppColors.base),
//                             ),
//                             child:'SUBMIT'.text.fontFamily(AppConstants.fontSubTitle)
//                                 .fontWeight(FontWeight.w500)
//                                 .color(AppColors.white)
//                                 .size(13).make(),
//                             // child:CommonUtils().setHeader(title,color:AppColors.white,size: 13),
//                           ),
//                         ),
//
//                       ]),
//
//               ],
//             ),
//           ],
//         ),
//       );
//     },
//   );
// }
