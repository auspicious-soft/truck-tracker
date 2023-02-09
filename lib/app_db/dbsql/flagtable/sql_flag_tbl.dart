import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:truck_tracker/app_db/dbsql/flagtable/sql_flag_model.dart';
import 'package:truck_tracker/utils/common_methods.dart';
import '../crud_operations.dart';

import 'crud_flagtable/process_flag_data.dart';

class SQLTableFlag {
  final cm = CommonMethods();
  //Privatisation of constructor
  SQLTableFlag._privateConstructor();
  static final SQLTableFlag instance = SQLTableFlag._privateConstructor();
  //Private members
  static const table = 'flag_table';
  static Database? _database;

  //initialization
  Future<Database> get databse async => _database ??= await _initiateDatabase();

  _initiateDatabase() async {
    const dbName = 'flagDatabase.db';
    const dbVersion = 2;

    Directory docDir = await getApplicationDocumentsDirectory();
    String path = join(docDir.path, dbName);
    return await openDatabase(path, version: dbVersion, onCreate: _onCreate);
  }

  final _columnID = 'id';
  final _tonTrackData = 'tonTrackData';
  final _sealData = 'sealData';
  final _vehLicenseData = 'vehLicenseData';
  final _reportRef = 'reportRef';
  final _imgPaths = 'imgPaths';
  final _synced = 'sync';
  final _cmnt = 'cmnt';
  final _createdAt = 'createdAt';
  final tontrackID = 'tontrackID';
  final vehLicenseID = 'vehLicenID';
  final sealId = 'sealID';

  Future _onCreate(Database db, int version) async {
    //TABLE SETUP FOR PATIENT
    await db.execute('''
CREATE TABLE $table (
  $_columnID INTEGER PRIMARY KEY,
  $_tonTrackData TEXT,
  $_sealData TEXT,
  $_vehLicenseData TEXT,
  $_imgPaths TEXT,
  $_synced INTEGER NOT NULL,
  $_cmnt TEXT,
  $_reportRef TEXT NOT NULL,
  $_createdAt TEXT,
  $tontrackID TEXT,
  $vehLicenseID TEXT,
  $sealId TEXT
)
''');
  }

//:::::::::::::::::SET FUNCTIONS::::::::::::::::::;
  Future<bool> setNewLoad(
      String idTonTrack,
      String idVehLicense,
      String idSeal,
      String encodedTonTrackData,
      String encodedVehLicenseData,
      String encodedSealData,
      String encodedImgPaths,
      String reportRef,
      String comment) async {
    try {
      final timeStamp = cm.getTimeStamp();
      Map<String, dynamic> row = {
        _tonTrackData: encodedTonTrackData,
        _sealData: encodedSealData,
        _vehLicenseData: encodedVehLicenseData,
        _imgPaths: encodedImgPaths,
        _synced: 0,
        _cmnt: comment,
        _reportRef: reportRef,
        _createdAt: timeStamp,
        tontrackID: idTonTrack,
        vehLicenseID: idVehLicense,
        sealId: idSeal
      };
      Database db = await instance.databse;
      await db.insert(table, row);
      _database = null;
     // print(row);
      CommonMethods().showToast('New Report Added in sql');
      return true;
    } catch (e) {
      CommonMethods().showToast(e.toString());
      return false;
    }
  }

//::::::::::::::::::SET FUNCTIONS END::::::::::::::

//:::::::::::::::::::::GET FUNCTIONS :::::::::::::::::;;
  Future<List<SQLModelFlag?>?> getReports() async {
    try {
      Database db = await instance.databse;
      var row = await db.query(table);
     print('Report Data okok $row');

      if (row.isNotEmpty) {
        //  final db = SQLTableFlag.instance;
        final List<SQLModelFlag> listObj = [];
        for (var dataInMap in row) {
         // print('row Data $dataInMap');
          final sync = dataInMap[_synced] as int;
          final reportRef = dataInMap[_reportRef] as String;
          if (sync == 1 && reportRef.isNotEmpty) {
            final id = dataInMap[_columnID] as int;
            final tontrack = dataInMap[_tonTrackData] as String;
            final seal = dataInMap[_sealData] as String;
            final vehData = dataInMap[_vehLicenseData] as String;
             final encodedUrls = dataInMap[_imgPaths] as String;
            final listUrls =   CommonMethods().decodeStringInDynamicList(encodedUrls);

            final reportRef = dataInMap[_reportRef] as String;
            final cmnt = dataInMap[_cmnt] as String;
            final createdAt = dataInMap[_createdAt] as String;

            final idTontrack = dataInMap[tontrackID] as String;
            final idSeal = dataInMap[sealId] as String;
            final idVehReg = dataInMap[vehLicenseID] as String;

            final obj = SQLModelFlag(
                id: id,
                tonTrackData: tontrack,
                tonTrackID: idTontrack,
                sealData: seal,
                sealID: idSeal,
                vehData: vehData,
                vehID: idVehReg,
                imageUrls: listUrls,
                comment: cmnt,
                reportRef: reportRef,
                createdAt: createdAt,
                sync: 1);
            listObj.add(obj);
          }
        } //end for loop
        if (listObj.isNotEmpty) {
          return listObj;
        } else {
          return null;
        }
      } else {
        return null;
      }

    } catch (e) {
      Fluttertoast.showToast(msg: 'Error while fetching reports data $e');
      print('Error $e');
      return null;
    }
  }


  Future<SQLModelFlag?> getReportData(String scannedId) async {
    try {
      Database db = await instance.databse;
      var row = await db.query(table);
      //cm.showToast('Report Data $row');
       //print('Report Data $row');

      if (row.isNotEmpty) {
        //  SQLModelFlag? model;
        // final db = SQLTableFlag.instance;
        final List<SQLModelFlag> listObj = [];
        for (var dataInMap in row) {
          print('row Data $dataInMap');
          final id = dataInMap[_columnID] as int;
          final tontrack = dataInMap[_tonTrackData] as String;
          final seal = dataInMap[_sealData] as String;
          final vehData = dataInMap[_vehLicenseData] as String;
          final encodedUrls = dataInMap[_imgPaths] as String;
          final listUrls =   CommonMethods().decodeStringInDynamicList(encodedUrls);
          print('BANNERRRRRRRR END');
          print(listUrls);

          final reportRef = dataInMap[_reportRef] as String;
          final cmnt = dataInMap[_cmnt] as String;
          final syncAvailable = dataInMap[_synced] as int;

          final createdAt = dataInMap[_createdAt] as String;

          final idTontrack = dataInMap[tontrackID] as String;
          final idSeal = dataInMap[sealId] as String;
          final idVehReg = dataInMap[vehLicenseID] as String;

          final obj = SQLModelFlag(
              id: id,
              tonTrackData: tontrack,
              tonTrackID: idTontrack,
              sealData: seal,
              sealID: idSeal,
              vehData: vehData,
              vehID: idVehReg,
              imageUrls: listUrls,
              comment: cmnt,
              reportRef: reportRef,
              createdAt: createdAt,
              sync: syncAvailable);

          if (scannedId == idTontrack ||
              scannedId == idSeal ||
              scannedId == idVehReg) {
            return obj;
          }


        } //end for loop

        Fluttertoast.showToast(msg: 'End for loop ${listObj.length}');
        return null;
      } else {
        return null;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error while fetching Load data $e');
      print('Error $e');
      return null;
    }
  }

  Future<String?> isInFlagTable(String scannedID) async {
    try {
      Database db = await instance.databse;
      var row = await db.query(table);
      // print('scannedID   $scannedID');

      if (row.isNotEmpty) {
        // SQLModelFlag? model;

        for (var dataInMap in row) {
          print('row Data $dataInMap');
          //Fluttertoast.showToast(msg: 'dataInMap $dataInMap');
          // final dmap = dataInMap.toString();
          final idTontrack = dataInMap[tontrackID] as String;
          final idSeal = dataInMap[sealId] as String;
          final idVehReg = dataInMap[vehLicenseID] as String;
          final cmnt = dataInMap[_cmnt] as String;
          if (scannedID == idTontrack ||
              scannedID == idSeal ||
              scannedID == idVehReg) {
            return cmnt;
          }
        } //end for loop

        return null;
      } else {
        return null;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error while fetching Load data $e');
      print('Error $e');
      return null;
    }
  }

  Future<SQLModelFlag?> checkIncompleteReport( ) async {
    try {
      Database db = await instance.databse;
     // var row = await db.query(table);
      final data = await db.query(table,  where: "$_reportRef = ?", whereArgs: ['']);
       if (data.isNotEmpty) {

      //  final List<SQLModelFlag> listObj = [];
        for (var dataInMap in data) {
          print('row Data $dataInMap');
          final id = dataInMap[_columnID] as int;
          final tontrack = dataInMap[_tonTrackData] as String;
          final seal = dataInMap[_sealData] as String;
          final vehData = dataInMap[_vehLicenseData] as String;
          final encodedUrls = dataInMap[_imgPaths] as String;
          final listUrls =   CommonMethods().decodeStringInDynamicList(encodedUrls);

          print(listUrls);

          final reportRef = dataInMap[_reportRef] as String;
          final cmnt = dataInMap[_cmnt] as String;
          final syncAvailable = dataInMap[_synced] as int;

          final createdAt = dataInMap[_createdAt] as String;

          final idTontrack = dataInMap[tontrackID] as String;
          final idSeal = dataInMap[sealId] as String;
          final idVehReg = dataInMap[vehLicenseID] as String;

          final obj = SQLModelFlag(
              id: id,
              tonTrackData: tontrack,
              tonTrackID: idTontrack,
              sealData: seal,
              sealID: idSeal,
              vehData: vehData,
              vehID: idVehReg,
              imageUrls: listUrls,
              comment: cmnt,
              reportRef: reportRef,
              createdAt: createdAt,
              sync: syncAvailable);

          if (reportRef.isEmpty) {
            return obj;
          }
      } //end for loop

       // Fluttertoast.showToast(msg: 'End for loop ${listObj.length}');
        return null;
      } else {
        return null;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error while fetching Load data $e');
      print('Error $e');
      return null;
    }
  }


  void deleteAllReports() async {
    try {
      Database db = await instance.databse;
      await db.delete(table);
      CommonMethods().showToast('All reports deleted');
    } catch (e) {
      CommonMethods().showToast('Error while cancel load.\n$e');
    }
  }


//::::::::::::::::::::::::::GET FUNCTIONS END:::::::::::::::

//:::::::::::::::::::::UPDATE FUNCTIONS::::::::::::;
  void updateSync(int updationTag, whereRefID) async {
    //updationTag == 0 mean no sync
    //updationTag == 1 mean needed to sync later in case of offline or error
    try {
      Database db = await instance.databse;
      // var row = await db.query(table);

      db.update(table, {_synced: updationTag},
          where: "$_reportRef = ?", whereArgs: [whereRefID]);
      //  db.close();
      if (updationTag == 1) {
        CommonMethods().showToast('Report will sync later.');
      } else {
        CommonMethods().showToast('Report  sync removed.');
      }
    } catch (e) {
      CommonMethods().showToast('Error while making sync later $e');
    }
  }

  void removeIncompleteReport() async {
    try {
      Database db = await instance.databse;
       db.delete(table,
          where: "$_reportRef = ?", whereArgs: ['']);
      CommonMethods().showToast('Pending report deleted');
    } catch (e) {
      CommonMethods().showToast('Error while deleting  report$e');
    }
  }
//::::::::::::::::::::::END OF CLASS::::::::::::::::::::
dynamic fetchData({required CRUDFlagGet operation})async{
  try {
    Database db = await instance.databse;
    switch (operation) {
      case CRUDFlagGet.getPendingReportsData:
        final query = await db.query(table,
            where: "$_synced == ?",
            whereArgs: [0]);
        final rejectionData = await   ProcessFlagData().getPendingReportsData(query,_reportRef,tontrackID,
            sealId,
        vehLicenseID,_imgPaths,_cmnt);

        return rejectionData;

    }
  } catch (e) {
    Fluttertoast.showToast(msg: 'Error while fetching report data $e');
    print('Error $e');
    return null;
  }
}

  void updateWithoutReturn({required CRUDFlagUpdate operation, required String receivedRefID})async {
    try {
      Database db = await instance.databse;
      switch (operation) {
        case CRUDFlagUpdate.updateRejectionSynced:
          await db.update(table, {
            _synced: 1},where: "$_reportRef == ?",
              whereArgs: [receivedRefID]);
          print('Report row updated $receivedRefID');
         // getReports();
          break;
      }
      return null;
    } catch (e) {
      print(e);
      CommonMethods().showToast('Exception during updateIn FlagTable WithoutReturn $e');
    }
  }
}
