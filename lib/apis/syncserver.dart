import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:truck_tracker/apis/body_maker.dart';
import 'package:truck_tracker/apis/parsing_data.dart';
import 'package:truck_tracker/apis/server_keys.dart';
import 'package:truck_tracker/app_db/dbsql/flagtable/sql_flag_tbl.dart';

import 'package:truck_tracker/app_db/dbsql/loadcheckintable/sql_loaddb.dart';
import 'package:truck_tracker/model/model_flag_data.dart';
import 'package:truck_tracker/model/model_saveloaddoc.dart';
import 'package:truck_tracker/utils/common_methods.dart';
import '../app_db/dbsharedpref/db_sharedpref.dart';
import '../app_db/dbsharedpref/shared_model_precheck.dart';
import '../app_db/dbsql/crud_operations.dart';
import '../app_db/dbsql/flagtable/sql_flag_model.dart';
import '../app_db/dbsql/loadcheckintable/sql_model_checkin_load.dart';
import '../app_db/dbsql/loadcheckintable/sql_model_storeload.dart';
import '../model/model_basic_parse.dart';
import '../model/model_reject_sql.dart';
import '../model/model_server_response.dart';
import '../utils/enumeration_mem.dart';
import '../utils/stringsref.dart';
import 'api_constants.dart';
import 'data_class.dart';


class SyncServer {
  final cmnMeth = CommonMethods();
final controlLoadData = BridgeLoadData();
  Future<EnumServerSyncStatus> syncPendingLoads(List<SqlModelStoreLoad> pendingLoads) async {
    try {
      final body = await   BodyMaker().getAddLoadBody(pendingLoads);

      var provider = Provider.of<DataClass>(Get.context!, listen: false);
      await provider.postData(POSTEndPoints.storeLoad, body, convertToJson: true);

      if (!provider.isConnectionAvail) {
        return EnumServerSyncStatus.networkError;
      } else if (provider.isSuccess) {
        final loadID = await ParseData().parseLoadResponse(provider.responseData?.body);
        if (loadID == null) {
          CommonMethods().showToast('oops no load id received');
          return EnumServerSyncStatus.failed;
        }
        //Update database
        //SqlLoadDB.instance.updateLoadID(mLoadID)
        return EnumServerSyncStatus.success;
      } else {
        return EnumServerSyncStatus.failed;
      }

    } catch (e) {
      CommonMethods().showToast('Found Error $e');
      return EnumServerSyncStatus.failed;
    }
  }
  Future<String?> syncLoad(SqlModelStoreLoad loadData) async {
    try {
//       final body = await  BodyMaker().getAddLoadBody(loadData);
//
// print("add load body is $body");
//   //    return null;
//       var provider = Provider.of<DataClass>(Get.context!, listen: false);
//       await provider.postData(POSTEndPoints.storeLoad, body,
//           convertToJson: true);
//       // // isRequesting =  provider.loading;
//       if (!provider.isConnectionAvail) {
//         CommonMethods().showToast('No network');
//         return null;
//       } else if (provider.isSuccess) {
//         final loadID = parseLoadResponse(provider.responseData?.body);
//         if (loadID == null) {
//           CommonMethods().showToast('oops no load id received');
//         }
//         return loadID;
//       } else {
//         return null;
//       }
      return null;
    } catch (e) {
      cmnMeth.showToast('Found Error $e');
      return null;
    }
  }
Future<EnumServerSyncStatus> syncCheckInRejection(
    ModelCheckInRejectionSql modelData )async {

    try {
      final filePath = modelData.photoLink;
      final userID = await DBSharedPref.instance.getUserID();
      Map<String, String> body = {
        ServerKeys.author: userID,
        'id': modelData.refID,
        'reason': modelData.reason,
      };
      print('Body $body');
      if(filePath.isEmpty){

        // var provider = Provider.of<DataClass>(Get.context!, listen: false);
        // await provider.postData(POSTEndPoints.cancelload, body,
        //     convertToJson: true);
        //
        // if (provider.isSuccess) {
        //   final status = _parseBasicResponse(provider.responseData?.body);
        //   if(status == EnumServerSyncStatus.success){
        //     //update db
        //     SqlLoadDB.instance.updateInCheckInTableWithoutReturn(operation: CRUDCheckINUpdate.updateRejectionSynced, receivedRefID: modelData.refID);
        //    // SqlLoadDB.instance.updateCheckInRejection();
        //   }
        //   return status;
        //
        // } else {
        //   return EnumServerSyncStatus.failed;
        // }
        return EnumServerSyncStatus.failed;
      }else {
        print('found photo link');

        String apiURL = baseURL + 'cancelload';
          Map<String, String> headers = {
            'Content-Type': 'multipart/form-data',
          };
//         final GetConnect _connect = GetConnect(
//           // the request will fail if it takes more than 10 seconds
//           // you can use another value if you like
//           timeout: const Duration(seconds: 30),
//         );
//
// // construct form data
// // you can upload multiple files in a single POST request
//         final file = File(filePath);
//         final FormData _formData = FormData({
//           'image': MultipartFile(
//               file, filename:'reject.jpg'),
//           // 'file2': MultipartFile(File('path to file 2'), filename: 'kindacode.png'),
//           // 'file3': MultipartFile(File('path to file 3'), filename: 'kindacode.gif'),
//           'body': {body}
//         });
//
// // Send FormData in POST request to upload file
//
//         final Response res =  await _connect.post(apiURL, _formData, headers: {
//           'Content-Type': 'multipart/form-data',
//         });
//         // Do something with the response
//         print('RESPONSE ${res.body}');
//         print('res.status ${res.status.code}');
//         if(res != null && res.status.code == 200){
//           print('200000');
//           return  _parseBasicResponse(res.bodyString);
//         //  return EnumServerSyncStatus.success;
//         }
//           else {
//           return EnumServerSyncStatus.failed;
//         }



          var request = http.MultipartRequest('POST', Uri.parse(apiURL))
            ..fields.addAll(body)
            ..headers.addAll(headers)
            ..files.add(await http.MultipartFile.fromPath('image', filePath));
          var response = await request.send();

          var responseData = await  response.stream.toStringStream();
      //  var responseString = String.fromCharCodes(responseData);
      //   print('Responseokokoko ${responseData}');
      //   print('response.statusCode ${response.statusCode}');
        if(response.statusCode==200){
         SqlLoadDB.instance.updateInCheckInTableWithoutReturn(operation: CRUDCheckINUpdate.updateRejectionSynced, receivedRefID: modelData.refID);

          return EnumServerSyncStatus.success;
        } else {

          return EnumServerSyncStatus.failed;
        }
        // final status = await  response.stream..transform(utf8.decoder).listen((event) {
        //    print('Response ${event}');
        //     if (response.statusCode == 200) {
        //       //return EnumServerSyncStatus.success;
        //     //  SqlLoadDB.instance.updateInCheckInTableWithoutReturn(operation: CRUDCheckINUpdate.updateRejectionSynced, receivedRefID: modelData.refID);
        //
        //
        //     } else {
        //       //return EnumServerSyncStatus.failed;
        //     }
        //   });
          return EnumServerSyncStatus.complete;
        }



    } catch (e) {
      print('crash $e');
      cmnMeth.showToast('${StringsRef.errorWhileRequesting} $e');
      return EnumServerSyncStatus.failed;
    }

}

  Future<bool> syncCheckINRejectionWithoutPhoto(
      String id, String reason) async {
    try {
      cmnMeth.showToast('Rejecting load');
      var provider = Provider.of<DataClass>(Get.context!, listen: false);
      //  final body = ModelCancelLoad(id, reason);
      final userID = await DBSharedPref.instance.getUserID();
      Map<String, String> body = {
        ServerKeys.author: userID,
        'id': id,
        'reason': reason,
      };
      await provider.postData(POSTEndPoints.cancelload, body,
          convertToJson: true);

      if (!provider.isConnectionAvail) {
        // cmnMeth.showToast('Ready to add in sysnc');
        // return EnumServerSyncStatus.networkError;
        return false;
      } else if (provider.isSuccess) {
        final status = _parseBasicResponse(provider.responseData?.body);
        if (status == EnumServerSyncStatus.success) {
          cmnMeth.showToast(StringsRef.rejectionsubmitsuccess);
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      cmnMeth.showToast('${StringsRef.errorWhileRequesting} $e');
      return false;
    }
  }

  void syncCheckINRejectionWithPhoto(
      String licenseNo, String reason, String filepath,
      {required Function function}) async {
    try {
      String addimageUrl = baseURL+'cancelload';
      // String addimageUrl =
      //     'https://trucker.eluladev.space/public/api/cancelload';
      Map<String, String> headers = {
        'Content-Type': 'multipart/form-data',
      };
      final userID = await DBSharedPref.instance.getUserID();
      Map<String, String> body = {
        ServerKeys.author: userID,
        'id': licenseNo,
        'reason': reason,
      };
      var request = http.MultipartRequest('POST', Uri.parse(addimageUrl))
        ..fields.addAll(body)
        ..headers.addAll(headers)
        ..files.add(await http.MultipartFile.fromPath('image', filepath));
      var response = await request.send();

      response.stream.transform(utf8.decoder).listen((event) {
        if (response.statusCode == 200) {
          function(true);

        } else {
          function(false);
        }
      });
    } catch (e) {
      CommonMethods().showToast(e.toString());
      function(false);
    }
  }

  Future<String?> syncCancelLoad(SqlModelStoreLoad loadData) async {
    try {
      final userID = await DBSharedPref.instance.getUserID();
      Map<String, String> body = {
        ServerKeys.author: userID,
        ServerKeys.license_no: loadData.license_no!,
        ServerKeys.vehicle_reg_no: loadData.vehicle_reg_no!,
        ServerKeys.make: loadData.make!,
        ServerKeys.vin: loadData.vin!,
        ServerKeys.engine_no: loadData.engine_no!,
        ServerKeys.date_of_expiry: loadData.date_of_expiry!,
        ServerKeys.driver_name: loadData.driver_name!,
        ServerKeys.driver_no: loadData.driver_no!,
        ServerKeys.updated_at: loadData.updated_at!,
        ServerKeys.created_at: loadData.created_at!,
        ServerKeys.seal: loadData.seal!,
        ServerKeys.trailer: loadData.trailer!,
        ServerKeys.refID: loadData.ref_id!,
      };

      var provider = Provider.of<DataClass>(Get.context!, listen: false);
      await provider.postData(POSTEndPoints.storeLoad, body,
          convertToJson: true);
      // // isRequesting =  provider.loading;
      if (!provider.isConnectionAvail) {
        CommonMethods().showToast('No network');
        return null;
      } else if (provider.isSuccess) {
        final loadID = ParseData().parseLoadResponse(provider.responseData?.body);
        if (loadID == null) {
          CommonMethods().showToast('oops no load id received');
        }
        return loadID;
      } else {
        return null;
      }
    } catch (e) {
      cmnMeth.showToast('Found Error $e');
      return null;
    }
  }

  //Load sync func end

  /* REPORT SYNC FUNCTONALITY
  * Report could be sync withimage or without image so two methods added here
  * Please improve methods as required
  * but keep basic response same   *
  * */
  Future<EnumServerSyncStatus> syncReports(List<SQLModelFlag> reports) async {
    try {
      // Future.forEach(elements, (element) => null
      late EnumServerSyncStatus status;
      for (SQLModelFlag element in reports) {
        status = await _performSyncReport(element);
        if (status == EnumServerSyncStatus.networkError) {
          break;
        } else if (status == EnumServerSyncStatus.success) {
          SQLTableFlag.instance.updateSync(0, element.reportRef);
        }
      }
      return status;
    } catch (e) {
      return EnumServerSyncStatus.failed;
    }
  }

  Future<EnumServerSyncStatus> _performSyncReport(SQLModelFlag report) async {
    try {
     final body = await  BodyMaker().getReportBody(report);

      print('_performSyncReport body ${body}');
      var provider = Provider.of<DataClass>(Get.context!, listen: false);
      await provider.postData(POSTEndPoints.saveReport, body,
          convertToJson: true);
      if (!provider.isConnectionAvail) {
        return EnumServerSyncStatus.networkError;
      } else if (provider.isSuccess) {
        final responseBody = provider.responseData?.body;
        print('Response body $responseBody');
        if (responseBody == null) {
          cmnMeth.printDebugError('Response null');
          return EnumServerSyncStatus.failed;
        } else {
          try {
            final pp =
                jsonDecode(responseBody); // event as Map<String, dynamic>;
            final parsedData = ModelBasicParse.fromJson(pp);

            if (parsedData.statusCode == 1) {
              return EnumServerSyncStatus.success;
            } else {
              cmnMeth.showToast(parsedData.message);
              return EnumServerSyncStatus.failed;
            }
          } catch (e) {
            cmnMeth.printDebugError('Parsing error $e');
            return EnumServerSyncStatus.failed;
          }
        }

        //cmd.showToast('Report Submitted successfully');
        return EnumServerSyncStatus.success;
      } else {
        return EnumServerSyncStatus.failed;
      }
    } catch (e) {
      return EnumServerSyncStatus.failed;
    }
  }

  Future<EnumServerSyncStatus> syncReportsMultiPart(
      List<SQLModelFlag> arrayOfMultiPartReports) async {
    try {
      // Future.forEach(elements, (element) => null
      late EnumServerSyncStatus status;
      for (SQLModelFlag element in arrayOfMultiPartReports) {
        //  print('Total images in report ${element.imageUrls?.length}');
        element.imageUrls?.forEach((element) {
          print(element);
        });
        // status = await performSyncReportMultipart(element);
        status = await _performSyncReportMultipart(element, functin: (value) {
          if (value == true) {
            CommonMethods().showToast('Ready to disable sync');
            SQLTableFlag.instance.updateSync(0, element.reportRef);
          } else {
            CommonMethods().showToast('Found error');
          }
        });
        if (status == EnumServerSyncStatus.networkError) {
          break;
        }

        if (status == EnumServerSyncStatus.success) {
          CommonMethods().showToast('Success multipart');
          //   SQLTableFlag.instance.updateSync(0, element.reportRef);
        }
      }
      return status;
    } catch (e) {
      return EnumServerSyncStatus.failed;
    }
  }

  Future<EnumServerSyncStatus> _performSyncReportMultipart(SQLModelFlag report,
      {required Function functin}) async {
    try {
      final body = await BodyMaker().bodyOfSyncReport(report);
      if (body == null) {
        return EnumServerSyncStatus.failed;
      }

      String addImageUrl = baseURL + "save-report";

      Map<String, String> headers = {
        'Content-Type': 'multipart/form-data',
      };
      List<String> paths = [];
      report.imageUrls?.forEach((element) {
        final path = element as String;
        // final path = await FlutterAbsolutePath.getAbsolutePath(element);
        paths.add(path);
      });
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

      print(
          ':::::::::::::::::::::::::::::::::DONE UPTO HERE::::::::::::::::::::::::');
      // return EnumServerSyncStatus.failed;

      var request = http.MultipartRequest('POST', Uri.parse(addImageUrl))
        ..fields.addAll(body)
        ..headers.addAll(headers)
        ..files.addAll(fileList);

      /// CommonMethods().showToast('Paths are ${paths.length}');

      var response = await request.send();
      // var ll =  response.stream.transform(utf8.decoder);
      response.stream.transform(utf8.decoder).listen((event) {
        print(event);
        //CommonMethods().showToast('event $event');
        try {
          final pp = jsonDecode(event); // event as Map<String, dynamic>;
          final parsedData = ModelBasicParse.fromJson(pp);
          CommonMethods().showToast("Message: ${parsedData.message}", true);
          if (parsedData.statusCode == 1) {
            functin(true);
          } else {
            //indicatorReportMultiPart.value = false;
            functin(false);
          }
        } catch (e) {
          CommonMethods().showToast('Parsing Error $e');
        }
      });
      if (response.statusCode == 200) {
        // final responseString = response.reasonPhrase.
        return EnumServerSyncStatus.complete;
      } else {
        return EnumServerSyncStatus.failed;
      }
    } catch (e) {
      return EnumServerSyncStatus.failed;
    }
  }

  Future<EnumServerSyncStatus> syncPendingFlagData(ModelFlagData flagData)async  {
    try {
      final body = await BodyMaker().getBodyOfSyncReport(flagData);
      if (body == null) {
        return EnumServerSyncStatus.failed;
      }

      String addImageUrl = baseURL + "save-report";

      Map<String, String> headers = {
        'Content-Type': 'multipart/form-data',
      };
      List<String> paths = [];
      flagData.images?.forEach((element) {
        final path = element as String;
        // final path = await FlutterAbsolutePath.getAbsolutePath(element);
        paths.add(path);
      });
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

      print( ':::::::::::::::::::::::DONE UPTO HERE::::::::::::::::::::::::');
      // return EnumServerSyncStatus.failed;

      var request = http.MultipartRequest('POST', Uri.parse(addImageUrl))
        ..fields.addAll(body)
        ..headers.addAll(headers)
        ..files.addAll(fileList);

      /// CommonMethods().showToast('Paths are ${paths.length}');

      var response = await request.send();
      var responseData = await  response.stream.toStringStream();
      //  var responseString = String.fromCharCodes(responseData);
        print('Responseokokoko ${responseData}');
      responseData.forEach((element) {
        print('Response element  ${element}');
      });
      //   print('response.statusCode ${response.statusCode}');
      if(response.statusCode==200){
        SQLTableFlag.instance.updateWithoutReturn(operation: CRUDFlagUpdate.updateRejectionSynced, receivedRefID: flagData.refID);

        return EnumServerSyncStatus.success;
      } else {

        return EnumServerSyncStatus.failed;
      }

    } catch (e) {
      print('Crashed at syncPendingFlagData $e');
      return EnumServerSyncStatus.failed;
    }
  }

  //::::::::::::::REPORT SYNC ENDED:::::::::::::::::::::::::
//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

  /*
  * This is the basic response parsing expected from every api..
  * Please ensure it from the backend...
  * */

  EnumServerSyncStatus _parseBasicResponse(String? responseBody) {
   // print('RESPONSE:::::::::: $responseBody');
    try {
      if (responseBody == null) {
        cmnMeth.showToast('Parsing error null response');
        return EnumServerSyncStatus.failed;
      } else {
        final pp = jsonDecode(responseBody);
        final parsedData = ModelBasicParse.fromJson(pp);

        if (parsedData.statusCode == 1) {
          cmnMeth.showToast(parsedData.message);
          return EnumServerSyncStatus.success;
        } else {
          cmnMeth.showToast(parsedData.message);
          return EnumServerSyncStatus.failed;
        }
      }
    } catch (e) {
      cmnMeth.printDebugError('Parsing error $e');
      return EnumServerSyncStatus.failed;
    }
  }

//::::::::::::::::::::::::::::::::CHECK IN PROCESSING ::::::::::::::;;
  Future<EnumServerSyncStatus> syncCheckIN({required List<SqlModelCheckIn> pendingCheckINData}) async {
    try {
      CommonMethods().showToast('Check-In Started');
    final body =  await BodyMaker().getBodyOfCheckIn(pendingCheckINData);
    if(body ==null){
      return  EnumServerSyncStatus.failed;
    }
    //  return  EnumServerSyncStatus.failed;
      var provider = Provider.of<DataClass>(Get.context!, listen: false);
      await provider.postData(POSTEndPoints.checkInProcess, body,
          convertToJson: true);

      if (!provider.isConnectionAvail) {
        CommonMethods().showToast('No network');
        return EnumServerSyncStatus.networkError;
      }
      if (provider.isSuccess) {
        final response = provider.responseData?.body;
        if(response == null){
          return EnumServerSyncStatus.failed;
        }else{
          final checkInResponse = ParseData().parseCheckINData(response);
        }

        final status = _parseBasicResponse(response);
        return status;
      } else {
        CommonMethods().printDebugError(provider.responseData?.statusCode);
        CommonMethods().showToast('Error while syncing. ${provider.responseData?.body } ${provider.responseData?.statusCode} ');
        return EnumServerSyncStatus.failed;
      }
    } catch (e) {
      CommonMethods().showToast('Error while syncing. $e');
      return EnumServerSyncStatus.failed;
    }
  }

//::::::::::::::::::::::PRE CHECK::::::::::::::
  Future<ModelServerResponse> syncPreCheckProcess(String license_no) async {
    final body = await  BodyMaker().bodyOfPreCheckProcess(license_no);
    final returnObj = ModelServerResponse(status: EnumServerSyncStatus.success, data: null);
    var provider = Provider.of<DataClass>(Get.context!, listen: false);
    await provider.postData(POSTEndPoints.precheck, body, convertToJson: true);

    if (!provider.isConnectionAvail) {
      returnObj.status = EnumServerSyncStatus.failed;
      return returnObj;
    } else {
      if (provider.isSuccess) {
        if (provider.responseData?.body != null) {
          // returnObj.status  = EnumServerSyncStatus.success;
          returnObj.data = provider.responseData?.body;
          return returnObj;
          // parsePreCheckResponse(provider.responseData!.body);
        } else {
          returnObj.status = EnumServerSyncStatus.failed;
          return returnObj;
        }
      } else {
        returnObj.status = EnumServerSyncStatus.failed;
        return returnObj;
      }
    }
  }

  Future<EnumServerSyncStatus> syncPreCheckUpdation(
      SharedModelPreCheck preCheckData) async {
    try {
      // final loadID = await SqlLoadDB.instance.getLoadID();
      if (preCheckData.loadID!.isEmpty) {
        // DBSharedPref.instance.setPreCheck(comment);
        cmnMeth.showToast('Load not available');
        return EnumServerSyncStatus.failed;
      } else {
        ///  SQLTableFlag.instance.deleteAllReports();
        final body = await   BodyMaker().bodyOfPreCheckUpdation(preCheckData);


        var provider = Provider.of<DataClass>(Get.context!, listen: false);
        await provider.postData(POSTEndPoints.updateprecheck, body,
            convertToJson: true);

        if (!provider.isConnectionAvail) {
          DBSharedPref.instance.setPreCheck(preCheckData);
          // cmnMeth.showToast('Load not available');
          return EnumServerSyncStatus.networkError;
        } else {
          if (provider.isSuccess) {
            DBSharedPref.instance.cancelPreCheck();
            return EnumServerSyncStatus.success;
          } else {
            DBSharedPref.instance.setPreCheck(preCheckData);
            return EnumServerSyncStatus.failed;
          }
        }
      }
    } catch (e) {
      cmnMeth.showToast('Error while performing pre-check $e');
      return EnumServerSyncStatus.failed;
    }
  }

  Future<EnumServerSyncStatus>  syncPendingFilesOfLoads(List<ModelSaveLoadDoc> pendingLoadsFilesToSync)async {
    try {

        ///  SQLTableFlag.instance.deleteAllReports();
        final body = await   BodyMaker().getSaveLoadDocBody(pendingLoadsFilesToSync);
print('------------BODY-----------');
print(body);
   var provider = Provider.of<DataClass>(Get.context!, listen: false);
        await provider.postData(POSTEndPoints.saveloaddocument, body,
            convertToJson: true);

        if (!provider.isConnectionAvail) {

          return EnumServerSyncStatus.networkError;
        } else {
          if (provider.isSuccess) {
          final status = await   _parseBasicResponse(provider.responseData?.body);
          //  print('SAVE documnet data ${provider.responseData?.body}');
            List<String> loads = [];
            pendingLoadsFilesToSync.forEach((element) {
              loads.add(element.loadID);
            });
           SqlLoadDB.instance.updateFileSyncForFollowingLoads(loads);
            return status;
          } else {

            return EnumServerSyncStatus.failed;
          }
        }

    } catch (e) {
      cmnMeth.showToast('Error while performing savedocument $e');
      return EnumServerSyncStatus.failed;
    }

  }

}

class BridgeLoadData {
  Future<EnumServerSyncStatus> syncPendingLoads(List<SqlModelStoreLoad> pendingLoads) async {
    try {
      final body = await   BodyMaker().getAddLoadBody(pendingLoads);

      var provider = Provider.of<DataClass>(Get.context!, listen: false);
      await provider.postData(POSTEndPoints.storeLoad, body, convertToJson: true);

      if (!provider.isConnectionAvail) {
        return EnumServerSyncStatus.networkError;
      } else if (provider.isSuccess) {
        final loadID = ParseData().parseLoadResponse(provider.responseData?.body);
        if (loadID == null) {
          CommonMethods().showToast('oops no load id received');
          return EnumServerSyncStatus.failed;
        }
        //Update database
        //SqlLoadDB.instance.updateLoadID(mLoadID)
        return EnumServerSyncStatus.success;
      } else {
        return EnumServerSyncStatus.failed;
      }

    } catch (e) {
      CommonMethods().showToast('Found Error $e');
      return EnumServerSyncStatus.failed;
    }
  }
}
