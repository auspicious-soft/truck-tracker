import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';

class MainMenuController extends GetxController {
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

  Future<bool> onWillPop() {
    return Future.value(true);
    // DateTime now = DateTime.now();
    // if (currentBackPressTime == null ||
    //     now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
    //   currentBackPressTime = now;
    //   Get.snackbar(
    //     "",
    //     "Please Press Again To Exit App",
    //     icon: const Icon(Icons.person, color: Colors.white),
    //     snackPosition: SnackPosition.BOTTOM,
    //   );
    //   return Future.value(false);
    // }
    // return Future.value(true);
  }
}
