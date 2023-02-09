import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:truck_tracker/app_db/dbsql/crud_operations.dart';
import 'package:truck_tracker/app_db/dbsql/loadcheckintable/sql_loaddb.dart';

import '../utils/enumeration_mem.dart';
enum StorageFolders{
  pod,license
}
class ModelPendingToUploadTransferFiles{
  String refID;
  String pendingLinks;
  String updatedLinks;
  ModelPendingToUploadTransferFiles({required this.refID, required this.pendingLinks, required this.updatedLinks});
}
class ModelPODDocuments{
  String ref_id;
  List<String> doc;
  ModelPODDocuments({required this.ref_id,required this.doc});
}
class ModelFileTransferFormat{
  String ref_id;
  List<String> paths;
  ModelFileTransferFormat({required this.ref_id,required this.paths});
}
class UtilFireStorage{
  //Factory constructor
  UtilFireStorage._privateConstructor();

  static final UtilFireStorage _instance = UtilFireStorage._privateConstructor();

  factory UtilFireStorage() {
    return _instance;
  }

  final storage = FirebaseStorage.instance;
  void checkPendingLoadPODFiles() async {
    final pendingPODFiles = await SqlLoadDB.instance.getPendingPODFiles();
    pendingPODFiles?.forEach((element) {
      print('pendingPODFiles : ${element.ref_id}');
      print('pendingPODFiles : ${element.doc}');
    });

    // final p1 = '/storage/emulated/0/Android/data/com.elulaonline.truckertrack/files/Pictures/smart_scanner/crop_9480.jpeg';
    // final p2 = '/storage/emulated/0/Android/data/com.elulaonline.truckertrack/files/Pictures/smart_scanner/crop_11364.jpeg';
    // final localPaths = [p1,p2];
    // UtilFireStorage().storeLoadPODFiles( localPaths);
  }
  Future<int> synca() async {
    final abc = ['A','B','C'];
    final onetwothree = [1,2,3];
    await  Future.forEach(abc, (alphabet) async {
      final doneokkkkk = await  Future.forEach(onetwothree, (alphabettttt) async {
        sleep(Duration(seconds: 3));
        print(alphabettttt);
      });
      // sleep(Duration(seconds: 3));
      // print(alphabet);
    });
    return 1;
  }
  Future<int> syncb() async {
    final abc = ['A','B','C'];
    final onetwothree = [1,2,3];
    await  Future.forEach(abc, (alphabet) async {
      final doneokkkkk = await  Future.forEach(onetwothree, (alphabettttt) async {
        sleep(Duration(seconds: 3));
        print(alphabettttt);
      });
      // sleep(Duration(seconds: 3));
      // print(alphabet);
    });
    return 1;
  }
  Future<int> syncc() async {
    final abc = ['A','B','C'];
    final onetwothree = [1,2,3];
    await  Future.forEach(abc, (alphabet) async {
      final doneokkkkk = await  Future.forEach(onetwothree, (alphabettttt) async {
        sleep(Duration(seconds: 3));
        print(alphabettttt);
      });
      // sleep(Duration(seconds: 3));
      // print(alphabet);
    });
    return 1;
  }
  Future<String> syncd() async {
    final abc = ['A','B','C'];
    final onetwothree = [1,2,3];
    await  Future.forEach(abc, (alphabet) async {
      final doneokkkkk = await  Future.forEach(onetwothree, (alphabettttt) async {
        sleep(Duration(seconds: 3));
        print(alphabettttt);
      });
      // sleep(Duration(seconds: 3));
      // print(alphabet);
    });
    return '1';
  }
  Future<EnumServerSyncStatus> batchSync() async {
    try{
      final results = await Future.wait([
        synca(),
        syncb(),
        syncb(),
        syncb(),
      ]);
      return EnumServerSyncStatus.complete;
    }catch (e){
      return EnumServerSyncStatus.failed;
    }
  }
  Future<EnumServerSyncStatus> storeLoadPODFilesTest(  List<ModelFileTransferFormat?> podDoc) async {
    try{
      final storageRef = storage.ref();
      var outerPODCounter = 0;
      var innerPODCounter = 0;
List<String> updatedPaths = [];
      List<String> removePaths = [];
while(outerPODCounter < podDoc.length){
  final refID = podDoc[outerPODCounter]!.ref_id;
  final localPaths = podDoc[outerPODCounter]?.paths;
  print('localPaths length = ${localPaths?.length}');
  removePaths.addAll(localPaths!);
  innerPODCounter = 0;
 while(innerPODCounter < localPaths!.length){
   final path = localPaths[innerPODCounter];
   File file = File(path);
   final fileName =    basename(path);
   final finalPath = '${StorageFolders.pod.name}/${fileName}';
   Reference? imagesRef = storageRef.child(finalPath);
   final updatedLink = await _uploadFile(imagesRef, file);
   print('innerPODCounter $innerPODCounter');
   print('updatedLink $updatedLink');
   innerPODCounter += 1;
   print('After increment');
   print('innerPODCounter $innerPODCounter');
   print('localPaths length = ${localPaths?.length}');
   updatedPaths.add(updatedLink!);
   removePaths.removeAt(0);
   print('updatedPaths $updatedPaths');
 //  print('removePaths $removePaths');
   final updatedLinks = updatedPaths.join(',');
   final leftPaths = removePaths.join(',');
   print('removePaths $leftPaths');
   SqlLoadDB.instance.updateInLoadTableWithoutReturn(operation: CRUDLoadUpdate.updatePODs, receivedRefID: refID,
       mUpdatedLinks: updatedLinks, mLeftLocalPaths: leftPaths);
//  SqlLoadDB.instance.updateLoadTableWithUploadedPODLinks(mRef_id: refID, mUpdatedLinks: updatedLinks, mLeftLocalPaths: leftPaths);
 }
  print('outerPODCounter $outerPODCounter');
  outerPODCounter += 1;
  print('Length of podDoc ${podDoc.length}');
  print('After increment outerPODCounter $outerPODCounter');
}
  print('Returned');
      return EnumServerSyncStatus.complete;
    }catch (e){
      print('Exception $e');
      return EnumServerSyncStatus.failed;
    }

  }
  Future<EnumServerSyncStatus> storeLoadPODFiles(  List<ModelFileTransferFormat?> podDoc) async {
try{
  final storageRef = storage.ref();
  var innerPODCounter = 0;
  List<ModelPendingToUploadTransferFiles> sqlUpdationBox = [];
  String updationLinks = '';
  String mPendingLinks = '';

    for(ModelFileTransferFormat? podObj in podDoc)   {

    final List<String> uploadedFileNameHolder  = [];
      List<String> shadowLocalPaths  = [];

    print(podObj?.ref_id);
    print(podObj?.paths);
    final localPaths = podObj?.paths;
 //await  Future.forEach(localPaths!, (path) async {
   for(String path in localPaths!){
    // shadowLocalPaths = localPaths;
      innerPODCounter  += 1;
      print('localPaths count ${localPaths.length}');
      print('innerPODCounter $innerPODCounter');
      //Future.delayed(Duration(seconds: 5));
     // print('---------Finish Inner------');
       File file = File(path);
      final fileName =    basename(path);
      final finalPath = '${StorageFolders.pod.name}/${fileName}';
      uploadedFileNameHolder.add(finalPath);
      Reference? imagesRef = storageRef.child(finalPath);
     // localPaths.removeAt(0);
      final removedLink =  localPaths.join(',');
     final updatedLink = await _uploadFile(imagesRef, file);
       if(updatedLink != null){
         try{
           print('Store Path : $updatedLink');
           //final indexOfRemoveLink = shadowLocalPaths.indexOf(path);
          // shadowLocalPaths.add(path);
           // shadowLocalPaths.forEach((element) {
           //   print(element);
           // });


             mPendingLinks = mPendingLinks + removedLink;
             print('mPendingLinks $mPendingLinks');
           // updationLinks = updationLinks +','+ updatedLink;
           // if(innerPODCounter == podObj?.paths.length){
           //   final obj = ModelPendingToUploadTransferFiles(refID: podObj!.ref_id, pendingLinks: mPendingLinks, updatedLinks: updationLinks);
           //   sqlUpdationBox.add(obj);
           // }
         }catch(e){
           print('Exception : $e');
         }


       //  updateStoreLinkInLocal( podObj!.ref_id,updatedLink,removedLink);

      }
      print('localPaths count after remove ${localPaths.length}');
    }
   //);
    print('----------------');
    // sqlUpdationBox.forEach((element) {
    //   print(element.updatedLinks);
    //   print(element.refID);
    //   print(element.pendingLinks);
    // });
    print('------END-------');
  }
    //);
  print('Returned');
  return EnumServerSyncStatus.complete;
}catch (e){
  print('Exception $e');
  return EnumServerSyncStatus.failed;
}

  }

  Future<EnumServerSyncStatus>  storeLoadLicenseFiles ( List<ModelFileTransferFormat?> licenseImages) async {
try {
  final storageRef = storage.ref();
  var licenseCounter = 0;
  for (ModelFileTransferFormat? licenObj in licenseImages) {
    final List<String> uploadedFileNameHolder = [];

    print(licenObj?.ref_id);
    print(licenObj?.paths);
    final localPaths = licenObj?.paths;
    localPaths?.forEach((path) async {
      licenseCounter += 1;
      print('licenseCounter $licenseCounter');
      File file = File(path);
      final fileName = basename(path);
      final finalPath = '${StorageFolders.license.name}/${fileName}';
      uploadedFileNameHolder.add(finalPath);
      Reference? imagesRef = storageRef.child(finalPath);
      ////Upload index
      final updatedLink = await _uploadLicenseFile(imagesRef, file);
      var indexCounter = 0;
      if (updatedLink != null) {
        print('Store License Path : $updatedLink');

        localPaths.removeAt(indexCounter);
        indexCounter += 1;

        final removedLink = localPaths.join(',');

        SqlLoadDB.instance.updateLoadTableWithUploadedLicenseLinks(
            mRef_id: licenObj!.ref_id,
            updatedLink: updatedLink, leftLocalPaths: removedLink);
      }
    });
    print('----------------');
  }
  print('Returned');
  return EnumServerSyncStatus.complete;
}catch(e){
  print('Returned');
  return EnumServerSyncStatus.failed;
}

  }


  Future<String?> _uploadFile(Reference storageRef, File file) async {
    try {

     final snapshot =  await storageRef.putFile(file);
     var downloadUrl = await snapshot.ref.getDownloadURL();
     return downloadUrl;

    } catch (e) {
      print("Upload file path error ${e.toString()} ");
   return null;
    }
  }

  Future<String?> _uploadLicenseFile(Reference storageRef, File file) async {
    try {

      final snapshot =  await storageRef.putFile(file);
      var downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;

    } catch (e) {
      print("Upload file path error ${e.toString()} ");
      return null;
    }
  }



}