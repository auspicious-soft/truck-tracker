import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:truck_tracker/apis/network_util.dart';
import 'package:truck_tracker/apis/service_class.dart';
import '../model/errordata.dart';
import '../utils/app_pops.dart';
import '../utils/common_methods.dart';
import '../utils/enumeration_mem.dart';
import 'api_constants.dart';


class DataClass extends ChangeNotifier {
  bool isConnectionAvail = true;
  bool loading = false;
  bool isSuccess = false;
  http.Response? responseData;
  String? responseMultiPartData;
  Future<void> postData(POSTEndPoints endPts, dynamic body,{convertToJson = false}) async {
    try{
      final fullURL = _getHttpPath(endPts);
//rCommonMethods().showToast('$fullURL');
      isSuccess = false;
      // loading = false;
      //CHECK NETWORK
      var con = await NetworkUtil().checkInternet();
      //CommonMethods().showToast('$con');
      isConnectionAvail = con;
      if (con) {
        loading = true;
        notifyListeners();
       http.Response response = (await requestPost(fullURL, body,convertToJson))!;
       if (response.statusCode == 200) {
          isSuccess = true;
          responseData = response;
          //notifyListeners();
        } else {
          parseError(response);
        }
        loading = false;
        notifyListeners();
      }else{
        CommonMethods().showToast('No connection found');
      }
    }catch(e){

     // Fluttertoast.showToast(msg: 'Some internal error $e');
      loading = false;
      notifyListeners();
    }

  }

  Future<void> postMultiPartSingleData(String filePath,POSTEndPoints endPts, dynamic body) async {
    try{
      final fullURL = _getHttpPath(endPts);
      isSuccess = false;
       var con = await NetworkUtil().checkInternet();
      isConnectionAvail = con;
      if (con) {
        loading = true;
        notifyListeners();
      //::::::::::::::::MULTIPART FUNCTIONALITY::::::::::::;;;;
        try {
          Map<String, String> headers = {
            'Content-Type': 'multipart/form-data',
          };

          var request = http.MultipartRequest('POST', Uri.parse(fullURL))
            ..fields.addAll(body)
            ..headers.addAll(headers)
            ..files.add(await http.MultipartFile.fromPath('image', filePath));
          var response = await request.send();

          response.stream.transform(utf8.decoder).listen((event) {
            if (response.statusCode == 200) {
              isSuccess = true;
              responseMultiPartData = event;

            } else {
              _parseMultiPartError(event);
            }
            loading = false;
            notifyListeners();
          });
        } catch (e) {
          CommonMethods().showToast(e.toString());
          loading = false;
          notifyListeners();
        }
        //::::::::::::::::::::END::::::::::::::::;


      }
    }catch(e){
      CommonMethods().showToast(e.toString());
      loading = false;
      notifyListeners();
    }

  }
  Future<void> postMultiPartArrayData(Map<String, String> body,
      List<String> imagesUrls) async {
    try {
      // Future.forEach(elements, (element) => null
      late EnumServerSyncStatus status;
      imagesUrls.forEach((path) async {
            Map<String, String> headers = {
                'Content-Type': 'multipart/form-data', };

            List<String> paths = [];
                  // final path = await FlutterAbsolutePath.getAbsolutePath(element);
                  paths.add(path);

                  List<http.MultipartFile> fileList = [];

                   for (var singlePath in paths) {
                          File imageFile = File(singlePath);
                          // print('img Filee $imageFile');
                          var stream = http.ByteStream(imageFile.openRead());
                          var length = await imageFile.length();
                          var multipartFile = http.MultipartFile('image', stream, length,
                              filename: imageFile.path);
                          fileList.add(multipartFile);
                        }













      });





























    } catch (e) {
        EnumServerSyncStatus.failed;
    }
  }



  Future<void> postGet(POSTEndPoints endPts) async {
    try{
final fullUrl = _getHttpPath(endPts);
      isSuccess = false;
      //CHECK NETWORK
      var con = await NetworkUtil().checkInternet();
      isConnectionAvail = con;
      if (con) {
        loading = true;
        notifyListeners();
        http.Response response = (await requestGet(fullUrl))!;
        if (response.statusCode == 200) {
          isSuccess = true;
          responseData = response;
        } else {
          parseError(response);
        }
        loading = false;
        notifyListeners();
      }
    }catch(e){

      // Fluttertoast.showToast(msg: 'Some internal error $e');
      loading = false;
      notifyListeners();
    }

  }
  String _getHttpPath(POSTEndPoints endPt){
    var url = baseURL;
    switch (endPt) {
      case POSTEndPoints.login:
      //  Fluttertoast.showToast(msg: 'case login $endPoint');
        return url+'login';

      case POSTEndPoints.locationDetails:
      //   Fluttertoast.showToast(msg: 'case locationDetails $endPoint');
        return url+'location-details';

      case POSTEndPoints.loadLicenseDetails:
      //  Fluttertoast.showToast(msg: 'case loadLicenseDetails $endPoint');
        return url+'load-license-details?"';

      case POSTEndPoints.storeLoad:
      // Fluttertoast.showToast(msg: 'case storeload $endPoint');
        return url+'store-load';

      case POSTEndPoints.checkInProcess:
        return url+'check-in-process';

      case POSTEndPoints.cancelload:
        return url+'cancelload';

      case POSTEndPoints.saveReport:
        return url+'save-report';

      case POSTEndPoints.precheck:
        return url+"precheck";

      case POSTEndPoints.updateprecheck:
        return url+"updateprecheck";

      case POSTEndPoints.getreport:
        return url+'getreport';
      case POSTEndPoints.getload:
        return url+'getload';
      case POSTEndPoints.saveloaddocument:
        return url+'saveloaddocument';
    }

  }
  void parseError(http.Response response) {
    // {"message":"The device name field is required.","errors":{"device_name":["The device name field is required."]}}
print(response.body);
Fluttertoast.showToast(msg: response.toString());
    try {
      final jsonData = response.body;
      final parsedJson = jsonDecode(jsonData);
      final parsedData = ErrorData.fromJson(parsedJson);
      Fluttertoast.showToast(msg: parsedData.message);
      // if(Get.context != null){
      //   AppPops().showAlertOfTypeMessage('${parsedData.message}', Get.context!);
      // }

    } catch (e) {

      Fluttertoast.showToast(msg: 'Received Error while parsing...');
    }
  }
  void _parseMultiPartError(String response) {
    // {"message":"The device name field is required.","errors":{"device_name":["The device name field is required."]}}
    print(response);
    Fluttertoast.showToast(msg: response.toString());
    try {
      final jsonData = response;
      final parsedJson = jsonDecode(jsonData);
      final parsedData = ErrorData.fromJson(parsedJson);
      Fluttertoast.showToast(msg: parsedData.message);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Received Error while parsing...');
    }
  }
}
