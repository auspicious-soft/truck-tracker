import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:truck_tracker/utils/common_methods.dart';

class FileServices {
  final cm = CommonMethods();
   Future<String?> getFilePath(String fileName) async {
     if(Platform.isAndroid){
       Directory? androidDirectory = await getExternalStorageDirectory(); // 1
       final timeStamp = await cm.getTimeStamp();
       final finalName = timeStamp + fileName;
       if (androidDirectory != null) {
         String appDocumentsPath = androidDirectory.path; // 2
         String filePath = '$appDocumentsPath/path$finalName.jpg'; // 3
         return filePath;
       }
     }else{
       /*Don't forget to add these values for granting access
       *<key>LSSupportsOpeningDocumentsInPlace</key>
        <true/>
          <key>UIFileSharingEnabled</key>
            <true/>
       * */
       Directory? iosDirectory = await getApplicationDocumentsDirectory(); // 1
       String appDocumentsPath = iosDirectory.path; // 2
       String filePath = '$appDocumentsPath/path$fileName.jpg'; // 3
       return filePath;
     }

    return null;
  }



   Future<bool> saveFile(Uint8List byteList, String filePath) async {
   try{
     final fileToWrite = File(filePath);
     fileToWrite.writeAsBytesSync(byteList);
     return true;
    // print(filePath);
     // Fluttertoast.showToast(msg: "saved as file $fileToWrite");
   }catch(e){
     print('Error while saving file $e');
     cm.showToast('Error while saving file $e');
     return false;
   }
  }

    Uint8List? readFile(String filePath) {
    try {
      File file = File(filePath); // 1
      Uint8List fileContent = file.readAsBytesSync(); // 2
      return fileContent;
    } catch (e) {
      return null;
    }

  }
}
