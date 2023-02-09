
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:truck_tracker/utils/common_methods.dart';
import '../apis/api_constants.dart';
import '../apis/data_class.dart';

import '../model/model_load.dart';
import 'package:http/http.dart' as http;

class LoadViewController extends GetxController {
  RxList loadData = [].obs;
RxBool isRequesting = false.obs;
  @override
  void onInit() {

    super.onInit();
    Fluttertoast.showToast(msg: 'init');
   // filldata();
  }
  void getLoadData()async{
    //SignInBody signInBody = SignInBody(username: email,password: password,devicename: 'test');
    //CommonMethods().showToast('Loading');
    isRequesting.value = true;
    var provider = Provider.of<DataClass>(Get.context!,listen:false);
    await provider.postGet(POSTEndPoints.getload);
    isRequesting.value = false;
    if(provider.isSuccess){
     // print(provider.responseData?.body.toString());
     parseloadResponse(provider.responseData);

    }
  }
  void parseloadResponse(http.Response? response) {
    // {"message":"The device name field is required.","errors":{"device_name":["The device name field is required."]}}

    try {
      final jsonData = response?.body;
      final parsedJson = jsonDecode(jsonData!);
      print('Get loads ${parsedJson}');
      final pData = parsedJson['data'];
      final sData = pData['data'] as List ;
      List<ModelLoad> mloadData = [] ;
      for (var element in sData) {
       // CommonMethods().showToast( element);
        print(element['license_no']);
        final license_no = element['license_no'];
        final created_at = element['created_at'];
        final make = element['make'];

        var obj =ModelLoad(license_no,created_at, make ,1);
        mloadData.add(obj);
      }
      if(mloadData.isNotEmpty){
        loadData.value = mloadData;
      }


   //   final licenseNo = sData['data'];
      // final parsedData = ModelViewLoads.fromJson(parsedJson);
    ///  CommonMethods().showToast( sData.length);

    } catch (e) {
      Fluttertoast.showToast(msg: 'Received Error while parsing... $e');
      print(e);
    }
  }
  // void filldata() {
  //
  //   var obj =ModelLoad('macroof', 'Founder & Ceo', '20', 'Bmw', 'ok');
  //   loadData.add(obj);
  //   obj =ModelLoad('jhon', 'Founder & Ceo', '10', 'Bmw', 'ok');
  //   loadData.add(obj);
  //   obj =ModelLoad('Nelson', 'Founder & Ceo', '40', 'Suzuki', 'ok');
  //   loadData.add(obj);
  //   obj =ModelLoad('Finin', 'Founder & Ceo', '50', 'Honda', 'ok');
  //   loadData.add(obj);
  //   obj =ModelLoad('Racoo', 'Founder & Ceo', '100', 'Mahindra', 'ok');
  //   loadData.add(obj);
  //   loadData.add(obj);
  //   loadData.add(obj);
  //   loadData.add(obj);
  //   loadData.add(obj);
  //   obj =ModelLoad('jhon', 'Founder & Ceo', '10', 'Bmw', 'ok');
  //   loadData.add(obj);
  //   obj =ModelLoad('Nelson', 'Founder & Ceo', '40', 'Suzuki', 'ok');
  //   loadData.add(obj);
  //   obj =ModelLoad('Finin', 'Founder & Ceo', '50', 'Honda', 'ok');
  //   loadData.add(obj);
  //   loadData.add(obj);
  //   loadData.add(obj);
  //   loadData.add(obj);
  //   loadData.add(obj);
  //   loadData.add(obj);
  //   loadData.add(obj);
  //   loadData.add(obj);
  //   loadData.add(obj);
  //   loadData.add(obj);
  //   loadData.add(obj);
  //   loadData.add(obj);
  //   loadData.add(obj);
  //   loadData.add(obj);
  //   loadData.add(obj);
  //   loadData.add(obj);
  //   loadData.add(obj);
  //   loadData.add(obj);
  //   loadData.add(obj);
  //   loadData.add(obj);
  //   loadData.add(obj);
  //   loadData.add(obj);
  //   loadData.add(obj);
  //   loadData.add(obj);
  //   loadData.add(obj);
  //   loadData.add(obj);
  //   loadData.add(obj);
  //   loadData.add(obj);
  //   loadData.add(obj);
  //   loadData.add(obj);
  //   loadData.add(obj);
  //   loadData.add(obj);
  //   loadData.add(obj);
  //   loadData.add(obj);
  //   loadData.add(obj);
  //   loadData.add(obj);
  //
  // }

/*
*  data: {current_page: 1, data: [{id: 74, license_no: JX30TGGP, vehicle_reg_no: 2132
13, date_of_expiry: 10-11-2025, make: 2013, vin: 4861, engine_no: 8718, driver_name: juli,
* driver_no: 1234567890, truck_id: 10, trailer_ids: 32,33, status: active,
 reason: null, ref_id: 13453, image: null, created_at: 2022-11-11T10:13:57.000000Z,
 *  updated_at: 2022-11-11T10:13:57.000000Z,
 *  trailers: [{id: 32, license_no: 323},
{id: 33, license_no: 232}],
* trucks: {id: 10, license_no: JX30TGGP, description: null, make: 2013, vin: 4861, engine_no: 8718, date_of_expiry: 10-11-2025, transport
er_id: null, created_at: 2022-10-14T11:30:22.000000Z, updated_at: 2022-11-11T10:13:57.000000Z},
*  seals: [{id: 98, load_id: 74, license_no: JX30TGGP, seal: 12, seal_
type: load, created_at: 2022-11-11T10:13:57.000000Z, updated_at: 2022-11-11T10:13:57.000000Z}]}
*
* */
}
