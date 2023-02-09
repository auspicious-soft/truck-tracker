import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:truck_tracker/app_db/dbsharedpref/db_sharedpref.dart';
import 'package:truck_tracker/model/modeldatadetails.dart';
import '../model/model_license_data.dart';
import 'enumeration_mem.dart';

class CommonMethods {
  CommonMethods._privateConstructor();

  static final CommonMethods _instance = CommonMethods._privateConstructor();

  factory CommonMethods() {
    return _instance;
  }
//:::::::::::::::GLOBAL TOAST::::::::::::::::::::
showToast(dynamic msg, [bool delay = false]) {
    if (delay) {
      Fluttertoast.showToast(msg: '$msg', toastLength: Toast.LENGTH_LONG);
    } else {
      Fluttertoast.showToast(msg: '$msg');
    }
  }
//LICENSE SERVICES CLASSES::
  Future<String> scanQR() async {
    try {
      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.QR);
      print(barcodeScanRes);

      if (barcodeScanRes.isNotEmpty) {
        if (barcodeScanRes.length > 3) {
          return barcodeScanRes;
        } else {
          showToast('Invalid code.');
          return '';
        }
      }
    } catch (e) {
      showToast('Invalid code.');
      return '';
    }
    showToast('Invalid code.');
    return '';
  }
  ModelLicenseData? getLicenseData(String barcodeScanRes) {
    try {
      var data = barcodeScanRes
          .split('%') // split the text into an array
          .map((String text) => text) // put the text inside a widget
          .toList();

      //  print('$data');
      data.removeAt(0);
      //  showSimpleAlert(data.toString(),context);
      // Fluttertoast.showToast(msg:'Invalid QRCode ${data.length}');
      if (data.length < 10) {
        Fluttertoast.showToast(msg: 'Invalid QRCode  ');
        return null;
      } else {
        final number = data[4];
        final licenseNo = data[5].toString();
        final vehRegNo = data[6].toString();
        final vin = data[11].toString();
        final engineno = data[12].toString();
        final make = data[8].toString();
        final description = data[7].toString();
        final expirydate = data[13].toString();
        final obj = ModelLicenseData(number, licenseNo, vehRegNo, vin, engineno,
            '', '', '', make, description, '', '', '', expirydate);

        return obj;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'getting crash $e ');
      return null;
    }
  }

  List<ModelDataDetails> getStructuredLicenseData(ModelLicenseData vehData) {

    List<ModelDataDetails> objVehLicenseData = [];
    try {
      var objInnerData = ModelDataDetails('License no', vehData.licenseno);
      objVehLicenseData.add(objInnerData);
      //objInnerData = ModelDataDetails('Veh register no.', vehData.vehregno);
     // objVehLicenseData.add(objInnerData);
      objInnerData = ModelDataDetails('Make', vehData.make);
      objVehLicenseData.add(objInnerData);
      objInnerData = ModelDataDetails('Vin', vehData.vin);
      objVehLicenseData.add(objInnerData);
      objInnerData = ModelDataDetails('Engine no', vehData.engineno);
      objVehLicenseData.add(objInnerData);
      // Fluttertoast.showToast(msg: 'Expiry validate ${vehData.expirydate}');
      objInnerData = ModelDataDetails('Date of expiry', vehData.expirydate);
      objVehLicenseData.add(objInnerData);
      return objVehLicenseData;
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: 'Exception in veh data setup: ${e.toString()}');
      return objVehLicenseData;
    }

  }
//ENDLICENSE SERVICES CLASSES::


  String getRandStr() {
    // const  chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    const chars = 'AQWERTYUIOPLKJHGFDSZXCVBNM1234567890';
    Random rnd = Random();

    String getRandomString(int length) =>
        String.fromCharCodes(Iterable.generate(
            length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));

    return getRandomString(2);
  }

//[type][y][mm][dd][24hr]AA01
  Future<String> getRefID(EnumReferenceType type) async {
    DateTime now = DateTime.now();
    final userID = await DBSharedPref.instance.getUserID();
    final id = DateTime.now().microsecondsSinceEpoch.toString();
    var shortenId = id.substring(7, min(id.length, 10));
    String year = "${now.year}".padLeft(2, '0');
    String month = "${now.month}".padLeft(2, '0');
    String day = "${now.day}".padLeft(2, '0');
    String hour = "${now.hour}".padLeft(2, '0');
    String second = "${now.second}".padLeft(2, '0');
    // String  convertedDateTime = "${now.month.toString().padLeft(2,'0')}${now.day.toString().padLeft(2,'0')}${now.hour.toString().padLeft(2,'0')}${now.minute.toString().padLeft(2,'0')}${now.second.toString().padLeft(2,'0')}";
    String randStr = getRandStr();
    final refIncrement = await DBSharedPref.instance.getRefIncremental();
    String finalID =
        "$year$month$day${hour}$randStr$second$shortenId$userID$refIncrement";
    switch (type) {
      case EnumReferenceType.addLoad:
        return "L$finalID";

      case EnumReferenceType.checkIn:
        return "C$finalID";

      case EnumReferenceType.flag:
        return "F$finalID";

      case EnumReferenceType.preCheckIn:
        return "P$finalID";

      case EnumReferenceType.exit:
        return "Ex$finalID";
      case EnumReferenceType.rejection:
        return "RJ$finalID";
        break;
    }
  }


  String getTimeStamp() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  // checkGPSService() async {
  //   return await Geolocator.isLocationServiceEnabled();
  // }
  //
  // Future<Position?> getGPSLocation(BuildContext context) async {
  //  // Fluttertoast.showToast(msg: 'starting');
  //   final geoLocations = await _determinePosition(context);
  //   final latitude = geoLocations.latitude;
  //   final lngi = geoLocations.longitude;
  //   if (latitude == 0.0) {
  //     Fluttertoast.showToast(msg: 'lati is 0.0');
  //     return null;
  //   } else {
  //     return geoLocations;
  //   }
  // }
  //
  //
  //
  // Future<Position> _determinePosition(BuildContext context) async {
  //   //  bool serviceEnabled;
  //   LocationPermission permission;
  //
  //   ///serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   // if (!serviceEnabled) {
  //   //   Fluttertoast.showToast(msg: 'Please enable location');
  //   //   Geolocator.openLocationSettings();
  //   //
  //   //   return Future.error('Location services are disabled.');
  //   // }
  //
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       // Permissions are denied, next time you could try
  //       // requesting permissions again (this is also where
  //       // Android's shouldShowRequestPermissionRationale
  //       // returned true. According to Android guidelines
  //       // your App should show an explanatory UI now.
  //       Fluttertoast.showToast(msg: 'Location permissions are denied');
  //       return Future.error('Location permissions are denied');
  //     }
  //   }
  //
  //   if (permission == LocationPermission.deniedForever) {
  //     Fluttertoast.showToast(
  //         msg:
  //             'Location permissions are permanently denied, we cannot request permissions.');
  //     // Permissions are denied forever, handle appropriately.
  //     return Future.error(
  //         'Location permissions are permanently denied, we cannot request permissions.');
  //   }
  //
  //   // When we reach here, permissions are granted and we can
  //   // continue accessing the position of the device.
  //   // showProgress(context);
  //   return await Geolocator.getCurrentPosition();
  // }

  String encodeObject(dynamic objData) {
    try {
      return jsonEncode(objData);
    } catch (e) {
      showToast('Error encoding $e');
      return '';
    }
  }

  List<dynamic>? decodeStringInDynamicList(String obj) {
    try {
      //final decodedData = jsonDecode(obj);
      final dynamicList = jsonDecode(obj) as List<dynamic>;
      print('decodedDataaadecodedDataaa $dynamicList');
      return dynamicList;
    } catch (e) {
      print('Error Decoding $e');
      showToast('Error dencoding $e');
      return null;
    }
  }

  String getCreatedAt() {
    return DateTime.now().microsecondsSinceEpoch.toString();
  }

  void printDebugError(dynamic error) {
    print("Error $error");
  }

  ModelLicenseData? decodeIntoLicenseData(String? s) {
    try {
      if (s == null || s.isEmpty) {
        return null;
      }
      //final decodedData = jsonDecode(obj);
      final parsedJson = jsonDecode(s);
      final parsedData = ModelLicenseData.fromJson(parsedJson);
      return parsedData;
    } catch (e) {
      print('Error Decoding $e');
      showToast('Error dencoding $e');
      return null;
    }
  }


  void printException(Object e) {
    print('EXCEPTION:::: $e');
  }

}
