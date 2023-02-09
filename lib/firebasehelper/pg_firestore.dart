
import 'package:flutter/material.dart';
import 'package:truck_tracker/firebasehelper/util_firebase_storage.dart';

class PageFireStore extends StatelessWidget {



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(child:

      Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(children: [
              TextButton(onPressed: checkPendingLoadPODFiles, child: Text('checkPendingLoadFiles'))
            ],)
          ],
        ),
      ),
      )

    );
 }

  void checkPendingLoadPODFiles() {

    UtilFireStorage().checkPendingLoadPODFiles();
  }
}