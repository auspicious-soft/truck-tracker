import 'dart:convert';

import 'package:truck_tracker/app_db/dbsql/crud_operations.dart';
import 'package:truck_tracker/app_db/dbsql/loadcheckintable/sql_loaddb.dart';

import '../app_db/dbsql/flagtable/sql_flag_model.dart';
import '../model/model_flag.dart';
import '../utils/common_methods.dart';
import '../utils/trucker_exeptions.dart';

class ParseData{
  //Factory constructor
  ParseData._privateConstructor();

  static final ParseData _instance = ParseData._privateConstructor();

  factory ParseData() {
    return _instance;
  }
  final _cm = CommonMethods();
  SQLModelFlag? parsePreCheckData(String jsonData){
    print(jsonData);
    try {
      final parsedJson = jsonDecode(jsonData);
      final parsedData = ModelFlag.fromJson(parsedJson);
      if(parsedData.statusCode == 1){

        final vehID = parsedData.flagDetail?.vehRegNo;
        final tonTrackId = parsedData.flagDetail?.tontrack;
        final sealID = parsedData.flagDetail?.seal;

        var finalID = '';
        if(vehID != null){
          finalID = vehID;
        }else  if(tonTrackId != null){
          finalID = tonTrackId;
        }else  if(sealID != null){
          finalID = sealID;
        }else{
          CommonMethods().showToast('Founded illegal id');
          return null;
        }


        final obj = SQLModelFlag(id: 0, tonTrackData: '',
            tonTrackID: parsedData.flagDetail?.tontrack, sealData: '',
            sealID: parsedData.flagDetail?.seal, vehData: '', vehID: parsedData.flagDetail?.vehRegNo,
            imageUrls: null, comment: parsedData.flagDetail?.comment,
            reportRef: '', createdAt: '', sync: 0);
return obj;
      }else{
        _cm.showToast( 'No flag found');
        return null;
      }
    } catch (e) {
      _cm.showToast( 'Received Error while parsing... $e\nJson data:$jsonData', true);
      return null;
      //throw UnableJsonParseException(message: e.toString());
      //App

    }
  }

  Future<String?> parseLoadResponse(String? response) async {

    try {
      if (response == null) {
        _cm.showToast('Parsing Error response null.');
        return null;
      }
      final parsedJson = jsonDecode(response);
     // _cm.showToast(parsedJson);
      // AppPops().showAlertOfTypeMessage("$parsedJson", Get.context!);
      print("Parsed data ${parsedJson}");
      final data = parsedJson['data']; // as List<dynamic>;

      if (data.isNotEmpty) {
          final loadData = data  as List<dynamic>;
          for(dynamic load in loadData){
            print('showing load :: $load');
            final lastLoadID = load['id'] as int;
            final refID = load['ref_id'] as String;
            final sqlStatus =   await   SqlLoadDB.instance.updateInLoadTableWithReturn(operation: CRUDLoadUpdate.updateLoadID,
                receivedRefID: refID,
                receivedLoadID: lastLoadID.toString(),
                );

         //   final sqlStatus =   await   SqlLoadDB.instance.updateLoadIDWitReference(receivedLoadID: lastLoadID.toString(), receivedLoadRefID: refID);
           // _cm.showToast('sqlStatus $sqlStatus');
            if(sqlStatus == 0){
              break;
            }
          }
         // loadData.forEach((load) async {

            // print('RefID :: $refID');
         // });
        // final load = data['load'];
        // final lastLoadID = load['id'] as int;

       // _cm.showToast('Load received with id $lastLoadID');
        return null;
      } else {
        final msg = parsedJson['message'];

        //print('Parsing Error response .');
        _cm.showToast('server response message: $msg',true);
        return null;
      }
    } catch (e) {
      print('Parsing Error response $e.');
      _cm.showToast('Parsing Error response $e.');
      return null;
    }
  }

  parseCheckINData(String response) async {

    try {

      final parsedJson = jsonDecode(response);
      // _cm.showToast(parsedJson);
      // AppPops().showAlertOfTypeMessage("$parsedJson", Get.context!);
      print("Parsed data ${parsedJson}");
      final data = parsedJson['data']    as List<dynamic>;

      if (data.isNotEmpty) {

        for(dynamic checkInData in data){
          print('showing checkInData ::');
          final load_checkin = checkInData['load_checkin']  ;
           final load_id = load_checkin['load_id'] as int;
           final ref_id = load_checkin['ref_id'] as String;
//           print(':::::::::::::::::::::::::');
// print(load_id);
//           print(ref_id);
//           print(':::::::::::::::::::::::::');
          final sqlStatus =   await   SqlLoadDB.instance.updateCheckInTableWithLoadIDWitReference(receivedLoadID: load_id.toString(), receivedLoadRefID: ref_id);
          // _cm.showToast('sqlStatus $sqlStatus');

        }
        // loadData.forEach((load) async {

        // print('RefID :: $refID');
        // });
        // final load = data['load'];
        // final lastLoadID = load['id'] as int;

        // _cm.showToast('Load received with id $lastLoadID');
        return null;
      } else {
        final msg = parsedJson['message'];

        //print('Parsing Error response .');
        _cm.showToast('server response message: $msg',true);
        return null;
      }
    } catch (e) {
      print('Parsing Error response $e.');
      _cm.showToast('Parsing Error response $e.');
      return null;
    }
  }
}