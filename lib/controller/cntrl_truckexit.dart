import 'package:edge_detection/edge_detection.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../model/modeldatadetails.dart';
import '../utils/common_methods.dart';
import '../utils/enumeration_mem.dart';
import '../utils/util_scanner.dart';
class TruckExitController extends GetxController {
  RxBool previewExitReference = false.obs;
  List<String> documents = [];
  RxBool previewVehLicenseData = false.obs;

  List<ModelDataDetails> objVehLicenseData = [];
  Future<void> scanVehicleLicense() async {

       final  vehData =    await  UtilScanner().scanVehicleLicenseCode();

      if(vehData != null){
        previewVehLicenseData.value = true;
        objVehLicenseData = CommonMethods().getStructuredLicenseData(vehData);
      }

  }

  RxBool docAdded  = false.obs;
  Future<void> onTapAddDocument() async  {
    String? imagePath;
    // We also handle the message potentially returning null.
    try {
      imagePath = (await EdgeDetection.detectEdge);
      print("$imagePath");
    } on PlatformException catch (e) {
      imagePath = e.toString();
    }
    if(imagePath!=null){
      documents.add(imagePath);
      docAdded.trigger(true);
      // docAdded.value = true;
    }


  }
  // Rx<bool> displayTruckExit = false.obs;
  // Rx<bool> previewTonTrackView = false.obs;
  Rx<String> exitRefID = "".obs;

  void setUpTontrackView() async {
    exitRefID.value = await CommonMethods().getRefID(EnumReferenceType.exit);
    previewExitReference.value = true;

  }
}
