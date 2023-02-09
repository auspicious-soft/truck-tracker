// import 'dart:convert';
// import 'dart:io';
//
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';
//
// import '../../model/model_storeload.dart';
// /*Set load counter this counter will do recursive task to run storeload api
//   * and at the end of the counter we will run checkin api
//   * Things to consider
//   * If user started checkin process then
//   *   App will only display checkin screen with all of the values store in db
//   *
//   * On Exit or on checkin done  data will be deleted
//   *
//   *
//   * */
// class DBSqlLoadCheckIN {
//   //Privatisation of constructor
//   DBSqlLoadCheckIN._privateConstructor();
//   static final DBSqlLoadCheckIN instance = DBSqlLoadCheckIN._privateConstructor();
//
//   //Private members
//   static const tblPendingUpload = 'pending_upload_table';
//   static Database? _database;
//   //initialization
//   Future<Database> get databse async => _database ??= await _initiateDatabase();
//   _initiateDatabase() async {
//     const dbName = 'truckTrackerPendingUpload.db';
//     const dbVersion = 1;
//
//     Directory docDir = await getApplicationDocumentsDirectory();
//     String path = join(docDir.path, dbName);
//     return await openDatabase(path,
//         version: dbVersion, onCreate: _onCreate);
//   }
//
//     final  loadCounter = 'loadCounter';
//   final licenseNo = 'licenseNo';
//   final lastLoadId = 'lastLoadId';
//   final loadData = 'loadData';
//   final isCheckInActivated = 'isCheckInActivated';
//   final checkInData = 'checkInData';
//   final columnID = 'id';
//   //static const pendingData = 'pendingData';
// //:::::::::::BASIC DB FUNCTIONALITY:::::::::::
//
//
//
//   Future _onCreate(Database db, int version) async {
//     //TABLE SETUP FOR PATIENT
//     await db.execute(
//         '''
// CREATE TABLE $tblPendingUpload (
//   $columnID INTEGER PRIMARY KEY,
//   $licenseNo TEXT NOT NULL,
//   $loadCounter INTEGER NOT NULL ,
//   $lastLoadId TEXT,
//   $loadData TEXT NOT NULL,
//   $isCheckInActivated INTEGER NOT NULL,
//   $checkInData TEXT
// )
// ''');
//   }
// //:::::::::::::::::SET FUNCTIONS::::::::::::::::::;
//
//
// //::::::::::::::::::SET FUNCTIONS END::::::::::::::
//
// //:::::::::::::::::::::GET FUNCTIONS :::::::::::::::::;;
//   Future<String> getLoadID() async {
//     var mlastLoadId = '';
//     try {
//       Database db = await instance.databse;
//       final row =  await db.query(tblPendingUpload);
//       print('FULL ROW $row');
//       if (row.isNotEmpty) {
//         for (var dataInMap in row) {
//           // Fluttertoast.showToast(msg: 'dataInMap $dataInMap');
//           mlastLoadId = dataInMap[lastLoadId] as String;
//          return mlastLoadId;
//
//         } //end for loop
//         return mlastLoadId;
//       }else{
//         return mlastLoadId;
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: 'Error while fetching Load data $e');
//
//     }
//     return mlastLoadId;
//   }
//  void  getCheckInWholeData({  required Function function}) async {
//       try {
//         Database db = await instance.databse;
//          final row =  await db.query(tblPendingUpload);
//       print('FULL Data $row');
//
//         if (row.isNotEmpty) {
//           //  List<BodyStoreLoad> apiStoreLoad = [];
//           ///  Fluttertoast.showToast(msg: 'dataFirstLayer ${row.length}');
//           //   Fluttertoast.showToast(msg: 'dataFirstLayer $dataFirstLayer');
//          // SQLModelPendingUpload? model;
//           for (var dataInMap in row) {
//             dynamic loadData;// = dataInMap['loadData:'];
//             dynamic checkInData;
//            dataInMap.forEach((key, value) {
//              if(key == 'loadData'){
//                  loadData = value;
//              }
//              if(key == 'checkInData'){
//                checkInData = value;
//              }
//            });
//             //
//             // Fluttertoast.showToast(msg: 'dataFirstLayer $dataInMap');
//             // final checkInData = dataInMap['checkInData:'];
// function(loadData,checkInData);
// break;
//             // Fluttertoast.showToast(msg: 'dataInMap $dataInMap');
//         //    final loadDataIs = dataInMap[loadData] as String;
//             //  Fluttertoast.showToast(msg: 'pendingdata $pendingdata');
//             // final mmm = dataInMap.toString();// as String;
//             // final decodedData = jsonDecode(mmm); //as String;
//             // model = SQLModelPendingUpload.fromJson(decodedData);
//             //  print(model);
//             //  Fluttertoast.showToast(msg: 'model ${model.license_no}');
//             //Analyse Type of api
//
//           } //end for loop
//           //return model;
//         }else{
//           return null;
//         }
//       } catch (e) {
//         Fluttertoast.showToast(msg: 'Error while fetching Load data $e');
//         return null;
//       }
//     return null;
//   }
//
// //::::::::::::::::::::::::::GET FUNCTIONS END:::::::::::::::
// //$cassetteImg TEXT NOT NULL
//   //FUNCTION TO INSERT QUERY , UPDATE AND DELETE
//   // Future<int> insert(Map<String, dynamic> row) async {
//   //   Database db = await instance.databse;
//   //   return await db.insert(table, row);
//   // }
//   activateNewLoad(Map<String, dynamic> row) async {
//     try{
//       Database db = await instance.databse;
//       await db.insert(tblPendingUpload, row);
//       _database = null;
//      // db.close();
//       showToast('New load added');
//     }catch(e){
//       showToast('Error while adding new load $e');
//     }
//
//   }
//   Future<List<Map<String, dynamic>>?> getFromPendingTable( ) async {
//     try {
//       Database db = await instance.databse;
//       //   var uid = FirebaseAuth.instance.currentUser!.uid;
//       var res = await db.query(tblPendingUpload);
//       closeDB(db);
//       if(res.isNotEmpty){
//         return res;
//       }
//       return null;
//     } catch (e) {
//       print(e);
//       showToast('Exception while finding pending data');
//       return null;
//     }
//   }
// //:::::::::::::::::::::UPDATE FUNCTIONS::::::::::::;
//   void updateLoadCounterAndActivateCheckIN(String mLicenseno)async  {
//     try{
//       Database db =  await instance.databse;
//       var res = await db.query(tblPendingUpload, where: "$licenseNo == ?", whereArgs: [mLicenseno]);
//       var counter = 0;
//       for (var element in res) {
//         counter = element[loadCounter] as int;
//       }
//       // var counter = await getUpLoadCounter(recLastLoadID);
//       counter = counter + 1;
//       db.update(tblPendingUpload,{loadCounter:counter,isCheckInActivated:1},where: "$licenseNo = ?",whereArgs: [mLicenseno] );
//       //  db.close();
//       showToast('CheckIn Activated and will sync when network available');
//     }catch(e){
//       showToast('Error updating counter $e');
//     }
//   }
//   void  updateLoadCounter(String mLicenseno) async {
//     try{
//       Database db =  await instance.databse;
//       var res = await db.query(tblPendingUpload, where: "$licenseNo == ?", whereArgs: [mLicenseno]);
//       var counter = 0;
//       res.forEach((element) {
//         counter = element[loadCounter] as int;
//       });
//       // var counter = await getUpLoadCounter(recLastLoadID);
//       counter = counter + 1;
//       db.update(tblPendingUpload,{loadCounter:counter},where: "$licenseNo = ?",whereArgs: [mLicenseno] );
//       //  db.close();
//       showToast('Task added to pending upload');
//     }catch(e){
//       showToast('Error updating counter $e');
//     }
//
//   }
//   Future<bool> insertCheckInDataInPendingTask(String CheckInData) async {
//     try{
//       Database db =  await instance.databse;
//     //  var res = await db.query(tblPendingUpload);
//      final value = await  db.update(tblPendingUpload,{checkInData:CheckInData});
//       //  db.close();
//       if(value == 1){
//         return true;
//       }else {
//         showToast('oops unable to insert check in data');
//         return false;
//       }
//
//     }catch(e){
//       showToast('Error updating databse $e');
//     }
//     return false;
//   }
//
//
//   //::::::::::::::::::::::UPDATE FUNCTIONS END:::::::::::::::
//
//
// //::::::::::::::::::::::CONDITION FUNCTIONS::::::::::::::::::::
//   Future<bool> isLoadAvailable() async {
//      Database db = await instance.databse;
//        final row =  await db.query(tblPendingUpload);
//     if(row.isNotEmpty){
//       return true;
//     }
//     return false;
//   }
//
//   Future<bool> isDriverActivatedCheckIN() async {
//     try{
//       Database db = await instance.databse;
//       final row =  await db.query(tblPendingUpload);
//        print('Load Data $row');
//
//       if (row.isNotEmpty) {
//          for (var dataInMap in row) {
//           final   isActivated = dataInMap[isCheckInActivated] as int;
//           if(isActivated == 0 ){
//             return false;
//           }else{
//             return true;
//           }
//         }
//       }else{
//         return false;
//       }
//     }catch(e){
//        showToast('Error found $e');
//     }
//     return false;
//   }
//
//   //
//   // Future <SQLModelPendingUpload?> getPendingTask() async {
//   //   try {
//   //     Database db = await instance.databse;
//   //      final row =  await db.query(tblPendingUpload);
//   //   //  var row  = await db.query(tblPendingUpload, where: "id == ?", whereArgs: [1]);
//   //     print('Load Data $row');
//   //
//   //     if (row.isNotEmpty) {
//   //       //  List<BodyStoreLoad> apiStoreLoad = [];
//   //       ///  Fluttertoast.showToast(msg: 'dataFirstLayer ${row.length}');
//   //       //   Fluttertoast.showToast(msg: 'dataFirstLayer $dataFirstLayer');
//   //       SQLModelPendingUpload? model;
//   //       for (var dataInMap in row) {
//   //         // Fluttertoast.showToast(msg: 'dataInMap $dataInMap');
//   //         final loadDataIs = dataInMap[loadData] as String;
//   //         //  Fluttertoast.showToast(msg: 'pendingdata $pendingdata');
//   //         final decodedData = jsonDecode(loadDataIs); //as String;
//   //         model = BodyStoreLoad.fromJson(decodedData);
//   //         //  print(model);
//   //         //  Fluttertoast.showToast(msg: 'model ${model.license_no}');
//   //         //Analyse Type of api
//   //
//   //       } //end for loop
//   //       return model;
//   //     }else{
//   //       return null;
//   //     }
//   //   } catch (e) {
//   //     Fluttertoast.showToast(msg: 'Error while fetching Load data $e');
//   //     return null;
//   //   }
//   // }
//   Future<ModelStoreLoad?> getLoadData() async {
//     try {
//       Database db = await instance.databse;
//       //  final row =  await db.query(tblPendingUpload);
//       var row =
//           await db.query(tblPendingUpload, where: "id == ?", whereArgs: [1]);
//       print('Load Data $row');
//      // Fluttertoast.showToast(msg: 'row ${row}');
//       //   //return res;
//       //  final dataFirstLayer = await   DBSql.instance.getFromPendingTable();
//       if (row.isNotEmpty) {
//         //  List<BodyStoreLoad> apiStoreLoad = [];
//       ///  Fluttertoast.showToast(msg: 'dataFirstLayer ${row.length}');
//         //   Fluttertoast.showToast(msg: 'dataFirstLayer $dataFirstLayer');
//         ModelStoreLoad? model;
//         for (var dataInMap in row) {
//           // Fluttertoast.showToast(msg: 'dataInMap $dataInMap');
//           final loadDataIs = dataInMap[loadData] as String;
//           //  Fluttertoast.showToast(msg: 'pendingdata $pendingdata');
//           final decodedData = jsonDecode(loadDataIs); //as String;
//           model = ModelStoreLoad.fromJson(decodedData);
//           //  print(model);
//         //  Fluttertoast.showToast(msg: 'model ${model.license_no}');
//           //Analyse Type of api
//
//         } //end for loop
//         return model;
//       }else{
//         return null;
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: 'Error while fetching Load data $e');
//       return null;
//     }
//   }
//   // Future<int> updateData(int id) async {
// //   Database db = await instance.databse;
// //   var res = await db.update(table, {"name": "Desi Programmer", "age": 99},
// //       where: "id = ?", whereArgs: [id]);
// //   return res;
// // }
//   void checkDataInDB()async  {
//   Database db = await instance.databse;
//   //db.
//       final data = await  db.query(tblPendingUpload);
//
//       print('DATA IS :::::   $data');
//  // db.close();
//   }
// //QUERY ALL ROWS
//   // Future<List<Map<String, dynamic>>> fetchAllReports() async {
//   //   Database db = await instance.databse;
//   //   return await db.query(table);
//   // }
//   // Future<List<Map<String, Object?>>?> fetchAllReports() async {
//   //   try {
//   //     Database db = await instance.databse;
//   //     var uid = FirebaseAuth.instance.currentUser!.uid;
//   //     var res = (await db.query(tblPendingUpload, where: "$userID = ?", whereArgs: [uid]));
//   //     closeDB(db);
//   //
//   //     return res;
//   //   } catch (e) {
//   //     print(e);
//   //     showToast(e);
//   //
//   //     return null;
//   //   }
//   // }
//
//   // Future<List<Map<String, dynamic>>> queryspecific(int age) async {
//   //   Database db = await instance.databse;
//   //   //   var res = await db.query(table, where: "age > ?", whereArgs: [age]);
//   //   //return res;
//   //   //raw
//   //   var res = await db.rawQuery('SELECT * FROM my_table WHERE age >?', [age]);
//   //   return res;
//   // }
//
//   // Future<bool> isCassettIDAvailabel(String id) async {
//   //   Database db = await instance.databse;
//   //   var res = await db.query(tblPendingUpload, where: "$cassetteID == ?", whereArgs: [id]);
//   //   closeDB(db);
//   //   if (res.isEmpty) {
//   //     return false;
//   //   } else {
//   //     return true;
//   //   }
//   // }
//
//   Future<int> deletedata(int id) async {
//     Database db = await instance.databse;
//     var res = await db.delete(tblPendingUpload, where: "id = ?", whereArgs: [id]);
//     return res;
//   }
//
//   Future<int> deleteWholeData() async {
//     Database db = await instance.databse;
//     var res = await db.delete(tblPendingUpload);
//     closeDB(db);
//     return res;
//   }
//
//   void closeDB(Database db) {
//     _database = null;
//     db.close();
//   }
//
//   void showToast(dynamic e) {
//     Fluttertoast.showToast(msg: e.toString());
//   }
//
//   void cancelLoad() async {
//     Database db = await instance.databse;
//     await db.delete(tblPendingUpload);
//    showToast('Load removed');
//   }
//
//
//
//
//
//
//
// // Future<int> updateData(int id) async {
// //   Database db = await instance.databse;
// //   var res = await db.update(table, {"name": "Desi Programmer", "age": 99},
// //       where: "id = ?", whereArgs: [id]);
// //   return res;
// // }
//
// }
