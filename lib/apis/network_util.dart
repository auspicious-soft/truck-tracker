import 'dart:io';
import 'package:truck_tracker/app_db/dbsharedpref/db_sharedpref.dart';
class NetworkUtil {
  //Factory constructor
  NetworkUtil._privateConstructor();

  static final NetworkUtil _instance = NetworkUtil._privateConstructor();

  factory NetworkUtil() {
    return _instance;
  }
 Future<bool> checkInternet() async {
    try {


      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return Future.value(true);
      }else{
        //  Fluttertoast.showToast(msg: 'No Network available');
        return Future.value(false);
      }
    } on SocketException catch (_) {
      // Fluttertoast.showToast(msg: 'No Network available');
      return Future.value(false);
    }
  }
}

