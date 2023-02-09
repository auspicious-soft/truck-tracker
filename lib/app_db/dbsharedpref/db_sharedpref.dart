import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:truck_tracker/app_db/dbsharedpref/shared_model_precheck.dart';
import 'package:truck_tracker/app_db/dbsharedpref/shared_model_rejection.dart';

import 'package:truck_tracker/utils/common_methods.dart';

import '../../model/model_user.dart';



class DBSharedPref {
  DBSharedPref._privateConstructor();

  static final DBSharedPref instance = DBSharedPref._privateConstructor();

//PRIVATE KEYS
  static const _keyLock = 'truck9777lock';
  static const _keyToken = 'truck000tkn';
  static const _keyRejectionData = 'truck98rejectiondata';
static const _keyNetWork = 'truckerNtWrkstus77';

  static const _keyUserID = 'truckeruid#9';

  Future<String> getUserID() async {
    final prefs = await SharedPreferences.getInstance();
    final uID = prefs.getInt(_keyUserID);
    if (uID == null) {
      return '';
    }
    return uID.toString();
  }

    isUserSigned() async {
    final prefs = await SharedPreferences.getInstance();
    final mode = prefs.getBool(_keyLock);
   // showToast('Mode $mode');
    if (mode == null ) {
      return false;
    }
    return mode;
  }



//::::::::::::::: USER APP LOCKING SYSTEM :::::::::::::::::
//   void lockuser(String token) async {
//     final prefs = await SharedPreferences.getInstance();
//     prefs.setBool(_keyLock, true);
//     prefs.setString(_keyToken, token);
//   }
    void lockuser(ModelUser userData) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_keyLock, true);
    prefs.setString(_keyToken, userData.token);
    prefs.setInt(_keyUserID, userData.user_id);
  }
  void unlockUser() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_keyLock, false);
  }
  Future<String> getUserTokenForUnique() async {
    try{

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_keyToken);
if(token == null){
 return DateTime.now().microsecondsSinceEpoch.toString();
}
      return token;

    }catch(e){
      return DateTime.now().microsecondsSinceEpoch.toString();

    }
  }
//::::::::::::::: END :::::::::::::::::
  //::::::::::::::::::::::REJECTION SYSNCE ::::::::::::::;;;;;

  void saveCheckInRejection(String licenseNo, String mReason , String imgLink, bool isSync) async {
    try{
     final obj= SharedModelRejection(id: licenseNo, reason: mReason, imgPath: imgLink, sync: isSync);

      final encodedData = CommonMethods().encodeObject(obj);
     // CommonMethods().showToast('encodedData $encodedData');
      if(encodedData.isNotEmpty){

        final prefs = await SharedPreferences.getInstance();
        prefs.setString(_keyRejectionData, encodedData);
        CommonMethods().showToast('Rejection will sync later.');
      }

    }catch(e){
      CommonMethods().showToast('Error while attempting to add rejection');
    }

  }

  Future<SharedModelRejection?> getRejection() async {
    try{
      final prefs = await SharedPreferences.getInstance();
      final obj = prefs.getString(_keyRejectionData);
      if(obj == null || obj.isEmpty){
        return null;
      }
      CommonMethods().showToast('obj $obj');
      final decodedData = jsonDecode(obj);
      final parsed = SharedModelRejection.fromJson(decodedData);
       return parsed;
    }catch(e){
      CommonMethods().showToast('Error while attempting to get rejection $e');
      return null;
    }

  }

  //::::::::::::::::::::PRECHECKSYNC::::::::::::;;;;;;
  static const _keyPreCheckRefID = 'trucker5precheckrefid';
  static const _keyPreCheckComment = 'truck65precheckcomment';
  static const _keyPreCheckLicenseNo = 'truck17prechecklicenno';
  static const _keyPreCheckLoadID = 'truck33precheckloadid';
  static const _keyRefIncrement = 'trukcerincrement';
  void setPreCheck(SharedModelPreCheck preCheckData)async {
    try{
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(_keyPreCheckRefID, preCheckData.refID!);
      prefs.setString(_keyPreCheckComment, preCheckData.comment!);
      prefs.setString(_keyPreCheckLicenseNo, preCheckData.licenseNo!);
      prefs.setString(_keyPreCheckLoadID, preCheckData.loadID!);
      CommonMethods().showToast('Pre-check will sync later.');

    }catch(e){
      CommonMethods().showToast('Error while attempting to add pre-check');
    }
  }
  Future<SharedModelPreCheck?> getPreCheckData() async {
    try{

      final prefs = await SharedPreferences.getInstance();
      final mRefID = prefs.getString(_keyPreCheckRefID);
     final mComment =   prefs.getString(_keyPreCheckComment);
      final mLicenseNo =   prefs.getString(_keyPreCheckLicenseNo);
      final mLoadID =   prefs.getString(_keyPreCheckLoadID);
      if(mComment == null || mLicenseNo == null || mLoadID == null){
        return null;
      }
      final obj = SharedModelPreCheck(refID:mRefID , comment: mComment, licenseNo: mLicenseNo, loadID: mLoadID);

     return obj;

    }catch(e){
      CommonMethods().showToast('Error while attempting to add pre-check');
      return null;
    }
  }
  void cancelPreCheck()async {
    try{
      final prefs = await SharedPreferences.getInstance();
      prefs.remove(_keyPreCheckComment);
      prefs.remove(_keyPreCheckLicenseNo);
      prefs.remove(_keyPreCheckLoadID);
      CommonMethods().showToast('Pre-check Removed');

    }catch(e){
      CommonMethods().showToast('Error while attempting to remove pre-check');
    }
  }

//:::::::::::::REference id incrementtal
  Future<int> getRefIncremental()async{
    try{

      final prefs = await SharedPreferences.getInstance();
      final id =   prefs.getInt(_keyRefIncrement);
      if(id == null  ){
        prefs.setInt(_keyRefIncrement,2);
        return 1;
      }
      prefs.setInt(_keyRefIncrement,id+1);
      return id;

    }catch(e){

      return 1;
    }

  }


  void showToast(String m) {
    Fluttertoast.showToast(msg: m);
  }


//:>>>>>>>> GET USER NAME

  // deleteUserData() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.clear();
  // }
}