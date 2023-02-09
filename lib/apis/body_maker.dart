import 'package:truck_tracker/apis/server_keys.dart';
import 'package:truck_tracker/app_db/dbsharedpref/shared_model_precheck.dart';
import '../app_db/dbsharedpref/db_sharedpref.dart';
import '../app_db/dbsql/flagtable/sql_flag_model.dart';
import '../app_db/dbsql/loadcheckintable/sql_model_checkin_load.dart';
import '../app_db/dbsql/loadcheckintable/sql_model_storeload.dart';
import '../model/model_flag_data.dart';
import '../model/model_saveloaddoc.dart';
import '../utils/app_constants.dart';
import '../utils/common_methods.dart';

class BodyMaker{
  _showPrint(dynamic body){
    if(AppConstants.InDebug){
      print("Showing body:::: $body");
    }
  }
  bodyOfLogin(String email, String password){
    Map<String, String> body = {
      ServerKeys.username: email,
      ServerKeys.password:password,
     ServerKeys.devicename:'test'
    };
    _showPrint(body);
    return body;
  }


  Future<Map<String, String>?>   getBodyOfSyncReport( ModelFlagData report,[bool showBody = false]) async {
    final authID = await DBSharedPref.instance.getUserID();
    if(authID.isEmpty){
      CommonMethods().showToast('Unable to get userID');
      return null;
    }
    Map<String, String> body = {
      ServerKeys.author: authID,
      ServerKeys.veh_reg_no: report.veh_reg_no,
      ServerKeys.comment: report.comment,
      ServerKeys.tontrack: report.tonTrackId,
      ServerKeys.seal: report.sealId,
      ServerKeys.refID: report.refID,
    };
    if(showBody){
      print(body);
      return null;
    }
    return body ;
  }

  Future<Map<String, String>?>   bodyOfSyncReport( SQLModelFlag report) async {
    final authID = await DBSharedPref.instance.getUserID();
    if(authID.isEmpty){
      CommonMethods().showToast('Unable to get userID');
      return null;
    }
     Map<String, String> body = {
        ServerKeys.author: authID,
        ServerKeys.veh_reg_no: report.vehID!,
        ServerKeys.comment: report.comment!,
        ServerKeys.tontrack: report.tonTrackID!,
        ServerKeys.seal: report.sealID!,
        ServerKeys.refID: report.reportRef!,
      };
     return body ;
    }
  Future<Map<String, dynamic>?> getBodyOfCheckIn(List<SqlModelCheckIn> pendingCheckIn) async {
    final userID = await DBSharedPref.instance.getUserID();
    if(userID.isEmpty){
      CommonMethods().showToast('Unable to get userID');
      return null;
    }
    final List<Map<String, String>> checkInArray = [];
    for (SqlModelCheckIn checkInData in pendingCheckIn) {

      Map<String, String> body = {
        ServerKeys.author: userID,
        ServerKeys.license_no: checkInData.license_no!,
        ServerKeys.vehicle_reg_no: checkInData.vehicle_reg_no!,
        ServerKeys.make: checkInData.make!,
        ServerKeys.vin: checkInData.vin!,
        ServerKeys.engine_no: checkInData.engine_no!,
        'time_stamp':checkInData.time_stamp!,
        'gps':checkInData.gps!,
        ServerKeys.refID:checkInData.ref_id!,
        ServerKeys.date_of_expiry: checkInData.date_of_expiry!,
        ServerKeys.seal: checkInData.seal!,

      };

      checkInArray.add(body);

    }
    Map<String, List> outerBody = {
      'loads': checkInArray,
    };
// print('checkin body ${outerBody}');
//     return null;
    return outerBody;
  }
   Future<Map<String, String>?> bodyOfCheckIn(SqlModelCheckIn loadData) async {
     final authID = await DBSharedPref.instance.getUserID();
     if(authID.isEmpty){
       CommonMethods().showToast('Unable to get userID');
       return null;
     }
    Map<String, String> body = {
      ServerKeys.author:authID,
      ServerKeys.load_id: loadData.load_id!,
      ServerKeys.license_no: loadData.license_no!,
      ServerKeys.veh_reg_no: loadData.vehicle_reg_no!,
      ServerKeys.make: loadData.make!,
      ServerKeys.vin: loadData.vin!,
      ServerKeys.engine_no: loadData.engine_no!,
      ServerKeys.time_stamp: loadData.time_stamp!,
      ServerKeys.gps: loadData.gps!,
      ServerKeys.date_of_expiry: loadData.date_of_expiry!,
      ServerKeys.seal: loadData.seal!,
      ServerKeys.refID: loadData.ref_id!,
    };
    return body;
  }
  Future<Map<String, String>?>  bodyOfPreCheckProcess(String license_no)async  {
    final userID = await DBSharedPref.instance.getUserID();
    if(userID.isEmpty){
      CommonMethods().showToast('Unable to get userID');
      return null;
    }
    Map<String, String> body = {
      'author': userID,
      'license_no': license_no,
    };
    return body;
  }
  Future<Map<String, String>?>  bodyOfPreCheckUpdation(SharedModelPreCheck preCheckData)async  {
    final userID = await DBSharedPref.instance.getUserID();
    if(userID.isEmpty){
      CommonMethods().showToast('Unable to get userID');
      return null;
    }
    Map<String, String> body = {
      'author': userID,
      ServerKeys.refID:preCheckData.refID!,
      'license_no': preCheckData.licenseNo!,
      'load_id': preCheckData.loadID!,
      'comment': preCheckData.comment!
    };
    return body;
  }

  Future<Map<String, dynamic>?> getAddLoadBody(List<SqlModelStoreLoad> pendingLoads) async {
    final userID = await DBSharedPref.instance.getUserID();
    if(userID.isEmpty){
      CommonMethods().showToast('Unable to get userID');
      return null;
    }
    final List<Map<String, String>> loadArray = [];
    for (SqlModelStoreLoad loadData in pendingLoads) {

      Map<String, String> body = {
        ServerKeys.author: userID,
        ServerKeys.license_no: loadData.license_no!,
        ServerKeys.vehicle_reg_no: loadData.vehicle_reg_no!,
        ServerKeys.make: loadData.make!,
        ServerKeys.vin: loadData.vin!,
        ServerKeys.driver_name: loadData.driver_name!,
        ServerKeys.driver_no: loadData.driver_no!,
        ServerKeys.engine_no: loadData.engine_no!,
        ServerKeys.date_of_expiry: loadData.date_of_expiry!,
        ServerKeys.seal: loadData.seal!,
        ServerKeys.trailer: loadData.trailer!,
        ServerKeys.refID: loadData.ref_id!,
        // ServerKeys.updated_at: loadData.updated_at!,
        // ServerKeys.created_at: loadData.created_at!,

      };

      loadArray.add(body);

    }
    Map<String, List> outerBody = {
      'loads': loadArray,
    };


    return outerBody;
  }
  Future<Map<String, dynamic>?> getSaveLoadDocBody(List<ModelSaveLoadDoc> pendingLoadFiles) async {
    final userID = await DBSharedPref.instance.getUserID();
    if(userID.isEmpty){
      CommonMethods().showToast('Unable to get userID');
      return null;
    }
    final List<Map<String, String>> loadArray = [];
    for (ModelSaveLoadDoc loadData in pendingLoadFiles) {

      Map<String, String> body = {
        ServerKeys.load_id: loadData.loadID,
        'image':loadData.image,
        'document':loadData.documents,
        ServerKeys.author: userID,

      };

      loadArray.add(body);

    }
    Map<String, List> outerBody = {
      'load_documents': loadArray,
    };


    return outerBody;
  }
  Future<Map<String, dynamic>?>  getReportBody(SQLModelFlag report) async {
    final userID = await DBSharedPref.instance.getUserID();
    if(userID.isEmpty){
      CommonMethods().showToast('Unable to get userID');
      return null;
    }
    Map<String, String> body = {
      ServerKeys.author: userID,
      ServerKeys.veh_reg_no: report.vehID!,
      ServerKeys.comment: report.comment!,
      ServerKeys.tontrack: report.tonTrackID!,
      ServerKeys.seal: report.sealID!,
      ServerKeys.refID: report.reportRef!,
    };
    return body;
  }
}