import 'dart:io';

import 'package:edge_detection/edge_detection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:truck_tracker/model/modeldatadetails.dart';
import 'package:truck_tracker/utils/app_pops.dart';

import '../../utils/enumeration_mem.dart';
import '../app_db/dbsql/crud_operations.dart';
import '../app_db/dbsql/loadcheckintable/enum_status.dart';
import '../app_db/dbsql/loadcheckintable/sql_loaddb.dart';
import '../app_db/dbsql/loadcheckintable/sql_model_checkin_load.dart';
import '../model/model_license_data.dart';
import '../model/model_ton_track.dart';
import '../utils/common_methods.dart';
import '../utils/services/services_files.dart';
import '../utils/util_scanner.dart';

class ControllerLoadCheckIN extends GetxController {
  //::::::::::::::::::::CONTROL DETAIL VIEW BUILD
  RxBool previewVehDetailView = false.obs;
  List<ModelDataDetails> objVehLicenseData = [];

  //:::::::::::::::::::CONTROL SEAL SCAN VIEW BUILD::::::::::::
  RxBool activateSealScanView = false.obs;
  ModelLicenseData? vehData;
  RxString timeStamp = ''.obs;

  Rx<String> loadId = "".obs;
  Rx<String> driverName = "".obs;
  Rx<String> exitRefID = "".obs;

  Rx<bool> isRequesting = false.obs;
  Rx<bool> previewExitView = false.obs;
  Rx<bool> previewTonTrackView = false.obs;

  RxString checkInRefID = ''.obs;

  List<ModelDataDetails> objTonTrackData = [];
  List<ModelLicenseData> objVehQrData = [];

  Rx<bool> sealPagePreviewOnCheckInTap = false.obs;
  Rx<bool> sealPagePreviewOnRejectTap = false.obs;
  Rx<bool> rejectionPreviewAfterEdit = false.obs;

  Rx<bool> rejectionEditor = true.obs;
  RxString rejectionRefID = ''.obs;

  @override
  void onInit() {
    super.onInit();

    try {
      // onInitView();
    } catch (e) {
      Fluttertoast.showToast(msg: 'Payload Error$e');
    }

    // subscribeToMessages();
  }

  //:::::::::::::::::::::::::::CONTROL CHECK IN SCAN BUILD:::::::::::::::::


  void verifyLicenseAndProcess(
    ModelLicenseData vhData,
  ) async {
    this.objVehLicenseData = CommonMethods().getStructuredLicenseData(vhData);
    previewVehDetailView.value = true;
  }

  //::::::::::::::::::::::::::::CONTROL CHECK IN SCAN BUILD END:::::::::::::::::

  void setTonTrackData(ModelTonTrackData ttData) async {
    try {
      var objInnerData = ModelDataDetails('ticketNo', ttData.ticketNo);
      objTonTrackData.add(objInnerData);
      objInnerData =
          ModelDataDetails('ticketGenTimeStamp', ttData.ticketGenTimeStamp);
      objTonTrackData.add(objInnerData);
      objInnerData = ModelDataDetails('source', ttData.source);
      objTonTrackData.add(objInnerData);
      objInnerData = ModelDataDetails('destination', ttData.destination);
      objTonTrackData.add(objInnerData);
      objInnerData = ModelDataDetails('grossMass', ttData.grossMass);
      objTonTrackData.add(objInnerData);

      objInnerData = ModelDataDetails('netMass', ttData.netMass);
      objTonTrackData.add(objInnerData);

      objInnerData = ModelDataDetails('hauiler', ttData.hauiler);
      objTonTrackData.add(objInnerData);

      objInnerData = ModelDataDetails('driver_name', ttData.driver_name);
      objTonTrackData.add(objInnerData);

      objInnerData = ModelDataDetails('vehReg', ttData.vehReg);
      objTonTrackData.add(objInnerData);

      objInnerData = ModelDataDetails('supplier', ttData.supplier);
      objTonTrackData.add(objInnerData);
    } catch (e) {
      //showAlert(context, 'Error: ${e.toString()}');
      print(e.toString());
      CommonMethods().showToast(e.toString());
    }
    // Fluttertoast.showToast(msg: objVehLicenseData.length.toString());
  }



  void off(BuildContext context) {
    Navigator.pop(context);
  }


  Future<Position?> getGPSLocation(BuildContext context) async {
    final geoLocations = await _determinePosition(context);
    final latitude = geoLocations.latitude;
    // final lngi = geoLocations.longitude;
    if (latitude == 0.0) {
      Fluttertoast.showToast(msg: 'lati is 0.0');
      return null;
    } else {
      return geoLocations;
    }
  }



  Future<Position> _determinePosition(BuildContext context) async {
    //  bool serviceEnabled;
    LocationPermission permission;

    ///serviceEnabled = await Geolocator.isLocationServiceEnabled();
    // if (!serviceEnabled) {
    //   Fluttertoast.showToast(msg: 'Please enable location');
    //   Geolocator.openLocationSettings();
    //
    //   return Future.error('Location services are disabled.');
    // }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        Fluttertoast.showToast(msg: 'Location permissions are denied');
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
          msg:
              'Location permissions are permanently denied, we cannot request permissions.');
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    // showProgress(context);
    return await Geolocator.getCurrentPosition();
  }

  // void checkScannedCodePresense(String qrcode,
  //     {required Function function}) async {
  //   final isQrCodePresent =
  //       await TruckBox.instance.isScannedCodeAvailable(qrcode);
  //   if (!isQrCodePresent) {
  //     function(false);
  //   } else {
  //     function(true);
  //   }
  // }

  Future<bool> isGPSon() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  void searchCurrentLocation() {}

  void continueLoad() async {
    CommonMethods().showToast('functionality unavaialble this time.');
    //Functionality paused now
    // if(vehData == null){
    //   CommonMethods().showToast('Load data unavailable');
    //   return;
    // }
    // isRequesting.value = true; //SqlModelStoreLoad
    // try{
    //
    //   final loadID = await SyncServer().syncPendingLoads(vehData);
    //   if (loadID != null) {
    //     SqlLoadDB.instance.updateLoadID(loadID);
    //   }
    //   isRequesting.value = false; //SqlModelStoreLoad
    //
    // }catch(e){
    //   CommonMethods().showToast('exception $e');
    //   isRequesting.value = false; //SqlModelStoreLoad
    // }
  }

  // void initController(BuildContext context) {
  //   mContext = context;
  //  // onInitView();
  // }

  // void onInitView() async {
  //   loadData = await SqlLoadDB.instance.getLoadData();
  // }

  void scanTonTrack({required Function function}) async {
    final scanData = await CommonMethods().scanQR();

    if (scanData.isNotEmpty) {
      function(scanData);
    }
  }

  void analyseTonTrackData(scannedData, {required Function onCompletion}) {
    final obj = ModelTonTrackData('', '', '', '', '', '', '', '', '', '');
    setTonTrackData(obj);
    previewExitView.value = false;
    previewTonTrackView.value = true;
    setUpTontrackView();
  }

  void setUpTontrackView() async {
    exitRefID.value = await CommonMethods().getRefID(EnumReferenceType.exit);
  }

  Future<bool> setCheckInRefID() async {
    this.checkInRefID.value =
        await CommonMethods().getRefID(EnumReferenceType.checkIn);
    return true;
  }

//:::::::::::::::::::::::SEAL VIEW CONTROLLER
  RxString sealVehLicenseNumber = ''.obs;
  RxString sealDriverName = ''.obs;

  void setSealViewData() async {

    final data = await SqlLoadDB.instance.getDataFromLoadTable(queryFor: CRUDLoadGet.getDriverNameAndLicenseNo); //getLoadData();
    if (data != null) {
      final driverData = data as List<String>;
      sealDriverName.value = driverData[0];
      sealVehLicenseNumber.value = driverData[1];
    }
    checkInRefID.value =
        await CommonMethods().getRefID(EnumReferenceType.checkIn);

  }

  void setRejectionView() async {
    rejectionRefID.value =
        await CommonMethods().getRefID(EnumReferenceType.rejection);
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
    // // If the widget was removed from the tree while the asynchronous platform
    // // message was in flight, we want to discard the reply rather than calling
    // // setState to update our non-existent appearance.
    // if (!mounted) return;
    //
    // setState(() {
    //   _imagePath = imagePath;
    // });
    // final  imagePath = await EdgeDetection.detectEdge;
    // if(imagePath != null){
    //   return imagePath;
    // }
    // return null;
  }

//::::::::::::::::::::::::::::REJECTION VIEW:::::::::::::::::::::::
  final ImagePicker _picker = ImagePicker();

  File? imgOfRejection;
  RxBool listenRejectionImage = false.obs;

  void chooseRejectionPhoto() async {
    try {
      listenRejectionImage.value = false;
      XFile? image = await _picker.pickImage(source: ImageSource.camera);
      final imagePath = image?.path;
      if (imagePath != null) {
        imgOfRejection = File(image!.path);
        listenRejectionImage.value = true;
      }
    } catch (e) {
      AppPops().showAlertOfTypeErrorWithDismiss(
          "Exception at chooose Rejection Photo\n${e.toString()}");
    }
  }

  void addNewCheckINInSQL(String seals, bool mIsSimpleCheckIN) {
    if (vehData != null) {
      final obj = SqlModelCheckIn(
          load_id: '',
          ref_id: checkInRefID.value,
          license_no: vehData!.licenseno,
          vehicle_reg_no: vehData!.vehregno,
          make: vehData!.make,
          vin: vehData!.vin,
          engine_no: vehData!.engineno,
          time_stamp: this.timeStamp.value,
          gps: this.gps.value,
          date_of_expiry: vehData!.expirydate,
          seal: seals);
      SqlLoadDB.instance.insertInCheckINTable(isSimpleCheckIN: mIsSimpleCheckIN, obj: obj);

    }
  }

  void scanVehLicense() async {
    vehData = await UtilScanner().scanVehicleLicenseCode();
    if (vehData != null) {
      checkIsGPSOn();
      verifyLicenseAndProcess(vehData!);
    }
  }

  RxBool isGPSOn = false.obs;
  RxBool isGPSSearching = false.obs;
  RxString gps = ''.obs;

  void checkIsGPSOn() async {
    isGPSOn.value = await isGPSon();
    if (isGPSOn.value) {
      Fluttertoast.showToast(msg: 'Please wait locating you...');

      isGPSSearching.value = true;

      //   if (!mounted) return;
      final pos = await getGPSLocation(Get.context!);

      if (pos != null) {
        isGPSSearching.value = false;
        gps.value = "${pos.latitude}, ${pos.longitude}";
      }
    } else {
      Fluttertoast.showToast(msg: 'Please enable location service');

      isGPSOn.value = false;
    }
  }

  void setTimeStamp() {
    this.timeStamp.value = CommonMethods().getTimeStamp();
  }

  void processCheckIn(List<String> arrayOfSeals) async {
    final sealsData = arrayOfSeals.join(",");
    //  final db = SqlLoadDB.instance;
    addNewCheckINInSQL(sealsData, false);

    // final con = await NetworkUtil().checkInternet();
    // if (con) {
    //   if (receivedLoadID!.isEmpty) {
    //     final syncLoadID = await SyncServer().syncLoad(loadData!);
    //     if (syncLoadID == null) {
    //       db.activateOfflineCheckIn();
    //       //  goToHomePage();
    //     } else {
    //       db.updateLoadIDInCheckIn(syncLoadID);
    //       // checkInData?.load_id = syncLoadID;
    //       // synchroniseCheckIN(checkInData!);
    //     }
    //   } else {
    //     //  synchroniseCheckIN(checkInData!);
    //   }
    // } else {
    //   CommonMethods().showToast('Offline');
    //   db.activateOfflineCheckIn();
    //   // goToHomePage();
    // }
  }

  Future<void> processLoadRejection(String rejectionComment) async {
    if (vehData != null) {
      String fileNameLink = '';
      if(imgOfRejection != null){
         final  fileName = await  FileServices().getFilePath('load_rejection');
        if(fileName != null){
          final bytes = imgOfRejection!.readAsBytesSync();
          FileServices().saveFile(bytes, fileName);
          fileNameLink = fileName;
        }

      }
      final obj = SqlModelCheckIn(
          load_id: '',
          ref_id: checkInRefID.value,
          license_no: vehData!.licenseno,
          vehicle_reg_no: vehData!.vehregno,
          make: vehData!.make,
          vin: vehData!.vin,
          engine_no: vehData!.engineno,
          time_stamp: this.timeStamp.value,
          gps: this.gps.value,
          date_of_expiry: vehData!.expirydate,
          seal: '');
      SqlLoadDB.instance.insertInCheckINTable(isSimpleCheckIN: false, obj: obj,status: CheckInStatus.cancelled,
      rejectionPhoto: fileNameLink,rejectionReason: rejectionComment);

    }
  }
}
