import 'package:flutter/material.dart';
import 'package:truck_tracker/utils/app_colors.dart';
import 'package:velocity_x/velocity_x.dart';

showProgress(
  BuildContext context,
) {
  //:::::::::::::::::::::::::::::WIDGETS::::::::::::::::::::::

  //:::::::::::::::::::::::::::::::::END WIDGETS:::::::::::::::::::::::::
  final marginTop = const SizedBox(
    height: 10,
  );

  // void finishpopup() {
  //   Navigator.pop(context);
  //   callOnfinished();
  // }

  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(30.0),
        child: Scaffold(
           backgroundColor: Colors.transparent,
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                marginTop,
                'Please wait...'.text.color(AppColors.white).make()
              ],
            ),
          ),
        ),
      );
    },
  );
}
/*
* Align(
                alignment: Alignment.center,
                      child: Container(
                        color: Colors.transparent,
                        child:  Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                           // crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                          const CircularProgressIndicator(
                            backgroundColor: Colors.red,
                          ),
                              'Signing.....'.text.normal.size(14).color(Colors.white).make()]),
                      ),
                    )
* */
 showWaitingDialog(BuildContext context, String message){
  AlertDialog alert = AlertDialog(
    content: Row(children: [
      CircularProgressIndicator(
        backgroundColor: Colors.red,
      ),
      Container(margin: EdgeInsets.only(left: 7), child: Text(message)),
    ]),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
showProgressb(
    BuildContext context,
    String title
    ) {
  AlertDialog alert = AlertDialog(
    content: Row(children: [
      CircularProgressIndicator(
        backgroundColor: Colors.red,
      ),
      Container(margin: EdgeInsets.only(left: 7), child: Text(title)),
    ]),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );


}
