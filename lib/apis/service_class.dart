import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;


Future<http.Response?>  requestPost(String url, dynamic data , bool convertToJson) async{
   Fluttertoast.showToast(msg: "$url");
  //  Fluttertoast.showToast(msg: "${data}");
  // Fluttertoast.showToast(msg: "${convertToJson}");
  http.Response? response;
  var resBody = '';
  if(!convertToJson){
    resBody =  jsonEncode(data.toJson());
  }else{
    resBody = jsonEncode(data);
  }
  try{
    response = await http.post(Uri.parse(url),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        },
        body:  resBody);
  }catch(e){
    Fluttertoast.showToast(msg: e.toString());
    log(e.toString());
  }
 //Fluttertoast.showToast(msg: "${response?.body.toString()}");
 // log("${response?.body.toString()}");
  return response;
}


Future<http.Response?>  requestGet(String url  ) async{

  //  CommonMethods().showToast(apiURL);
  http.Response? response;
  try{
    response = await http.post(Uri.parse(url),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        },
        );
  }catch(e){
    Fluttertoast.showToast(msg: "catch error ${e.toString()}");
    log(e.toString());
  }
  //Fluttertoast.showToast(msg: "showing body ${response?.body.toString()}");
// log("${response?.body.toString()}");
  return response;
}

// Future<bool> submitReasonMultipart(Map<String, String> body, String filepath) async{
//
//   String addimageUrl = 'https://trucker.eluladev.space/public/api/cancelload';
//   Map<String, String> headers = {
//     'Content-Type': 'multipart/form-data',
//   };
//   var request = http.MultipartRequest('POST', Uri.parse(addimageUrl))
//     ..fields.addAll(body)
//     ..headers.addAll(headers)
//     ..files.add(await http.MultipartFile.fromPath('image', filepath));
//   var response = await request.send();
//   if (response.statusCode == 200) {
//     return true;
//   } else {
//     return false;
//   }
//
//
// }
// Future<bool> submitReportMultiPart(Map<String, String> body, String filepath) async{
//
//   String addimageUrl = 'https://trucker.eluladev.space/public/api/save-report';
//   Map<String, String> headers = {
//     'Content-Type': 'multipart/form-data',
//   };
//   var request = http.MultipartRequest('POST', Uri.parse(addimageUrl))
//     ..fields.addAll(body)
//     ..headers.addAll(headers)
//     ..files.add(await http.MultipartFile.fromPath('image', filepath));
//   var response = await request.send();
//   if (response.statusCode == 200) {
//     return true;
//   } else {
//     return false;
//   }
//
//
// }

/*
*
* Future<http.Response?>  requestSignIN(String endPoint, ModelSignIn data) async{
  const baseURL = "https://trucker.eluladev.space/public/api/";

  http.Response? response;
  try{
    response = await http.post(Uri.parse("$baseURL$endPoint"),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        },
        body: jsonEncode(data.toJson()));
  }catch(e){
    log(e.toString());
  }
  Fluttertoast.showToast(msg: "${response?.body.toString()}");
  // log("${response?.body.toString()}");
  return response;
}
* */
