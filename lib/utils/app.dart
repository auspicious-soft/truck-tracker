
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truck_tracker/app_db/dbsql/loadcheckintable/sql_loaddb.dart';


import 'package:truck_tracker/utils/app_colors.dart';
import 'package:truck_tracker/utils/common_widgets.dart';
import 'image_paths.dart';

class BaseApp {
  var appName = 'Trucker Track';

  BaseApp._privateConstructor();

  static final BaseApp _instance = BaseApp._privateConstructor();

  factory BaseApp() {
    return _instance;
  }



  //::::::::::::::::ALERTS:::::::::::::
  void showAlertOfTypeErrorWithDismiss(String error,BuildContext context){
    final ui = CommonUtils();
    AlertDialog alert = AlertDialog(
      content: Wrap(
        children: [
          Column(children: [
            ui.setHeader('Alert',color: AppColors.redDark,size:22,),
            ui.setSubHeader('We found following error while performing action.\n*$error',color: AppColors.base,size: 17),
            const SizedBox(height: 30,),
            CommonUtils.baseButton(title: 'Dismiss', function: (){
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
  void showAlertOfTypeMessage(String msg,BuildContext context){
  final ui = CommonUtils();
  AlertDialog alert = AlertDialog(
    content: Wrap(
      children: [
        Column(children: [
          ui.setHeader('Alert',color: AppColors.redDark,size:22),
          const SizedBox(height: 10,),
          ui.setSubHeader(msg,color: AppColors.base,size: 17),
          const SizedBox(height: 30,),
          CommonUtils.baseButton(title: 'Dismiss', function: (){
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

  void showAlertOfTypeMessageWithTwoButtons(String msg,String btnTilteA,String btnTilteB, BuildContext context, {required Function function}) {
    final ui = CommonUtils();
    AlertDialog alert = AlertDialog(
      content: Wrap(
        children: [
          Center(
            child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              ui.setHeader('Alert',color: AppColors.redDark,size:22,),
              const SizedBox(height: 10,),
              ui.setSubHeader(msg,color: AppColors.base,size: 17),


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


  void showAlertDialogWithOneBoxField(String msg,String btnTilteA,String btnTilteB, BuildContext context,
      {required Function function}) {
    var comment = '';
    final ui = CommonUtils();
    AlertDialog alert = AlertDialog(
      content: Wrap(
        children: [
          Center(
            child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              ui.setHeader('Alert',color: AppColors.redDark,size:22,),
              const SizedBox(height: 10,),
              ui.setSubHeader(msg,color: AppColors.base,size: 15),
              Container(
                // height: 50,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                        Radius.elliptical(10.0, 10.0)),
                    border: Border.all(
                        width: 1.0, color: AppColors.base)),

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
                    autovalidateMode:
                    AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 10),
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
            function(btnTilteA,comment);
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
            function(btnTilteB,comment);

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

  void showAlertAllClear(BuildContext context,{required Function function}) {

    final ui = CommonUtils();
    AlertDialog alert =  AlertDialog(
        content: Wrap(
        children: [
        Column(children: [
        ui.setHeader('All Clear',color: AppColors.green,size:22,),
    const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Image.asset(
              ImagePaths.thumbsup,
              fit: BoxFit.fill,
            ),
          ),

    CommonUtils.baseButton(title: 'Dismiss', function: (){
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


}
