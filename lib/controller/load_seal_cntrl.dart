import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:truck_tracker/apis/syncserver.dart';

import '../apis/network_util.dart';
import '../app_db/dbsharedpref/db_sharedpref.dart';
import '../app_db/dbsql/loadcheckintable/sql_loaddb.dart';
import '../app_db/dbsql/loadcheckintable/sql_model_storeload.dart';
import '../model/TransferSealPgModel.dart';
import '../utils/app.dart';
import '../utils/common_methods.dart';
import '../utils/enumeration_mem.dart';

class LoadSealController extends GetxController {
  Rx<bool> isRequesting = false.obs;
  Rx<bool> moveToHome = false.obs;
  Rx<String> refID = ''.obs;
  Rx<String> rejRefID = ''.obs;

  Future<void> scanVehicleLicense({required Function function}) async {
    // Fluttertoast.showToast(msg: 'jjh');
    try {
      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", false, ScanMode.QR);

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

//{required Function function}
//   void onSubmit(
//     TransferSealData loadScanData,
//     List arrayOfSeals,
//   ) async {
//     refID.value = await CommonMethods().getRefID(EnumReferenceType.addLoad);
//     DateTime dateToday = DateTime.now();
//     String date = dateToday.toString().substring(0, 10);
//     final vehData = loadScanData.vehLicenData;
//     final seals = arrayOfSeals.join(",");
//     final bodyAddload = SqlModelStoreLoad(0,
//         '',
//         vehData.licenseno,
//         vehData.vehregno,
//         vehData.make,
//         vehData.vin,
//         vehData.engineno,
//         vehData.expirydate,
//         loadScanData.driverName,
//         loadScanData.driverNo,
//         date,
//         date,
//         seals,
//         loadScanData.trialers,
//         refID.value);
//     // final encodedLoadData = jsonEncode(bodyAddload);
//
//     isRequesting.value = true;
//
//     final receivedLoadID = await SyncServer().syncLoad(bodyAddload);
//     final db = SqlLoadDB.instance;
//     if (receivedLoadID != null) {
//       bodyAddload.loadID = receivedLoadID;
//       //update sql
//       // db.updateLoadID(loadID);
//     }
//     final anyError = await db.insertInLoadTable(bodyAddload);
//
//     isRequesting.value = false;
//     moveToHome.value = true;
//
//     // function(anyError);
//   }

  //:::::::::::::::::::::::WEB SERVICES::::::::::::::::::::::::::

  void submitReasonWithoutPhoto(String id, String reason) async {
    var con = await NetworkUtil().checkInternet();
    if (!con) {
      DBSharedPref.instance.saveCheckInRejection(id, reason, '', true);
      return;
    }
    SyncServer().syncCheckINRejectionWithoutPhoto(id, reason);
    moveToHome.value = true;
  }

  final ImagePicker _picker = ImagePicker();

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
      moveToHome.value = true;
      return;
    }
    SyncServer().syncCheckINRejectionWithPhoto(licenseNo, reason, imgPath,
        function: (value) {});
    SqlLoadDB.instance.cancelLoad();
    moveToHome.value = true;
  }

  void setUpRejectionView() async {
    rejRefID.value = await CommonMethods().getRefID(EnumReferenceType.checkIn);
  }
}
