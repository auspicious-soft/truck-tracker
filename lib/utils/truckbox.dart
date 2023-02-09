// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:hive/hive.dart';
// import 'package:truck_tracker/model/checkin_model.dart';
// import 'package:truck_tracker/model/checkpointsmodel/checkpointdata.dart';
// import '../model/user_model.dart';
// import 'app_constants.dart';
//
//
// class TruckBox {
//   TruckBox._privateConstructor();
//
//   static final TruckBox instance = TruckBox._privateConstructor();
// final boxName = AppConstants.boxName;
//   // var _box = await Hive.openBox(boxName);
//   //::::::::::::::::::HIVE DB::::::::::::
//   // final _mybox = Hive.box('dbtrucktracker');
//  void  packCheckPointData( List<CheckPointData> checkPointsData) async {
//     try{
//       //  List<CheckPointData> checkpointslist = [];
//       const boxChkPts = 'CheckPointsBox';
//       var box = await Hive.openBox(boxChkPts);
//       box.add(checkPointsData);
//     //  box.close();
//       Fluttertoast.showToast(msg: 'Data added in box');
//
//     }catch(e){
//       Fluttertoast.showToast(msg: 'Error while packing data $e');
//     }
//
//     }
//     /*
//     *   Future<void> unBox() async {
//     var box = await Hive.openBox(boxName);
//     var items = box.values
//         .toList()
//         .reversed
//         .toList();
//     print(items);
//     items.forEach((element) {
//       var ele = element as UserModel;
//       Fluttertoast.showToast(msg: '${ele.barCode}');
//     });
//   }
//     * */
//   Future<List?>   getCheckPointData() async {
//     try{
//       const boxChkPts = 'CheckPointsBox';
//       var box = await Hive.openBox(boxChkPts);
//       var data = box.values;//.toList().toList().toList().toList();// as List<CheckPointData>;
//     //  Fluttertoast.showToast(msg: '${data}');
//
//      //var data = box.values;//.toList();//as List<CheckPointData>;//.toList()
//       for (var element in data) {
//          final dd = element as List;
//          return dd;
//          // dd.forEach((elementb) {
//          //   final ddd = elementb as CheckPointData;
//          //   Fluttertoast.showToast(msg: '${ddd.id}');
//          // });
//         // Fluttertoast.showToast(msg: '${dd}');
//       //  Fluttertoast.showToast(msg: '${element}');
//
//       //  Fluttertoast.showToast(msg: '$dd');
//       }
// //Fluttertoast.showToast(msg: '$data');
//       return null;
//       //  box.close();
//       Fluttertoast.showToast(msg: 'Data added in box');
//
//     }catch(e){
//       Fluttertoast.showToast(msg: 'Error while unpacking checkpoints $e');
//       return null;
//     }
//
//   }
//
//     // Fluttertoast.showToast(msg: '${hiveBox.isInBox}');
//     //find existing item per link criteria
//     //
//     // if(!hiveBox.isInBox){
//     //   box.add(hiveBox);
//     //   Fluttertoast.showToast(msg: 'Data added in box');
//     // }else{
//     //   Fluttertoast.showToast(msg: 'Data Already in box');
//     // }
//   //}
//   Future<void> packData(CheckINModel hiveBox) async {
//     // var obj = UserData("77987.0", "09890.098", "889707", "123");
//     // _mybox.add(obj);
//     // CheckINModel hiveBox = CheckINModel(
//     //     lati: '7987',
//     //     lngi: '787879',
//     //     timestamp: "54535435",
//     //     barCode: '129');
//     var box = await Hive.openBox(boxName);
//
//     if (box.isNotEmpty) {
//       var filteredUsers = box.values
//           .where((bcode) => bcode.barCode == hiveBox.barCode)
//           .toList();
//
//       var len = filteredUsers.length;
//       // print(filteredUsers.length);
//       Fluttertoast.showToast(msg: '$len');
//       if (len == 0) {
//         box.add(hiveBox);
//         Fluttertoast.showToast(msg: 'Data added in box');
//       } else {
//         Fluttertoast.showToast(msg: 'already');
//       }
//     } else {
//       box.add(hiveBox);
//       Fluttertoast.showToast(msg: 'Data added in box');
//     }
//
//     // Fluttertoast.showToast(msg: '${hiveBox.isInBox}');
//     //find existing item per link criteria
//     //
//     // if(!hiveBox.isInBox){
//     //   box.add(hiveBox);
//     //   Fluttertoast.showToast(msg: 'Data added in box');
//     // }else{
//     //   Fluttertoast.showToast(msg: 'Data Already in box');
//     // }
//   }
//
//   Future<bool> isScannedCodeAvailable(String qrcode) async {
//     var box = await Hive.openBox(boxName);
//     // showToast(qrcode);
//     // showToast(boxName);
//     var data = box.values.toList()
//         .where((CheckINModel) => CheckINModel.barCode == qrcode).toList();
//     var len = data.length;
//     // showToast(len.toString());
//
//     if (len == 0) { //blank
//       return false;
//     }
//     return true;
//   }
//
//   Future<bool> isBoxAvailable() async {
//     var box = await Hive.openBox(boxName);
//     if (box.isNotEmpty) {
//       return true;
//     }
//     return false;
//   }
//
//   Future<void> unBox() async {
//     var box = await Hive.openBox(boxName);
//     var items = box.values
//         .toList()
//         .reversed
//         .toList();
//     print(items);
//     items.forEach((element) {
//       var ele = element as UserModel;
//       Fluttertoast.showToast(msg: '${ele.barCode}');
//     });
//   }
//
//   void edit() {
//     // var box = await Hive.openBox('hive_box');
//     // DataModel dataModel = DataModel(
//     //     item: _itemController.text,
//     //     quantity: int.parse(_qtyController.text));
//     // box.put(itemKey, dataModel);
//   }
//
//   // Future<void> deletedata() async {var box = await Hive.openBox('hive_box');
//   // box.delete(items[index].key);}
// ////////::::::::::::::END
//
//   void showToast(String m) {
//     Fluttertoast.showToast(msg: m);
//   }
//
// }
