import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:truck_tracker/app_db/dbsql/loadcheckintable/sql_loaddb.dart';
import 'package:truck_tracker/model/model_license_data.dart';
import 'package:truck_tracker/utils/app_colors.dart';
import 'package:truck_tracker/utils/common_widgets.dart';
import 'app_constants.dart';
import 'common_methods.dart';
import 'image_paths.dart';

class AppPops {
  var appName = 'Trucker Track';

  AppPops._privateConstructor();

  static final AppPops _instance = AppPops._privateConstructor();

  factory AppPops() {
    return _instance;
  }

  //::::::::::::::::ALERTS:::::::::::::

  void showAlertOfTypeErrorWithDismiss(String error) {
    final ui = CommonUtils();
    AlertDialog alert = AlertDialog(
      content: Wrap(
        children: [
          Column(children: [
            ui.setHeader(
              'Alert',
              color: AppColors.redDark,
              size: 22,
            ),
            ui.setSubHeader(
                'We found following error while performing action.\n*$error',
                color: AppColors.base,
                size: 17),
            const SizedBox(
              height: 30,
            ),
            // CommonUtils.baseButton(
            //     title: 'Report',
            //     function: () {
            //       Navigator.pop(context);
            //    _sendMail(error);
            //     }),
            CommonUtils.baseButton(
                title: 'Dismiss',
                function: () {;
                  Navigator.pop(Get.context!);
                })
          ]),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: Get.context!,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void showAlertOfTypeMessage(String msg, BuildContext context) {
    final ui = CommonUtils();
    AlertDialog alert = AlertDialog(
      content: Wrap(
        children: [
          Column(children: [
            ui.setHeader('Alert', color: AppColors.redDark, size: 22),
            const SizedBox(
              height: 10,
            ),
            ui.setSubHeader(msg, color: AppColors.base, size: 17),
            const SizedBox(
              height: 30,
            ),
            CommonUtils.baseButton(
                title: 'Dismiss',
                function: () {
                  Navigator.pop(context);
                })
          ]),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void showAlertOfTypeMessageWithTwoButtons(
      String msg, String btnTilteA, String btnTilteB, BuildContext context,
      {required Function function}) {
    final ui = CommonUtils();
    AlertDialog alert = AlertDialog(
      content: Wrap(
        children: [
          Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ui.setHeader(
                    'Alert',
                    color: AppColors.redDark,
                    size: 22,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ui.setSubHeader(msg, color: AppColors.base, size: 17),
                ]),
          ),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.base,
          ),
          child: CommonUtils()
              .setSubHeader(btnTilteA, size: 10, color: AppColors.white),
          onPressed: () {
            function(btnTilteA);
            Navigator.pop(context);
          },
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.base,
          ),
          child: CommonUtils()
              .setSubHeader(btnTilteB, size: 10, color: AppColors.white),
          onPressed: () {
            Navigator.pop(context);
            function(btnTilteB);
            // Navigator.pop(context);
          },
        ),
      ],
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void showAlertDialogWithOneBoxField(
      String msg, String btnTilteA, String btnTilteB, BuildContext context,
      {required Function function}) {
    var comment = '';
    final ui = CommonUtils();
    AlertDialog alert = AlertDialog(
      content: Wrap(
        children: [
          Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ui.setHeader(
                    'Alert',
                    color: AppColors.redDark,
                    size: 22,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ui.setSubHeader(msg, color: AppColors.base, size: 15),
                  Container(
                    // height: 50,
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                            Radius.elliptical(10.0, 10.0)),
                        border: Border.all(width: 1.0, color: AppColors.base)),

                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        textInputAction: TextInputAction.done,
                        maxLines: 5,
                        style: const TextStyle(
                            fontSize: 15.0,
                            color: AppColors.black,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w500),
                        cursorColor: Colors.black,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          filled: false,
                          fillColor: AppColors.grey,
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                              color: AppColors.base,
                              fontSize: 17,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w500),
                          hintText: "Text box - comment / details",
                        ),
                        validator: (value) {
                          // CommonMethods().showToast('$value');
                          comment = value!;
                          return null;
                        },
                        // onFieldSubmitted: (v){
                        //   CommonMethods().showToast('Done');
                        // //  comment
                        // },
                      ),
                    ),
                  ),
                ]),
          ),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.base,
          ),
          child: CommonUtils()
              .setSubHeader(btnTilteA, size: 10, color: AppColors.white),
          onPressed: () {
            function(btnTilteA, comment);
            Navigator.pop(context);
            SqlLoadDB.instance.cancelLoad();
          },
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.base,
          ),
          child: CommonUtils()
              .setSubHeader(btnTilteB, size: 10, color: AppColors.white),
          onPressed: () {
            Navigator.pop(context);
            function(btnTilteB, comment);

            // Navigator.pop(context);
          },
        ),
      ],
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void showAlertAllClear(BuildContext context, {required Function function}) {
    final ui = CommonUtils();
    AlertDialog alert = AlertDialog(
      content: Wrap(
        children: [
          Column(children: [
            ui.setHeader(
              'All Clear',
              color: AppColors.green,
              size: 22,
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset(
                ImagePaths.thumbsup,
                fit: BoxFit.fill,
              ),
            ),
            CommonUtils.baseButton(
                title: 'Dismiss',
                function: () {
                  Navigator.pop(context);
                  function();
                })
          ]),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showDialogWithManualEntryOfLicenseData(
       BuildContext context,
      {required Function function}) {
       String? licenseNo = '';
       //String? vehRegNo = '';
       String? make = '';
       String? vn = '';
       String? engineNo = '';
       String? doe = '';

    final spaceV = const SizedBox(
      height: 10,
    );
    const borderStyle = BorderSide(color: AppColors.base, width: 1.5);
    const hintStyle = TextStyle(
      color: AppColors.base,
      fontSize: 17,
      fontFamily: AppConstants.fontRegular,
      // fontStyle: FontStyle.normal,
      // fontWeight: FontWeight.w500,
    );
    const typeStyle = TextStyle(
        fontSize: 15.0,
        color: AppColors.base,
        fontFamily: AppConstants.fontSubTitle,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w500);

    final ui = CommonUtils();
  //  final GlobalKey<FormState> fieldFormKey = GlobalKey<FormState>();
    final alert = StatefulBuilder(
      builder: (context,setState) {
        return AlertDialog(
          content: Wrap(
            children: [
              Center(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ui.setHeader(
                        'Alert',
                        color: AppColors.redDark,
                        size: 22,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ui.setSubHeader('Please add manually', color: AppColors.base, size: 15),
                      Container(
                        // height: 50,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                                Radius.elliptical(10.0, 10.0)),
                            border: Border.all(width: 1.0, color: AppColors
                                .base)),

                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                          //Form fields

                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(children: [
                                TextFormField(
                                  textAlign: TextAlign.center,
                                  textInputAction: TextInputAction.next,
                                  style: typeStyle,
                                  cursorColor: Colors.black,
                                  autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    contentPadding:
                                    EdgeInsets.fromLTRB(10, 10, 10, 0),
                                    //  EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),

                                    filled: true,
                                    fillColor: AppColors.white,
                                    hintStyle: hintStyle,
                                    hintText: 'Enter License No',

                                    errorBorder: OutlineInputBorder(
                                      borderSide: borderStyle,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: borderStyle,
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: borderStyle,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: borderStyle,
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: borderStyle,
                                    ),
                                  ),
                                  validator: (value){
                                    licenseNo = value;
                                    return;
                                  },
                                ),
                                spaceV,
                                // TextFormField(
                                //   textAlign: TextAlign.center,
                                //   textInputAction: TextInputAction.next,
                                //   style: typeStyle,
                                //   cursorColor: Colors.black,
                                //   autovalidateMode:
                                //   AutovalidateMode.onUserInteraction,
                                //   decoration: const InputDecoration(
                                //     isDense: true,
                                //     contentPadding:
                                //     EdgeInsets.fromLTRB(10, 10, 10, 0),
                                //     //  EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                //
                                //     filled: true,
                                //     fillColor: AppColors.white,
                                //     hintStyle: hintStyle,
                                //     hintText: 'Enter Veh Reg No',
                                //
                                //     errorBorder: OutlineInputBorder(
                                //       borderSide: borderStyle,
                                //     ),
                                //     focusedBorder: OutlineInputBorder(
                                //       borderSide: borderStyle,
                                //     ),
                                //     focusedErrorBorder: OutlineInputBorder(
                                //       borderSide: borderStyle,
                                //     ),
                                //     enabledBorder: OutlineInputBorder(
                                //       borderSide: borderStyle,
                                //     ),
                                //     border: OutlineInputBorder(
                                //       borderSide: borderStyle,
                                //     ),
                                //   ),
                                //   validator: (value){
                                //     vehRegNo = value;
                                //     return;
                                //   },
                                // ),
                                // spaceV,
                                TextFormField(
                                  textAlign: TextAlign.center,
                                  textInputAction: TextInputAction.next,
                                  style: typeStyle,
                                  cursorColor: Colors.black,
                                  autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    contentPadding:
                                    EdgeInsets.fromLTRB(10, 10, 10, 0),
                                    //  EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),

                                    filled: true,
                                    fillColor: AppColors.white,
                                    hintStyle: hintStyle,
                                    hintText: 'Enter make',

                                    errorBorder: OutlineInputBorder(
                                      borderSide: borderStyle,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: borderStyle,
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: borderStyle,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: borderStyle,
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: borderStyle,
                                    ),
                                  ),
                                  validator: (value){
                                    make = value;
                                    return;
                                  },
                                ),
                                spaceV,
                                TextFormField(
                                  textAlign: TextAlign.center,
                                  textInputAction: TextInputAction.next,
                                  style: typeStyle,
                                  cursorColor: Colors.black,
                                  autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    contentPadding:
                                    EdgeInsets.fromLTRB(10, 10, 10, 0),
                                    //  EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),

                                    filled: true,
                                    fillColor: AppColors.white,
                                    hintStyle: hintStyle,
                                    hintText: 'Enter vn',

                                    errorBorder: OutlineInputBorder(
                                      borderSide: borderStyle,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: borderStyle,
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: borderStyle,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: borderStyle,
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: borderStyle,
                                    ),
                                  ),
                                  validator: (value){
                                    vn = value;
                                    return;
                                  },
                                ),
                                spaceV,
                                TextFormField(
                                  textAlign: TextAlign.center,
                                  textInputAction: TextInputAction.done,
                                  style: typeStyle,
                                  cursorColor: Colors.black,
                                  autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    contentPadding:
                                    EdgeInsets.fromLTRB(10, 10, 10, 0),
                                    //  EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),

                                    filled: true,
                                    fillColor: AppColors.white,
                                    hintStyle: hintStyle,
                                    hintText: 'Enter engine no',

                                    errorBorder: OutlineInputBorder(
                                      borderSide: borderStyle,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: borderStyle,
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: borderStyle,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: borderStyle,
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: borderStyle,
                                    ),
                                  ),
                                  validator: (value){
                                    engineNo = value;
                                    return;
                                  },
                                ),
                              ],),

                              spaceV,
                              GestureDetector(
                                onTap: () {
                                  _selectDate(context, function: (date) {
                                    setState(() {
                                      doe = date;
                                    });

                                  });
                                },
                                child: Container(
                                  height: 35,
                                  width: double.infinity,
                                 // margin: EdgeInsets.all(15),
                                 // padding: EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: AppColors.base,width: 1.5),
                                    borderRadius: BorderRadius.all(Radius.circular(4.0))
                                  ),
                                  child: (doe!.isEmpty)?Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Choose Date', textAlign:TextAlign.center,style: TextStyle(
                                        color: AppColors.base, fontSize: 17),),
                                  ):Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('$doe',textAlign:TextAlign.center, style: TextStyle(
                                        color: AppColors.base, fontSize: 17),),
                                  ),
                                ),
                              )

                            ],
                          ),
                          //end
                        ),
                      ),
                    ]),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.base,
              ),
              child: CommonUtils()
                  .setSubHeader('Done', size: 10, color: AppColors.white),
              onPressed: () {
//final gg = fieldFormKey.currentState?.validate();// .currentState!.validate();
               // CommonMethods().showToast('$gg');
                //|| vehRegNo!.isEmpty
                  if(licenseNo!.isEmpty  || make!.isEmpty || vn!.isEmpty || engineNo!.isEmpty ){
                  CommonMethods().showToast('Please fill all fields test');
                }
                else if( doe!.isEmpty) {
                  CommonMethods().showToast('Please choose date');

                }
                else {
                  final obj = ModelLicenseData('', licenseNo, '', vn, engineNo,
                      '', '', '', make, '', '', '', '', doe);
                  Navigator.pop(context);
                  function(obj);


                }
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.base,
              ),
              child: CommonUtils()
                  .setSubHeader('Cancel', size: 10, color: AppColors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );

      });
    showDialog(
      barrierDismissible: false,
      context: context,

      builder: (BuildContext context) {
        return alert;

      },
    );
  }

  Future _selectDate(BuildContext context, {required Function function}) async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2020),
        lastDate: new DateTime(2030));
    if (picked != null) {
      final  formatDate = "${picked.year.toString()}-${picked.month.toString()}-${picked.day.toString()}";
      function(formatDate);
    }
    // setState(
    //         () => { data.registrationdate = picked.toString(),
    //       intialdateval.text = picked.toString()
    //     }
    // );
  }

  void _sendMail(String error ) async {
   // launch("https://mail.google.com/mail/u/0/#inbox")
    // final ee = error;
    // const uri = 'mailto:dyummyu213@gmail.com?subject=Trucker Track Error Report&body=${ee}';
    // if(await canLaunch(uri)){
    //   await launch(uri);
    // }else{
    //   throw 'Could not launch $uri';
    // }
  }

    showDialogOfAnyWidgetImage(Widget widget ) {


    AlertDialog alert = AlertDialog(
      content: widget,
    );
    showDialog(
      barrierDismissible: true,
      context: Get.context!,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
