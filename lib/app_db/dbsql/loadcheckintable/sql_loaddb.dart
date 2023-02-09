import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:truck_tracker/app_db/dbsql/loadcheckintable/process_data/process_load_data.dart';

import 'package:truck_tracker/app_db/dbsql/loadcheckintable/sql_model_checkin_load.dart';
import 'package:truck_tracker/app_db/dbsql/loadcheckintable/sql_model_storeload.dart';
import 'package:truck_tracker/utils/app_pops.dart';

import '../../../firebasehelper/util_firebase_storage.dart';
import '../../../model/model_saveloaddoc.dart';
import '../crud_operations.dart';

import 'process_data/process_checkin_data.dart';
import 'enum_status.dart';

class SqlLoadDB {
  //Privatisation of constructor
  SqlLoadDB._privateConstructor();

  static final SqlLoadDB instance = SqlLoadDB._privateConstructor();

  //Private members
  static const tableLoadData = 'table_load_data';
  static const tableCheckInData = 'table_check_in_data';
  static Database? _database;

  //initialization
  Future<Database> get databse async => _database ??= await _initiateDatabase();

  _initiateDatabase() async {
    const dbName = 'truckerLoadData.db';
    const dbVersion = 6;

    Directory docDir = await getApplicationDocumentsDirectory();
    String path = join(docDir.path, dbName);
    return await openDatabase(path, version: dbVersion, onCreate: _onCreate);
  }

  //::::::::::::COMMON KEYS:::::::::;
  final _columnID = 'id';
  final _pendingPods = 'pending_pods';
  final _uploadedPods = 'uploaded_pods';
  final _pendingLicensePhoto = 'pending_license_photo';
  final _uploadedLicensePhoto = 'uploaded_license_photo';
  final _filesUpToDate = 'files_update';
  final licenseNo = 'license_no';
  final vehicleRegNo = 'veh_reg_no';
  final make = 'make';
  final vin = 'vin';
  final engineNo = 'engine_no';
  final dateOfExpiry = 'date_of_expiry';
  final driverName = 'driver_name';
  final driverNo = 'driver_no';
  final updateAt = 'updated_at';
  final createdAt = 'created_at';
  final seal = 'seal';
  final trailer = 'trailer';
  final refID = 'ref_id';

  //:::::::::::Load Keys ::::::::;;
  final _isCheckInInitiated =
      'ischkinitiated'; //if driver waiting for load after scan and app gone then he need not to scan
  final _isCheckInActivated = 'isCheckInActivated';
  final loadID = 'loadID';

  //:::::::::::CheckIN Keys ::::::::;;
  final timeStamp = 'time_stamp';
  final gps = 'gps';
  final _columnIsSynced = 'is_synced';
  final _columnIsSimpleCheckIn = 'simple_check_in';
  final _columnCheckInStatus = 'checkinstatus';
  final _columnRejectionReason = 'rejection_reason';
  final _columnRejectionPhotoLink = 'rejected_photo';

  Future _onCreate(Database db, int version) async {
    //TABLE SETUP FOR PATIENT
    await db.execute('''
CREATE TABLE $tableLoadData (
  $_columnID INTEGER PRIMARY KEY,
  $_pendingPods TEXT,
  $_uploadedPods TEXT,
  $_pendingLicensePhoto TEXT,
  $_uploadedLicensePhoto TEXT,
  $_filesUpToDate INTEGER NOT NULL,
  $licenseNo TEXT NOT NULL,
   $refID TEXT NOT NULL,
   $loadID TEXT,
  $vehicleRegNo TEXT,
  $make TEXT,
  $vin TEXT,
  $engineNo TEXT,
  $dateOfExpiry TEXT,
  $driverName TEXT,
  $driverNo TEXT,
  $updateAt TEXT,
  $createdAt TEXT,
  $seal TEXT,
  $trailer TEXT,
  $_isCheckInInitiated INTEGER NOT NULL,
  $_isCheckInActivated INTEGER NOT NULL 
  )
''');

    await db.execute('''
CREATE TABLE $tableCheckInData (
  $_columnID INTEGER PRIMARY KEY,
  $licenseNo TEXT,
   $refID TEXT,
   $loadID TEXT,
  $vehicleRegNo TEXT,
  $make TEXT,
  $vin TEXT,
  $engineNo TEXT,
  $dateOfExpiry TEXT,
  $updateAt TEXT,
  $createdAt TEXT,
  $seal TEXT,
  $gps TEXT,
  $timeStamp TEXT,
  $_columnIsSynced INTEGER,
  $_columnIsSimpleCheckIn INTEGER,
  $_columnCheckInStatus TEXT,
  $_columnRejectionReason TEXT,
  $_columnRejectionPhotoLink TEXT
  )
''');
  }

//:::::::::::::::::CRUD FOR LOAD TABLE::::::::::::::::::

  Future<int> insertInLoadTable(String podDocs, String loadLicensePhotos,
      SqlModelStoreLoad obj) async {
    try {
      Map<String, dynamic> row = {
        _pendingPods: podDocs,
        _uploadedPods: '',
        _pendingLicensePhoto: loadLicensePhotos,
        _uploadedLicensePhoto: '',
        _filesUpToDate: 0,
        licenseNo: obj.license_no,
        refID: obj.ref_id,
        loadID: obj.loadID,
        vehicleRegNo: obj.vehicle_reg_no,
        make: obj.make,
        vin: obj.vin,
        engineNo: obj.engine_no,
        dateOfExpiry: obj.date_of_expiry,
        driverName: obj.driver_name,
        driverNo: obj.driver_no,
        updateAt: obj.updated_at,
        createdAt: obj.created_at,
        seal: obj.seal,
        trailer: obj.trailer,
        _isCheckInInitiated: 0,
        _isCheckInActivated: 0
      };
      Database db = await instance.databse;
      final dbStatus = await db.insert(tableLoadData, row);
      _database = null;
      showToast('New load added');
      return dbStatus;
    } catch (e) {
      //  gotToException(e);
      showToast('Error while adding new load ');
      return 0;
    }
  }


  Future<SqlModelStoreLoad?> getLoadDataa(String lno) async {
    try {
      Database db = await instance.databse;
      var row = await db
          .query(tableLoadData, where: "$licenseNo == ?", whereArgs: [lno]);
      print('Load Data $row');

      if (row.isNotEmpty) {
        SqlModelStoreLoad? model;
        for (var dataInMap in row) {
          // Fluttertoast.showToast(msg: 'dataInMap $dataInMap');
          final id = dataInMap['id'] as int;
          final mloadID = dataInMap[loadID] as String;
          final mlicense_no = dataInMap[licenseNo] as String;
          final mvehicleRegNo = dataInMap[vehicleRegNo] as String;
          final mMake = dataInMap[make] as String;
          final mVin = dataInMap[vin] as String;
          final mEngineNo = dataInMap[engineNo] as String;
          final mdoe = dataInMap[dateOfExpiry] as String;
          final dname = dataInMap[driverName] as String;
          final dno = dataInMap[driverNo] as String;
          final mUpdatedAt = dataInMap[updateAt] as String;
          final mCreatedAt = dataInMap[createdAt] as String;
          final mSeal = dataInMap[seal] as String;
          final mTrailer = dataInMap[trailer] as String;
          final mrefID = dataInMap[refID] as String;

          //  Fluttertoast.showToast(msg: 'pendingdata $pendingdata');
          // final decodedData = jsonDecode(loadDataIs); //as String;
          // model = SqlModelStoreLoad.fromJson(decodedData);
          //
          model = SqlModelStoreLoad(
              id,
              mloadID,
              mlicense_no,
              mvehicleRegNo,
              mMake,
              mVin,
              mEngineNo,
              mdoe,
              dname,
              dno,
              mUpdatedAt,
              mCreatedAt,
              mSeal,
              mTrailer,
              mrefID);
        } //end for loop
        return model;
      } else {
        return null;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error while fetching Load data $e');
      return null;
    }
  }

  Future<Set<List<
      ModelFileTransferFormat?>>?> getPendingPodsAndLicenseImageDataForFireStore() async {
    List<ModelFileTransferFormat?> podDocuments = [];
    List<ModelFileTransferFormat?>licensePhotos = [];

    try {
      // List<ModelPODDocuments> podDocuments = [];
      //  List<ModelPODDocuments> licensePhotos = [];

      Database db = await instance.databse;
      var row = await db
          .query(tableLoadData,);
     // print('pod Data $row');
      // print('pod Data size ${row.length}');
      if (row.isNotEmpty) {
        for (var dataInMap in row) {
          //  print('dataInMap  $dataInMap');
          final pod = dataInMap[_pendingPods] as String;
          final rID = dataInMap[refID] as String;
          if (pod.isNotEmpty) {
            final pods = pod.split(',');
            final obj = ModelFileTransferFormat(ref_id: rID, paths: pods);
            podDocuments.add(obj);
          }
          final licenseImg = dataInMap[_pendingLicensePhoto] as String;
          if (licenseImg.isNotEmpty) {
            final licensePhoto = licenseImg.split(',');
            final obj = ModelFileTransferFormat(
                ref_id: rID, paths: licensePhoto);
            licensePhotos.add(obj);
          }
        } //end for loop
        final box = {podDocuments, licensePhotos};

        return box;
      } else {
        return null;
      }
    } catch (e) {
      gotToException(e, 'GetPendingPODFiles');
      return null;
    }
  }

  Future<List<ModelPODDocuments>?> getPendingPODFiles() async {
    try {
      List<ModelPODDocuments> podDocuments = [];
      //  List<ModelPODDocuments> licensePhotos = [];

      ModelPODDocuments modelPOD;
      Database db = await instance.databse;
      var row = await db
          .query(tableLoadData,);
      // print('pod Data $row');

      if (row.isNotEmpty) {
        for (var dataInMap in row) {
          final pod = dataInMap[_pendingPods] as String;
          final rID = dataInMap[refID] as String;
          if (pod.isNotEmpty) {
            final pods = pod.split(',');
            modelPOD = ModelPODDocuments(ref_id: rID, doc: pods);
            podDocuments.add(modelPOD);
          }
        } //end for loop
        if (podDocuments.length > 0) {
          return podDocuments;
        }
        return null;
      } else {
        return null;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error while fetching POD data $e');
      return null;
    }
  }

  Future<SqlModelStoreLoad?> getLoadData() async {
    try {
      Database db = await instance.databse;
      var row = await db.query(tableLoadData, where: "id == ?", whereArgs: [1]);
      print('Load Data $row');

      if (row.isNotEmpty) {
        SqlModelStoreLoad? model;
        for (var dataInMap in row) {
          // Fluttertoast.showToast(msg: 'dataInMap $dataInMap');
          final id = dataInMap['id'] as int;
          final mloadID = dataInMap[loadID] as String;
          final mlicense_no = dataInMap[licenseNo] as String;
          final mvehicleRegNo = dataInMap[vehicleRegNo] as String;
          final mMake = dataInMap[make] as String;
          final mVin = dataInMap[vin] as String;
          final mEngineNo = dataInMap[engineNo] as String;
          final mdoe = dataInMap[dateOfExpiry] as String;
          final dname = dataInMap[driverName] as String;
          final dno = dataInMap[driverNo] as String;
          final mUpdatedAt = dataInMap[updateAt] as String;
          final mCreatedAt = dataInMap[createdAt] as String;
          final mSeal = dataInMap[seal] as String;
          final mTrailer = dataInMap[trailer] as String;
          final mrefID = dataInMap[refID] as String;

          //  Fluttertoast.showToast(msg: 'pendingdata $pendingdata');
          // final decodedData = jsonDecode(loadDataIs); //as String;
          // model = SqlModelStoreLoad.fromJson(decodedData);
          //
          model = SqlModelStoreLoad(
              id,
              mloadID,
              mlicense_no,
              mvehicleRegNo,
              mMake,
              mVin,
              mEngineNo,
              mdoe,
              dname,
              dno,
              mUpdatedAt,
              mCreatedAt,
              mSeal,
              mTrailer,
              mrefID);
        } //end for loop
        return model;
      } else {
        return null;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error while fetching Load data $e');
      return null;
    }
  }

  Future<List<SqlModelStoreLoad>?> getPendingLoads() async {
    try {
      List<SqlModelStoreLoad> data = [];
      Database db = await instance.databse;
      var row = await db.query(
          tableLoadData, where: "$loadID == ?", whereArgs: ['']);
      // print('Load Data $row');

      if (row.isNotEmpty) {
        SqlModelStoreLoad? model;
        for (var dataInMap in row) {
          final id = dataInMap[_columnID] as int;
          final mloadID = dataInMap[loadID] as String;

          final mlicense_no = dataInMap[licenseNo] as String;
          final mvehicleRegNo = dataInMap[vehicleRegNo] as String;
          final mMake = dataInMap[make] as String;
          final mVin = dataInMap[vin] as String;
          final mEngineNo = dataInMap[engineNo] as String;
          final mdoe = dataInMap[dateOfExpiry] as String;
          final dname = dataInMap[driverName] as String;
          final dno = dataInMap[driverNo] as String;
          final mUpdatedAt = dataInMap[updateAt] as String;
          final mCreatedAt = dataInMap[createdAt] as String;
          final mSeal = dataInMap[seal] as String;
          final mTrailer = dataInMap[trailer] as String;
          final mrefID = dataInMap[refID] as String;

          model = SqlModelStoreLoad(
              id,
              mloadID,
              mlicense_no,
              mvehicleRegNo,
              mMake,
              mVin,
              mEngineNo,
              mdoe,
              dname,
              dno,
              mUpdatedAt,
              mCreatedAt,
              mSeal,
              mTrailer,
              mrefID);
          data.add(model);
        } //end for loop
        return data;
      } else {
        return null;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error while fetching Load data $e');
      return null;
    }
  }

  Future<List<ModelSaveLoadDoc>?> getPendingLoadsFilesToSync() async {
    try {
      List<ModelSaveLoadDoc> data = [];
      Database db = await instance.databse;
      var row = await db.query(
          tableLoadData, where: "$loadID != ? AND $_filesUpToDate == ?",
          whereArgs: ['', 0]);
      //   print('Load Data with load ID $row');

      if (row.isNotEmpty) {
        for (var dataInMap in row) {
          final mLoadID = dataInMap[loadID] as String;
          final pendingPods = dataInMap[_pendingPods] as String;
          final pendingLicense = dataInMap[_pendingLicensePhoto] as String;
          if (pendingPods.isEmpty && pendingLicense.isEmpty) {
            final uploadedPods = dataInMap[_uploadedPods] as String;
            final uploadedLicense = dataInMap[_uploadedLicensePhoto] as String;
            //OR Gate because both are optional
            if (uploadedPods.isNotEmpty || uploadedLicense.isNotEmpty) {
              //batch found to be uploaded
              final obj = ModelSaveLoadDoc(loadID: mLoadID,
                  image: uploadedLicense,
                  documents: uploadedPods);
              data.add(obj);
            }
          }
        } //end for loop
        if (data.length > 0) {
          return data;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      print('Error while fetching getPendingLoadsFilesToSync $e');
      Fluttertoast.showToast(
          msg: 'Error while fetching getPendingLoadsFilesToSync $e');
      return null;
    }
  }

  Future<bool> isLoadAvailable() async {
    Database db = await instance.databse;
    final row = await db.query(tableLoadData);
    //  print(row);
    if (row.isNotEmpty) {
      //// showToast('$row');
      return true;
    }
    return false;
  }

  Future<bool> isDriverActivatedCheckIN() async {
    try {
      Database db = await instance.databse;
      final row = await db.query(tableLoadData);
      print('Load Data $row');

      if (row.isNotEmpty) {
        for (var dataInMap in row) {
          final isActivated = dataInMap[_isCheckInActivated] as int;
          if (isActivated == 0) {
            return false;
          } else {
            return true;
          }
        }
      } else {
        return false;
      }
    } catch (e) {
      showToast('Error found $e');
    }
    return false;
  }


  void cancelLoad() async {
    try {
      Database db = await instance.databse;
      await db.delete(tableLoadData);
      await db.delete(tableCheckInData);
      //showToast('Load removed');
    } catch (e) {
      showToast('Error while cancel load.\n$e');
    }
  }

//::::::::::::::::::SET FUNCTIONS END::::::::::::::

//:::::::::::::::::::::GET FUNCTIONS :::::::::::::::::;;

  Future<List<SqlModelCheckIn>?> getCheckInDataNeededToSynced() async {
    try {
      Database db = await instance.databse;
      //     var row = await db.query(tableLoadData, where: "$loadID != ?", whereArgs: ['']);
      var row =
      await db.query(tableCheckInData,
          where: "$_columnIsSynced == ? AND $_columnIsSimpleCheckIn == ? AND $_columnCheckInStatus != ?",
          whereArgs: [0, 0,CheckInStatus.cancelled.name]);
      print('Check-In Data $row');
      List<SqlModelCheckIn> data = [];
      if (row.isNotEmpty) {
        SqlModelCheckIn? model;
        for (var dataInMap in row) {
          // Fluttertoast.showToast(msg: 'dataInMap $dataInMap');
          final mloadID = dataInMap[loadID] as String;
          final mlicense_no = dataInMap[licenseNo] as String;
          final mvehicleRegNo = dataInMap[vehicleRegNo] as String;
          final mMake = dataInMap[make] as String;
          final mVin = dataInMap[vin] as String;
          final mEngineNo = dataInMap[engineNo] as String;
          final mdoe = dataInMap[dateOfExpiry] as String;
          final mTimeStamp = dataInMap[timeStamp] as String;
          final mGps = dataInMap[gps] as String;

          final mSeal = dataInMap[seal] as String;

          final mrefID = dataInMap[refID] as String;

          model = SqlModelCheckIn(
              load_id: mloadID,
              ref_id: mrefID,
              license_no: mlicense_no,
              vehicle_reg_no: mvehicleRegNo,
              make: mMake,
              vin: mVin,
              engine_no: mEngineNo,
              time_stamp: mTimeStamp,
              gps: mGps,
              date_of_expiry: mdoe,
              seal: mSeal);
          data.add(model);
        } //end for loop
        return data;
      } else {
        return null;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error while fetching Load data $e');
      return null;
    }
  }


//::::::::::::::::::::::CONDITION FUNCTIONS::::::::::::::::::::
  Future<bool> isLoadCheckInInitiated() async {
    try {
      Database db = await instance.databse;
      final row = await db.query(tableLoadData);
      print('Load Data $row');

      // if (row.isNotEmpty) {
      for (var dataInMap in row) {
        final value = dataInMap[_isCheckInInitiated] as int;
        if (value == 1) {
          return true;
        } else {
          return false;
        }
      }
      // } else {
      //   return false;
      // }
    } catch (e) {
      showToast('Error found $e');
      // return false;
    }

    return false;
  }

  void updateFileSyncForFollowingLoads(List<String> loads) async {
    try {
      Database db = await instance.databse;
      // var res = await db .query(table);

      // db.update(table, values)
      Future.forEach(loads, (ldID) async {
        await db.update(
            tableLoadData, {_filesUpToDate: 1}, where: "$loadID == ?",
            whereArgs: [ldID]);
      });

      //  db.close();
      print('updated filesupload');
    } catch (e) {
      showToast('Error updateFileSyncForFollowingLoads $e');
    }
  }

  void updateCheckInInitiated() async {
    try {
      Database db = await instance.databse;
      // var res = await db .query(table);

      // db.update(table, values)
      db.update(tableLoadData, {_isCheckInInitiated: 1});
      //  db.close();
      print('Check-IN initiated');
    } catch (e) {
      showToast('Error Check-IN initiated $e');
    }
  }

  Future<bool> isLicenseMatched(String receivedLicense) async {
    try {
      Database db = await instance.databse;
      final row = await db.query(tableLoadData);
      print('Load Data $row');

      // if (row.isNotEmpty) {
      for (var dataInMap in row) {
        final loadLincese = dataInMap[licenseNo] as String;
        if (loadLincese == receivedLicense) {
          return true;
        } else {
          return false;
        }
      }
      // } else {
      //   return false;
      // }
    } catch (e) {
      showToast('Error found $e');
    }
    return false;
  }

  void activateOfflineCheckIn() async {
    try {
      Database db = await instance.databse;
      db.update(
          tableLoadData, {_isCheckInInitiated: 0, _isCheckInActivated: 1});

      showToast('Check-In activated we will sync it later.');
    } catch (e) {
      showToast('Error updating activating check-IN $e');
    }
  }

  Future<int> updateCheckInTableWithLoadIDWitReference(
      {required String receivedLoadID, required String receivedLoadRefID}) async {
    try {
      Database db = await instance.databse;
      final status = await db.update(
          tableCheckInData, {loadID: receivedLoadID, _columnIsSynced: 1},
          where: "$refID == ?", whereArgs: [receivedLoadRefID]);
      //  db.close();
      return status;
      //  showToast('Load ID Updated');
    } catch (e) {
      gotToException(e);
      return 0;
    }
  }

  // void updateLoadID(String mLoadID) async {
  //   try {
  //     Database db = await instance.databse;
  //     // var res = await db .query(table);
  //
  //     // db.update(table, values)
  //     db.update(tableLoadData, {loadID: mLoadID});
  //     //  db.close();
  //     showToast('Load ID Updated');
  //   } catch (e) {
  //     showToast('Error updating loadID $e');
  //   }
  // }
  //

  void updateLoadTableWithUploadedLicenseLinks(
      {required String mRef_id, required String updatedLink,
        required String leftLocalPaths }) async {
    try {
      Database db = await instance.databse;
      String convertedUpdatedLicense = '';
      // var res = await db .query(table);
      //get uploaded links and pending links
      final pendingPODData = await db.query(
          tableLoadData, where: "$refID == ?", whereArgs: [mRef_id]);
      pendingPODData.forEach((data) {
        final updatedLicenselinks = data[_uploadedLicensePhoto] as String;
        if (updatedLicenselinks.isNotEmpty) {
          final inArray = updatedLicenselinks.split(',');
          inArray.add(updatedLink);
          convertedUpdatedLicense = inArray.join(',');
        } else {
          convertedUpdatedLicense = updatedLink;
        }
      });
      if (convertedUpdatedLicense.isNotEmpty) {
        showToast('updateLoad License Links Updated');
        db.update(tableLoadData, {
          _uploadedLicensePhoto: convertedUpdatedLicense,
          _pendingLicensePhoto: leftLocalPaths
        }, where: "$refID == ?", whereArgs: [mRef_id]);
      }

      //  db.close();

    } catch (e) {
      print(e);
      showToast('Exception during updating img links$e');
      //  gotToException(e);

    }
  }

  Future<String> getLoadID() async {
    var mlastLoadId = '';
    try {
      Database db = await instance.databse;
      final row = await db.query(tableLoadData);
      print('FULL ROW $row');
      if (row.isNotEmpty) {
        for (var dataInMap in row) {
          // Fluttertoast.showToast(msg: 'dataInMap $dataInMap');
          mlastLoadId = dataInMap[loadID] as String;
          return mlastLoadId;
        } //end for loop
        return mlastLoadId;
      } else {
        return mlastLoadId;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error while fetching Load data $e');
    }
    return mlastLoadId;
  }


  void showToast(dynamic e) {
    Fluttertoast.showToast(msg: e.toString());
  }



  void gotToException(Object e, [String methodName = '']) {
    AppPops().showAlertOfTypeErrorWithDismiss(
        'Exception IN SQL $e\nMethod Effected:$methodName');
  }

  Future<void> removeAllData() async {
    try {
      Database db = await instance.databse;
      db.delete(tableLoadData);
      db.delete(tableCheckInData);
    } catch (e) {
      gotToException(e, 'removeAllData');
    }
  }
  //::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//::::::::::::::::::::::LOAD CRUD FUNCTIONS:::::::::::::::::::::::
//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


  dynamic  getDataFromLoadTable(
      {required CRUDLoadGet queryFor, String mRef_id = '' }) async {
    try {
      Database db = await instance.databse;

      switch (queryFor) {

        case CRUDLoadGet.getLoadID:
          // final query = await db.query(tableLoadData,
          //     where: "$_columnIsSynced == ? AND $_columnCheckInStatus == ?",
          //     whereArgs: [0, CheckInStatus.cancelled.name]);
          // final rejectionData = await   ProcessCheckInData().getPendingRejectionData(query,refID, _columnRejectionReason,_columnRejectionPhotoLink);
          // return rejectionData;
          break;
        case CRUDLoadGet.getDriverNameAndLicenseNo:
          var row = await db.query(tableLoadData, orderBy: "Id DESC LIMIT 1");
          final listData = await ProcessLoadData().getDriverNameAndLicenseNo(row,licenseNo,driverName);
          return listData;

      }
      return null;
    } catch (e) {
      print(e);
      showToast('Exception during getDataFromCheckInTable $e');
      //  gotToException(e);

    }
  }
  void updateInLoadTableWithoutReturn({required CRUDLoadUpdate operation, required String receivedRefID, required String mUpdatedLinks,
    required String mLeftLocalPaths})async {
    try {
      Database db = await instance.databse;

      switch (operation) {

        case CRUDLoadUpdate.updatePODs:
          db.update(tableLoadData,
              {_uploadedPods: mUpdatedLinks, _pendingPods: mLeftLocalPaths},
              where: "$refID == ?", whereArgs: [receivedRefID]);
          print('Pods updated');
          break;
      }
      return null;
    } catch (e) {
      print(e);
      showToast('Exception during updation in LoadTable $e');

    }
  }

  dynamic updateInLoadTableWithReturn({required CRUDLoadUpdate operation, required String receivedRefID, required String receivedLoadID,
     }) async {

    try {
      Database db = await instance.databse;

      switch (operation) {

        case CRUDLoadUpdate.updatePODs:

          break;
        case CRUDLoadUpdate.updateLoadID:
          final status = await db.update(
              tableLoadData, {loadID: receivedLoadID}, where: "$refID == ?",
              whereArgs: [receivedRefID]);
          //  db.close();
          return status;

      }
      return null;
    } catch (e) {
      print(e);
      showToast('Exception during updation in LoadTable $e');

    }
  }
//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//::::::::::::::::::::::CHECK IN CRUD FUNCTIONS:::::::::::::::::::::::
//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

  void insertInCheckINTable(
      {required bool isSimpleCheckIN, required SqlModelCheckIn obj, CheckInStatus status = CheckInStatus.active, String rejectionPhoto = '', String rejectionReason = ''}) async {
    try {
      Map<String, dynamic> row = {
        licenseNo: obj.license_no,
        refID: obj.ref_id,
        loadID: '',
        vehicleRegNo: obj.vehicle_reg_no,
        make: obj.make,
        vin: obj.vin,
        engineNo: obj.engine_no,
        dateOfExpiry: obj.date_of_expiry,
        updateAt: '',
        createdAt: '',
        gps: obj.gps,
        timeStamp: obj.time_stamp,
        seal: obj.seal,
        _columnIsSynced: 0,
        _columnIsSimpleCheckIn: (isSimpleCheckIN) ? 1 : 0,
        _columnCheckInStatus: status.name,
        _columnRejectionReason: rejectionReason,
        _columnRejectionPhotoLink: rejectionPhoto
      };
      Database db = await instance.databse;
      await db.insert(tableCheckInData, row);
      _database = null;
      // updateCheckInInitiated();

      print('New check-In added');
      return null;
    } catch (e) {
      showToast('Error while adding new check-In\nPlease reinstall app\n$e');
      // return e.toString();
    }
  }


 dynamic  getDataFromCheckInTable(
      {required CRUDCheckINGet queryFor, String mRef_id = '' }) async {
    try {
      Database db = await instance.databse;

      switch (queryFor) {
        case CRUDCheckINGet.getPendingCheckInData:
        // TODO: Handle this case.
          break;
        case CRUDCheckINGet.getPendingCheckInRejectionData:
          final query = await db.query(tableCheckInData,
              where: "$_columnIsSynced == ? AND $_columnCheckInStatus == ?",
              whereArgs: [0, CheckInStatus.cancelled.name]);
        final rejectionData = await   ProcessCheckInData().getPendingRejectionData(query,refID, _columnRejectionReason,_columnRejectionPhotoLink);
             return rejectionData;

      }
      return null;
    } catch (e) {
      print(e);
      showToast('Exception during getDataFromCheckInTable $e');
      //  gotToException(e);

    }
  }

  void updateInCheckInTableWithoutReturn({required CRUDCheckINUpdate operation, required String receivedRefID})async {

    try {
      Database db = await instance.databse;

      switch (operation) {

        case CRUDCheckINUpdate.updateRejectionSynced:
          await db.update(tableCheckInData, {
            _columnIsSynced: 1},where: "$refID == ?",
              whereArgs: [receivedRefID]);
          print('Rejection row updated');
          break;
      }
      return null;
    } catch (e) {
      print(e);
      showToast('Exception during updateInCheckInTableWithoutReturn $e');

    }
  }


}


