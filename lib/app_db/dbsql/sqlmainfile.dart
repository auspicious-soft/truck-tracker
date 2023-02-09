// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';
// import 'dart:io';
//
// class DBSql {
//   //Privatisation of constructor
//   DBSql._privateConstructor();
//   static final DBSql instance = DBSql._privateConstructor();
//
//   //Private members
//   static const tblPendingUpload = 'pending_upload_table';
//   static Database? _database;
//   //initialization
//  Future<Database> get databse async => _database ??= await _initiateDatabase();
//   _initiateDatabase() async {
//     const dbName = 'truckTracker.db';
//       const dbVersion = 1;
//
//     Directory docDir = await getApplicationDocumentsDirectory();
//     String path = join(docDir.path, dbName);
//     return await openDatabase(path,
//         version: dbVersion, onCreate: _onCreate);
//   }
//
//   static const columnID = 'id';
//   static const pendingData = 'pendingData';
// //:::::::::::BASIC DB FUNCTIONALITY:::::::::::
//
//
//   Future _onCreate(Database db, int version) async {
//     //TABLE SETUP FOR PATIENT
//     await db.execute(
//         '''
// CREATE TABLE $tblPendingUpload (
//   $columnID INTEGER PRIMARY KEY,
//   $pendingData TEXT NOT NULL
// )
// ''');
//   }
//
// //$cassetteImg TEXT NOT NULL
//   //FUNCTION TO INSERT QUERY , UPDATE AND DELETE
//   // Future<int> insert(Map<String, dynamic> row) async {
//   //   Database db = await instance.databse;
//   //   return await db.insert(table, row);
//   // }
//   saveInPendingTable(Map<String, dynamic> row) async {
//     Database db = await instance.databse;
//     await db.insert(tblPendingUpload, row);
//     _database = null;
//     db.close();
//   }
//   Future<List<Map<String, dynamic>>?> getFromPendingTable( ) async {
//       try {
//         Database db = await instance.databse;
//      //   var uid = FirebaseAuth.instance.currentUser!.uid;
//         var res = await db.query(tblPendingUpload);
//         closeDB(db);
// if(res.isNotEmpty){
//   return res;
// }
//         return null;
//       } catch (e) {
//         print(e);
//         showToast('Exception while finding pending data');
//         return null;
//       }
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
// // Future<int> updateData(int id) async {
// //   Database db = await instance.databse;
// //   var res = await db.update(table, {"name": "Desi Programmer", "age": 99},
// //       where: "id = ?", whereArgs: [id]);
// //   return res;
// // }
//
// }
