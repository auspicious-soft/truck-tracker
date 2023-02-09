import 'package:edge_detection/edge_detection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/services/services_files.dart';
import '../apis/network_util.dart';
import '../apis/syncserver.dart';
import '../app_db/dbsharedpref/db_sharedpref.dart';
import '../app_db/dbsql/loadcheckintable/sql_loaddb.dart';
import '../app_db/dbsql/loadcheckintable/sql_model_storeload.dart';
import '../model/model_license_data.dart';
import '../model/modeldatadetails.dart';
import '../utils/app.dart';
import '../utils/common_methods.dart';
import '../utils/enumeration_mem.dart';


class ControllerAddLoad extends GetxController {
//:::::::::::MEMBERES VAIABLES::::::::;;
  late ModelLicenseData vehLicenseData;
  RxBool previewLoadDetail = false.obs;
  RxBool previewSealScan = false.obs;
  List<ModelDataDetails> objVehLicenseData = [];
  List<ModelLicenseData> objVehQrData = [];

//::::::::::::::::::::::::::::::: SCAN SEAL CONTROLLER:::::::::::;;;
  Rx<bool> isRequesting = false.obs;
  Rx<bool> moveToHome = false.obs;
  Rx<String> loadRefID = ''.obs;
  Rx<String> rejRefID = ''.obs;
  final ImagePicker _picker = ImagePicker();

  RxBool activeEndView = false.obs;

//FUNCTIONS::
  Future<void> scanVehicleLicense({required Function function}) async {
    //final vehData = await UtilScanner().scanVehicleLicenseCode();
    // if(vehData != null){
    //   final stData = CommonMethods().getStructuredLicenseData(vehData);
    // final widget = await   UtilScanner().getVehicleLicensePlateView(stData);
    //   controller.previewLoadDetail.value = true;
    //   controller.objVehLicenseData = CommonMethods().getStructuredLicenseData(vehData);
    // }
    try {
      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.QR);

      if (barcodeScanRes.isNotEmpty) {
        if (barcodeScanRes.length > 3) {
          function(barcodeScanRes.toString());
          //  Fluttertoast.showToast(msg: barcodeScanRes.toString());
          //  processCasseteeID(barcodeScanRes);
        } else {
          // Fluttertoast.showToast(msg: barcodeScanRes);
        }
      }
    } catch (e) {
      //Fluttertoast.showToast(msg: e.toString());
    }
  }

  void analyseVehicleLicense(BuildContext context, String vehicleLicense,
      {required Function(ModelLicenseData? vehData) onCompletion}) {
    try {
      var data = vehicleLicense
          .split('%') // split the text into an array
          .map((String text) => text) // put the text inside a widget
          .toList();

      //  print('$data');
      data.removeAt(0);
      //  showSimpleAlert(data.toString(),context);
      // Fluttertoast.showToast(msg:'Invalid QRCode ${data.length}');
      if (data.length < 10) {
        Fluttertoast.showToast(msg: 'Invalid QRCode ${data.length}');
        onCompletion(null);
      } else {
        final number = data[4];
        final licenseNo = data[5].toString();
        final vehRegNo = data[6].toString();
        final vin = data[11].toString();
        final engineno = data[12].toString();
        final make = data[8].toString();
        final description = data[7].toString();
        final expirydate = data[13].toString();
        final obj = ModelLicenseData(
            number,
            licenseNo,
            vehRegNo,
            vin,
            engineno,
            '',
            '',
            '',
            make,
            description,
            '',
            '',
            '',
            expirydate);
        vehLicenseData = obj;
        onCompletion(obj);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'getting crash $e ');
      onCompletion(null);
    }
  }


  //::::::::::::::::::::::::::::::: SCAN SEAL CONTROLLER:::::::::::;;;

  void onSubmit(String driverName,
      String driverPhone,
      List arrayOfTrailers,
      List arrayOfSeals,
      List podDocuments,
      String licenseImages
      ) async {
    // loadRefID.value = await CommonMethods().getRefID(EnumReferenceType.addLoad);
    DateTime dateToday = DateTime.now();
    String date = dateToday.toString().substring(0, 10);
    final vehData = vehLicenseData; //loadScanData.vehLicenData;
    final seals = arrayOfSeals.join(",");
    final trialers = arrayOfTrailers.join(",");
    final podsdoc = podDocuments.join(",");

    final bodyAddload = SqlModelStoreLoad(
        0,
        '',
        vehData.licenseno,
        vehData.vehregno,
        vehData.make,
        vehData.vin,
        vehData.engineno,
        vehData.expirydate,
        driverName,
        driverPhone,
        date,
        date,
        seals,
        trialers,
        loadRefID.value);


    final db = SqlLoadDB.instance;
    final sqlStatus  = await db.insertInLoadTable(podsdoc,licenseImages, bodyAddload);
if(sqlStatus == 1){
  final con = await  NetworkUtil().checkInternet();
  if(con)
  isRequesting.value = true;
  final List<SqlModelStoreLoad> tempList = [];
  tempList.add(bodyAddload);
  final status = await SyncServer().syncPendingLoads(tempList);
  isRequesting.value = false;
}

  }

  void setUpRejectionView() async {
    rejRefID.value = await CommonMethods().getRefID(EnumReferenceType.checkIn);
  }

  void setRefID() async {
    this.loadRefID.value =
    await CommonMethods().getRefID(EnumReferenceType.addLoad);
  }


  Future<String?> onTapAddDocument() async {
    String? imagePath;
    // We also handle the message potentially returning null.
    try {
      imagePath = (await EdgeDetection.detectEdge);
      print("$imagePath");
    } on PlatformException catch (e) {
      imagePath = e.toString();
    }
    return imagePath;
  }

  void setLoadRef() async {
    loadRefID.value = await CommonMethods().getRefID(EnumReferenceType.addLoad);
  }

  RxDouble netWeight = 0.0.obs;

  calculateNetWeight(double tarWeight, double grossWeight) {
    if (tarWeight != 0.0 && grossWeight != 0.0) {
      final total = grossWeight - tarWeight;
      print(total);
      netWeight.trigger(total);
    }

    // CommonMethods().showToast('total ${netWeight.value}');
  }

  XFile? licenseImg;
RxBool listenLicenseImage = false.obs;
  Future<void> pickDriverCardImage() async {
    try {
      licenseImg = await _picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 50,
          maxWidth: 300,
          maxHeight: 300);
      if (licenseImg?.path != null) {
        listenLicenseImage.value = true;
      }
    } catch (e) {
      BaseApp().showAlertOfTypeErrorWithDismiss(e.toString(), Get.context!);
    }
  }

  Future<String?> getDriverCardPath(XFile tempImageFile) async {
    final byte = await tempImageFile.readAsBytes();

    final fName = CommonMethods().getTimeStamp();
    var finalName = '${fName}trucker_track_driver_card';
    final filePath = await FileServices().getFilePath(finalName);
    if (filePath != null) {
      FileServices().saveFile(byte, filePath);
      return filePath;
    } else {
      return null;
    }
  }


  //:::::::::::::::::::::::WEB SERVICES::::::::::::::::::::::::::

  void submitReasonWithoutPhoto(String id, String reason) async {
    var con = await NetworkUtil().checkInternet();
    if (!con) {
      DBSharedPref.instance.saveCheckInRejection(id, reason, '', true);
      return;
    }
    SyncServer().syncCheckINRejectionWithoutPhoto(id, reason);
    //  moveToHome.value = true;
  }

  void submitReasonWithPhoto(String licenseNo, String reason) async {
    try {
      XFile? image = await _picker.pickImage(source: ImageSource.camera);
      final imagePath = image?.path;
      // Fluttertoast.showToast(msg: 'path $imagePath');
      if (imagePath != null) {
        performSubmitReasonApiWithMultipart(licenseNo, reason, imagePath);
      }
    } catch (e) {
      BaseApp().showAlertOfTypeErrorWithDismiss(e.toString(), Get.context!);
    }
  }

  void performSubmitReasonApiWithMultipart(licenseNo, reason, imgPath) async {
    var con = await NetworkUtil().checkInternet();

    if (!con) {
      DBSharedPref.instance
          .saveCheckInRejection(licenseNo, reason, imgPath, true);
      SqlLoadDB.instance.cancelLoad();
      // moveToHome.value = true;
      return;
    }
    SyncServer().syncCheckINRejectionWithPhoto(licenseNo, reason, imgPath,
        function: (value) {});
    SqlLoadDB.instance.cancelLoad();
    //  moveToHome.value = true;
  }
}

