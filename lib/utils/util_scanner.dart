import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:truck_tracker/model/model_license_data.dart';
import 'package:truck_tracker/model/modeldatadetails.dart';
import 'package:truck_tracker/utils/app_pops.dart';
import 'package:truck_tracker/utils/common_methods.dart';
import 'package:velocity_x/velocity_x.dart';

import 'app_colors.dart';
import 'common_widgets.dart';

class UtilScanner{
  //Factory constructor
  UtilScanner._privateConstructor();

  static final UtilScanner _instance = UtilScanner._privateConstructor();

  factory UtilScanner() {
    return _instance;
  }
 Future<ModelLicenseData?> scanVehicleLicenseCode( ) async {
   try {
     String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
         "#ff6666", "Cancel", true, ScanMode.QR);
     if (barcodeScanRes.isNotEmpty && barcodeScanRes.length > 3) {
      var data = barcodeScanRes
           .split('%') // split the text into an array
           .map((String text) => text) // put the text inside a widget
           .toList();
       data.removeAt(0);
       if (data.length < 10) {
         CommonMethods().showToast('Invalid QRCode');
         return null;
       } else {
         final number = data[4];
         final licenseNo = data[5].toString();
         final vehRegNo = data[6].toString();
         final vin = data[11].toString();
         final engineno = data[12].toString();
         final make = data[8].toString();
         final description = data[7].toString();
         final expirydate = data[13].toString();
         final obj = ModelLicenseData(number, licenseNo, vehRegNo, vin, engineno,
             '', '', '', make, description, '', '', '', expirydate);
         return obj;
       }
     }else{
       return null;
     }
       } catch (e) {
     AppPops().showAlertOfTypeErrorWithDismiss( 'Exception during scanVehicleLicenseCode  $e ');
     return null;
   }
  }

//::::::::::::::::::::::::::::WIDGET SECTIONS::::::::::::::::::::::::::::::::::::::::::::::::::
  _getVehDataBuilder(List<ModelDataDetails> dataDetail) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount:  dataDetail.length,
      // +1 because you are showing one extra widget.
      itemBuilder: (BuildContext context, int index) {
        // if (index == 0) {
        String? title = dataDetail[index].title;
        String? data = dataDetail[index].data;
        final fulldata = '${title!} = ${data!}';
        return Row(
          children: [
            CommonUtils()
                .setSubHeader(fulldata, color: AppColors.white, size: 17),
          ],
        );

      },
    );
  }
  Future<Widget> getVehicleLicensePlateView( List<ModelDataDetails> vehData ) async {
    try {
     return Container(
          decoration: BoxDecoration(
              color: AppColors.base,
              borderRadius:
              BorderRadius.all(Radius.elliptical(10.0, 10.0)),
              border: Border.all(
                  width: 1.0, color: AppColors.base)),
          child: Center(
            child: Padding(
              padding:   EdgeInsets.all(10.0),
              child: Align(alignment: Alignment.topLeft, child: _getVehDataBuilder(vehData)),
            ),
          ));
    } catch (e) {
      return Container(child: 'Error while returning veh plate\n$e'.text.color(Colors.red).make(),);
    }
  }

  Future<String?> scanBarCode() async {
    try {
      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.QR);
      if (barcodeScanRes.isNotEmpty && barcodeScanRes.length > 3) {
        return barcodeScanRes;


      }else{
        return null;
      }
    } catch (e) {
      AppPops().showAlertOfTypeErrorWithDismiss( 'Exception during scanBarCode  $e ');
      return null;
    }
  }
}