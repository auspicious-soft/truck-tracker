import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:truck_tracker/apis/syncserver.dart';
import 'package:truck_tracker/app_db/dbsql/crud_operations.dart';
import 'package:truck_tracker/app_db/dbsql/flagtable/sql_flag_model.dart';
import 'package:truck_tracker/app_db/dbsql/loadcheckintable/sql_loaddb.dart';
import 'package:truck_tracker/app_db/dbsql/loadcheckintable/sql_model_storeload.dart';
import 'package:truck_tracker/utils/app.dart';

import '../apis/network_util.dart';
import '../app_db/dbsql/flagtable/sql_flag_tbl.dart';
import '../model/model_license_data.dart';
import '../utils/app_pops.dart';
import '../utils/common_methods.dart';
import '../utils/enumeration_mem.dart';
import '../utils/services/services_files.dart';
import '../utils/stringsref.dart';


class ReportController extends GetxController {
  final sqlDB = SQLTableFlag.instance; //Singleinstance
  SqlModelStoreLoad? loadData;
  SQLModelFlag? preReportData;
  final cmd = CommonMethods(); //single instance
  Rx<bool> moveToHome = false.obs;
  Rx<bool> isRequesting = false.obs;
  Rx<bool> readyForPreview = false.obs;
  final ImagePicker _picker = ImagePicker();

  //Rx<String?> imagePath = ''.obs;
  //ModelLicenseData?  tonTrackData ;
  Rx<bool> tontrackLoaded = false.obs;
  ModelLicenseData? tonTrackData;
  Rx<bool> sealLoaded = false.obs;
  ModelLicenseData? sealData;
  Rx<bool> vehLicenLoaded = false.obs;
  ModelLicenseData? vehicleData;
  Rx<String> comment = ''.obs;
  final focusNode = FocusNode();
  Rx<bool> focusNodeFocus = false.obs;
  Rx<String> reportRefID = ''.obs;

  //::::::::::::::::::METHODS::::::::::::::::
  Rx<String> driverName = ''.obs;
  Rx<String> vehLicenseNo = ''.obs;
  @override
  void onInit() {
    super.onInit();
  }

  void oninit() async {

    final data = await SqlLoadDB.instance.getDataFromLoadTable(queryFor: CRUDLoadGet.getDriverNameAndLicenseNo); //getLoadData();
    if (data != null) {
      final driverData = data as List<String>;
      driverName.value = driverData[0];
      vehLicenseNo.value = driverData[1];
    }
    // cmd.showToast('hiiiiiiiiiiiiiiiiiiiiiii');
    loadData = await SqlLoadDB.instance.getLoadData();
   // preReportData = await sqlDB.checkIncompleteReport();
    // if (preReportData != null) {
    // //  final fs = FileServices();
    //   // preReportData?.imageUrls?.forEach((image) {
    //   //   final byte = fs.readFile(image);
    //   //   imgInBytes.add(byte);
    //   // });
    //   // comment.value = preReportData!.comment!;
    //   //
    //   // if (preReportData!.tonTrackData! != 'null') {
    //   //   CommonMethods().showToast(
    //   //       'Showing ton data ${preReportData?.tonTrackData?.isEmpty}');
    //   //   tonTrackData = cmd.decodeIntoLicenseData(preReportData!.tonTrackData!);
    //   //   print('ton ton  ${preReportData?.tonTrackData}');
    //   //   tontrackLoaded.value = true;
    //   // }
    //   //
    //   // if (preReportData?.sealData != 'null') {
    //   //   sealData = cmd.decodeIntoLicenseData(preReportData!.sealData!);
    //   //   print('sealData sealData  ${preReportData?.sealData}');
    //   //   sealLoaded.value = true;
    //   // }
    //   //
    //   // if (preReportData?.vehData != 'null') {
    //   //   vehicleData = cmd.decodeIntoLicenseData(preReportData!.vehData!);
    //   //
    //   //   print('vehicleDatavehicleData  ${vehicleData}');
    //   //   vehLicenLoaded.value = true;
    //   // }
    //   // AppPops().showAlertOfTypeMessageWithTwoButtons(
    //   //     'An incomplete report found', 'Cancel', 'Complete', Get.context!,
    //   //     function: (txt) {
    //   //   if (txt == 'Complete') {
    //   //     if (loadData == null) {
    //   //       CommonMethods().showToast('No load found');
    //   //       moveToHome.value = true;
    //   //     } else {
    //   //
    //   //       readyForPreview.value = true;
    //   //       processSubmit();
    //   //     }
    //   //   } else {
    //   //     moveToHome.value = true;
    //   //   }
    //   // });
    // }
    // cmd.showToast('${preReportData?.comment}');
  }


 void  scanTrailerOrSeal(int index) async {
   final scanResult = await CommonMethods().scanQR();
   if ( scanResult.isNotEmpty) {

       if(index == 1) {
         sealData = CommonMethods().getLicenseData(scanResult);
         if (sealData != null) {
           sealLoaded.value = true;
           CommonMethods().showToast(sealData?.licenseno);
         }
       }

   } else {
    // popUpEnterManually(index);
   }


   // Navigator.of(Get.context!).push(
   //   MaterialPageRoute(
   //     builder: (context) => BarCodeScanner(onEventNav: (scanResult) {
   //       if (scanResult != null) {
   //                 if(index == 1) {
   //                   sealData = CommonMethods().getLicenseData(scanResult);
   //                   if (sealData != null) {
   //                     sealLoaded.value = true;
   //                     CommonMethods().showToast(sealData?.licenseno);
   //                   }
   //                 }
   //       } else {
   //         popUpEnterManually(index);
   //       }
   //     }),
   //     //controller: camController),
   //   ),
   // );
  }

  void popUpEnterManually(int index) {
    AppPops().showDialogWithManualEntryOfLicenseData(
       Get.context!,
        function: (obj) {
          // cm.showToast('$onComplete');
         // if (title == 'Done') {
            sealData = obj as ModelLicenseData;
            if(index == 1){
             // sealData = CommonMethods().getLicenseData(scanResult);
              if (sealData != null) {
                sealLoaded.value = true;
                CommonMethods().showToast(sealData?.licenseno);
              }
            }
           // CommonMethods().showToast('Working on it${lObj.licenseno}');
          //}
        });
  }
  void scan(int index) async {
    if (index == 0) {
      final scanResult = await CommonMethods().scanQR();
      //find values

      if (scanResult.isNotEmpty) {
        // var ttt = CommonMethods().getLicenseData(scanResult);
        // CommonMethods().showToast('tt ${ttt?.licenseno}');
        tonTrackData = CommonMethods().getLicenseData(scanResult);

        CommonMethods().showToast(tonTrackData);
        if (tonTrackData != null) {
          tontrackLoaded.value = true;
          CommonMethods().showToast(tonTrackData?.licenseno);
        }
      }
    } else if (index == 1) {
      scanTrailerOrSeal(index);
      //find values

    } else {
      final scanResult = await CommonMethods().scanQR();
      //find values
      if (scanResult.isNotEmpty) {
        vehicleData = CommonMethods().getLicenseData(scanResult);
        if (vehicleData != null) {
          vehLicenLoaded.value = true;
          CommonMethods().showToast(vehicleData?.licenseno);
        }
      }

    }
  }

  RxList<dynamic> imgInBytes = [].obs;

  //RxList<Uint8List> imgfInBytes = [Uint8List].obs;
//List<Uint8List?> imgInBytes = [];
  Future<void> pickImageFromCamera({required Function function}) async {
    try {
      XFile? image = await _picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 50,
          maxWidth: 300,
          maxHeight: 300);
      // imagePath.value = image?.path;

      // final size = await  image?.readAsBytes().then((value) => value.length);
      //  Fluttertoast.showToast(msg: 'path ${size}');
      if (image?.path != null) {
        final byte = await image?.readAsBytes();
        // imgInBytes.value.add(byte);
        imgInBytes.add(byte);
        // function(image?.path);
      }
    } catch (e) {
      BaseApp().showAlertOfTypeErrorWithDismiss(e.toString(), Get.context!);
    }
  }

  void onTapSubmit() async {
    bool valid = false;
    // BodyStoreLoad? vehData = await SQLLicenseLoadDB.instance.getLoadData();
    if (vehicleData != null || tonTrackData != null || sealData != null) {
      if (comment.isEmpty) {
        cmd.showToast('Please scan and add comment.');
      } else if (imgInBytes.isEmpty) {
        cmd.showToast(StringsRef.pleasechooseReportphoto);
      } else {
        valid = true;
      }

    } else {
      cmd.showToast('Please scan and add comment.');
    }

    if (valid) {
      // var encodedPathLinks = ''; //getEncodedImagePathLinks();
      // if (imgInBytes.isNotEmpty) {
      //   //cmd.showToast('We found images of size ${imgInBytes.length}');
      //   encodedPathLinks = await getEncodedImagePathLinks();
      //   //  print('Encoded path links $encodedPathLinks');
      // }
      readyForPreview.value = true;
      processSubmit();
      // if (loadData == null) {
      //   AppPops().showAlertOfTypeMessageWithTwoButtons(
      //       'Load unavailable.\nDo you want to save the information?',
      //       'Save',
      //       'Cancel',
      //       Get.context!, function: (title) async {
      //     if (title == 'Save') {
      //       final obj = await configureSQLData(comment.value);
      //       _saveInSQL(obj, encodedPathLinks);
      //       moveToHome.value = true;
      //       cmd.showToast('Report Saved');
      //     }else{
      //       moveToHome.value = true;
      //     }
      //   });
      //   return;
      // } else {
      //   readyForPreview.value = true;
      //   processSubmit();
      // }
    }
  }

  List<String?> tempPathLinks = [];

  void processSubmit() async {
    reportRefID.value = await cmd.getRefID(EnumReferenceType.flag);

    if (comment.isEmpty) {
      FocusScope.of(Get.context!).requestFocus(focusNode);
      cmd.showToast(StringsRef.pleasecommentaboutreport);
    } else if (imgInBytes.isEmpty) {
      cmd.showToast(StringsRef.pleasechooseReportphoto);
    } else {
      var vehRegNo = '';
      if (vehicleData != null) {
        vehRegNo = vehicleData!.licenseno!;
      }
      var tonTrackNo = '';
      var sealNo = '';
      if (tonTrackData != null) {
        tonTrackNo = tonTrackData!.licenseno!;
        vehRegNo = tonTrackNo;
      }
      if (sealData != null) {
        sealNo = sealData!.licenseno!;
        vehRegNo = sealNo;
      }
      final rfID = reportRefID.value;

      final encodedTonTrackData = CommonMethods().encodeObject(tonTrackData);
      final encodedVehLicenseData = CommonMethods().encodeObject(vehicleData);
      final encodedSealData = CommonMethods().encodeObject(sealData);
      var encodedPathLinks = ''; //getEncodedImagePathLinks();
      if (imgInBytes.isNotEmpty) {
        //cmd.showToast('We found images of size ${imgInBytes.length}');
        encodedPathLinks = await getEncodedImagePathLinks();
        //  print('Encoded path links $encodedPathLinks');
      }

      final obj = SQLModelFlag(
          id: 0,
          tonTrackData: encodedTonTrackData,
          tonTrackID: tonTrackNo,
          sealData: encodedSealData,
          sealID: sealNo,
          vehData: encodedVehLicenseData,
          vehID: vehRegNo,
          imageUrls: tempPathLinks,
          comment: comment.value,
          reportRef: rfID,
          createdAt: CommonMethods().getCreatedAt(),
          sync: 0);
      if (preReportData != null) {
        sqlDB.removeIncompleteReport();
      }

      final onSaved =
          await _saveInSQL(obj, encodedPathLinks); //SAVE IN DB MANDATORY
      if (onSaved) {
//        // final con = await NetworkUtil().checkInternet();
        // if (!con) {
        //   isRequesting.value = false;
        //   moveToHome.value = true;
        //   return;
        // } else {
        //   // cmd.showToast('Multipart starting');
        //   print(':::::::::::::::::::READY TO MULTIPART:::::::::::::');
        //   final status = await SyncServer().syncReportsMultiPart([obj]);
        //   isRequesting.value = false;
        //   moveToHome.value = true;
        // }
      } //end else

    }
  }

  Future<String> getEncodedImagePathLinks() async {
    for (var element in imgInBytes) {
      final fName = cmd.getTimeStamp();
      var finalName = '${fName}truckertrack';
      final filePath = await FileServices().getFilePath(finalName);
      if (filePath != null) {
        // CommonMethods().showToast('filePath  $filePath');
        //  print(filePath);
        // final bt = element.rea
        FileServices().saveFile(element, filePath);
        tempPathLinks.add(filePath);
      }
      // cmd.showToast(fileName);
    }
  //  cmd.showToast('Just loaded Files');
    final encodedImgPaths = CommonMethods().encodeObject(tempPathLinks);
    return encodedImgPaths;
  }

  Future<bool> _saveInSQL(SQLModelFlag obj, String encodedImgPaths) async {
    final status = await sqlDB.setNewLoad(
        obj.tonTrackID!,
        obj.vehID!,
        obj.sealID!,
        obj.tonTrackData!,
        obj.vehData!,
        obj.sealData!,
        encodedImgPaths,
        obj.reportRef!,
        comment.value);
    return status;
    // CommonMethods().showToast('encodedImgPaths${pathLinks.length}');
  }

  Future<SQLModelFlag> configureSQLData(
    String mComment,
  ) async {
    // reportRefID.value = await cmd.getRandomReference();

    var vehRegNo = '';
    if (vehicleData != null) {
      vehRegNo = vehicleData!.licenseno!;
    }
    var tonTrackNo = '';
    var sealNo = '';
    if (tonTrackData != null) {
      tonTrackNo = tonTrackData!.licenseno!;
      vehRegNo = tonTrackNo;
    }
    if (sealData != null) {
      sealNo = sealData!.licenseno!;
      vehRegNo = sealNo;
    }
    const rfID = ''; // reportRefID.value;

    final encodedTonTrackData = CommonMethods().encodeObject(tonTrackData);
    final encodedVehLicenseData = CommonMethods().encodeObject(vehicleData);
    final encodedSealData = CommonMethods().encodeObject(sealData);

    final obj = SQLModelFlag(
        id: 0,
        tonTrackData: encodedTonTrackData,
        tonTrackID: tonTrackNo,
        sealData: encodedSealData,
        sealID: sealNo,
        vehData: encodedVehLicenseData,
        vehID: vehRegNo,
        imageUrls: tempPathLinks,
        comment: mComment,
        reportRef: rfID,
        createdAt: CommonMethods().getCreatedAt(),
        sync: 0);

    return obj;
  }
}
