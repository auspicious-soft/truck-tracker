// import 'package:camera/camera.dart';

import 'package:get/get.dart';

import 'package:truck_tracker/apis/syncserver.dart';
import 'package:truck_tracker/app_db/dbsql/flagtable/sql_flag_tbl.dart';
 import 'package:truck_tracker/utils/common_methods.dart';

import '../apis/parsing_data.dart';
import '../app_db/dbsql/flagtable/sql_flag_model.dart';
import '../model/model_license_data.dart';

import '../model/modeldatadetails.dart';
import '../utils/app_pops.dart';
import '../utils/enumeration_mem.dart';
import '../utils/services/location_services.dart';

class ControllerPreCheck extends GetxController {
  List<ModelDataDetails> objVehLicenseData = [];
  SQLModelFlag? flagData;
  RxString flagComment = ''.obs;
  ModelLicenseData? scanData;
  RxString preCheckRefID = ''.obs;

  // RxBool activateScanView = true.obs;
  RxBool isRequesting = false.obs;
  RxBool pvVehicleDetail = false.obs;
  RxBool previewFlagView = false.obs;
  RxBool checkingFlag = false.obs;

  get timeStamp {
    return CommonMethods().getTimeStamp();
  }


  RxBool isGPSOn = false.obs;
  RxBool isGPSSearching = false.obs;
  RxString gps = ''.obs;
  RxBool previewProceedView = false.obs;

  set comment(String comment) {}

  // @override
  // void onInit() {
  //   super.onInit();
  //   Fluttertoast.showToast(msg: 'init');
  //   // filldata();
  // }
  void getCurrentLocation() async {
    isGPSOn.value = await LocationServices().checkGPSService();
    if (isGPSOn.value) {
      isGPSSearching.value = true;
      final pos = await LocationServices().getGPSLocation();
      isGPSSearching.value = false;
      // CommonMethods().showToast('fjfhjhfgf');
      gps.value = "${pos?.latitude}, ${pos?.longitude}";
    } else {
      CommonMethods().showToast('Please enable location');
    }
  }

  void processScanResult(String scanResult) {
    scanData = CommonMethods().getLicenseData(scanResult);
    objVehLicenseData.clear();
    if (scanData != null) {
    objVehLicenseData = CommonMethods().getStructuredLicenseData(scanData!);
      performPreCheckProcess(scanData!.licenseno!);
    } else {
      popUpEnterManually();
    }
  }
  //
  // Future<CameraController?> getCamController() async {
  //   if (await Permission.camera.request().isGranted) {
  //     try {
  //       final cameras = await availableCameras();
  //       final firstCamera = cameras.first;
  //       final camController =
  //           CameraController(firstCamera, ResolutionPreset.medium);
  //       final wait = await camController.initialize().then((_) {
  //         return camController;
  //       });
  //       // final done = await  camController.initialize();
  //       return wait;
  //     } catch (e) {
  //       if (e is CameraException) {
  //         switch (e.code) {
  //           case 'CameraAccessDenied':
  //             AppPops().showAlertOfTypeErrorWithDismiss(
  //                 'You denied camera access please reinstall app.');
  //             //print('User denied camera access.');
  //             break;
  //           default:
  //             CommonMethods().printException(e);
  //             AppPops().showAlertOfTypeErrorWithDismiss(
  //                 'Exception at getCamController:\n$e');
  //             return null;
  //         }
  //       } else {
  //         CommonMethods().printException(e);
  //         AppPops().showAlertOfTypeErrorWithDismiss(
  //             'Exception at getCamController:\n$e');
  //         return null;
  //       }
  //     }
  //   } else {
  //     return null;
  //   }
  // }

  void scan() async {
    final scanResult = await CommonMethods().scanQR();
    if (scanResult.isNotEmpty) {
      processScanResult(scanResult);
    } else {
      popUpEnterManually();
    }
    // Navigator.of(Get.context!).push(
    //
    //   MaterialPageRoute(
    //     builder: (context) => BarCodeScanner(
    //         onEventNav: (scanResult)   {
    //          // final waitTodispose = await  camController.dispose();
    //          // camController.debugCheckIsDisposed();
    //          // camController.de = null;
    //           if (scanResult != null && scanResult.isNotEmpty) {
    //             processScanResult(scanResult);
    //           } else {
    //             popUpEnterManually();
    //           }
    //         },
    //     )
    //         //controller: camController),
    //   ),
    // );
  }

  // void setVehicleLicenseData(ModelLicenseData vehData) async {
  //   try {
  //     var objInnerData = DataDetails('License no', vehData.licenseno);
  //     objVehLicenseData.add(objInnerData);
  //     objInnerData = DataDetails('Veh register no.', vehData.vehregno);
  //     objVehLicenseData.add(objInnerData);
  //     objInnerData = DataDetails('Make', vehData.make);
  //     objVehLicenseData.add(objInnerData);
  //     objInnerData = DataDetails('Vin', vehData.vin);
  //     objVehLicenseData.add(objInnerData);
  //     objInnerData = DataDetails('Engine no', vehData.engineno);
  //     objVehLicenseData.add(objInnerData);
  //     // Fluttertoast.showToast(msg: 'Expiry validate ${vehData.expirydate}');
  //     objInnerData = DataDetails('Date of expiry', vehData.expirydate);
  //     objVehLicenseData.add(objInnerData);
  //   } catch (e) {
  //     //showAlert(context, 'Error: ${e.toString()}');
  //     print(e.toString());
  //     Fluttertoast.showToast(msg: e.toString());
  //   }
  //   // Fluttertoast.showToast(msg: objVehLicenseData.length.toString());
  // }

  void performPreCheckProcess(String license_no) async {
    checkingFlag.value = true;
    final obj = await SyncServer().syncPreCheckProcess(license_no);
    print('preCheck body::::::::::::::::::::::: ${obj.data}');
    checkingFlag.value = false;
    if (obj.status == EnumServerSyncStatus.failed) {
      getOfflineData(license_no);
    } else {
      final parsedData = ParseData().parsePreCheckData(obj.data);
      if (parsedData != null) {
        flagData = parsedData;
        flagComment.value = parsedData.comment!;
      }
      previewFlagView.value = true;
      pvVehicleDetail.value = true;
    }
  }

  void getOfflineData(String scannedVehID) async {
    checkingFlag.value = false;
    final report = await SQLTableFlag.instance.getReportData(scannedVehID);
  if (report != null) {
     flagData = report;
      flagComment.value = report.comment!;
    } else {
    CommonMethods().showToast('No flag found');
    }
  //  cm.showToast('yuki');
    previewFlagView.value = true;
    pvVehicleDetail.value = true;
  }

  void popUpEnterManually() {
    AppPops().showDialogWithManualEntryOfLicenseData(Get.context!,
        function: (obj) {
      final data = obj as ModelLicenseData;
      this.objVehLicenseData = CommonMethods().getStructuredLicenseData(data);
      performPreCheckProcess(data.licenseno!);
    });
  }

  void setPreCheckRefID() async {
    this.preCheckRefID.value =
        await CommonMethods().getRefID(EnumReferenceType.preCheckIn);
  }
}
