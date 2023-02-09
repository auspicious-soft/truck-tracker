import 'dart:async';
import 'dart:convert' as convert;
import 'dart:io';
import '../../../../model/model_reject_sql.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:truck_tracker/app_db/dbsharedpref/db_sharedpref.dart';
import 'package:truck_tracker/app_db/dbsql/flagtable/sql_flag_tbl.dart';
import 'package:truck_tracker/utils/app.dart';
import '../apis/network_util.dart';
import '../apis/syncserver.dart';
import '../app_db/dbsql/crud_operations.dart';
import '../app_db/dbsql/loadcheckintable/sql_loaddb.dart';
import '../firebasehelper/util_firebase_storage.dart';
import '../model/model_flag_data.dart';
import '../model/model_ton_track.dart';
import '../model/modeldatadetails.dart';
import '../utils/app_screens.dart';
import '../utils/common_methods.dart';
import '../utils/enumeration_mem.dart';
import '../utils/stringsref.dart';
import 'dart:async';

class NavigationDashBoardController extends GetxController {
  //::::::::::::::::::::::::::MEMBERS:::::::::::::::::::::::
  final sqlDBFlag = SQLTableFlag.instance;
  final cm = CommonMethods();
  DateTime? currentBackPressTime;

  Rx<bool> showNoNetworkView = false.obs;

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );
  Rx<AppScreens> appScrn = AppScreens.Home.obs;
  AppScreens? appScreen;
  late ConnectivityResult? _previousResult;
  late StreamSubscription connectivitySubscription;
  RxBool taskStatusInspector = false.obs;
  @override
  void onInit() {
    //FireStoreDB().signOut();
    super.onInit();
    // initFCM();
    checkFirstTimeNet();
    setConnectionListener();
    enableScheduleChecker();
  }

  void enableScheduleChecker() {
    //Timer is a part of Dart async library.
    Timer.periodic(const Duration(seconds: 60), (timer) async {
      // CommonMethods().showToast('Scheduled ');
      final con = await NetworkUtil().checkInternet();
      if (con) {
        checkAnyPendingTask();
      }
    });
  }

  void checkFirstTimeNet() async {
    final net = await NetworkUtil().checkInternet();
    if (net) {
      showNoNetworkView.value = false;
    } else {
      showNoNetworkView.value = true;
    }
  }

  Future<bool> checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return Future.value(true);
      } else {
        //  Fluttertoast.showToast(msg: 'No Network available');
        return Future.value(false);
      }
    } on SocketException catch (_) {
      //Fluttertoast.showToast(msg: 'No Network available');
      return Future.value(false);
    }
  }

  setConnectionListener() {
    _previousResult = ConnectivityResult.none;
    // Fluttertoast.showToast(msg: 'ConnectionListener planted');
    connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult connresult) {
      if (connresult == ConnectivityResult.none) {
        // Fluttertoast.showToast(msg: 'Internet connection un-available');
        showNoNetworkView.value = true;
      } else if (_previousResult == ConnectivityResult.none) {
        checkInternet().then((result) {
          if (result == true) {
            showNoNetworkView.value = false;
            checkAnyPendingTask();
          } else {
            showNoNetworkView.value = true;
            // Fluttertoast.showToast(msg: 'Internet connection un-available');
          }
        });
      }
      _previousResult = connresult;
    });
  }

  @override
  void dispose() {
    super.dispose();
    Fluttertoast.showToast(msg: 'Destroyed Connection listener');
    connectivitySubscription.cancel();
  }

  void changePage(AppScreens screen) {
    // appScreen = screen;
    switch (screen) {
      case AppScreens.Home:
        pageController.jumpToPage(0);
        break;
      case AppScreens.New:
        pageController.jumpToPage(1);
        break;
      case AppScreens.VehDetails:
        pageController.jumpToPage(2);
        // Get.toNamed(AppRoutes.vehscandetails, arguments: transferMap);
        break;
      case AppScreens.Load:
        pageController.jumpToPage(2);
        break;
      case AppScreens.ViewLoads:
        pageController.jumpToPage(3);
        break;
      case AppScreens.Report:
        pageController.jumpToPage(5);
        break;

      case AppScreens.NewLoad:
        break;
      case AppScreens.pgCheckInScan:
        pageController.jumpToPage(1);
        break;

      case AppScreens.PageAddnewLoad:
        // appScreen = AppScreens.PageAddnewLoad;
        break;
      case AppScreens.PgLoadVehcileDetail:
        // TODO: Handle this case.
        break;
      case AppScreens.PgAddLoadSeals:
        // TODO: Handle this case.
        break;
      case AppScreens.pgCheckInVehDetail:
        // TODO: Handle this case.
        break;
      case AppScreens.pgCheckInScanSeals:
        // TODO: Handle this case.
        break;
      case AppScreens.pgPreCheck:
        // TODO: Handle this case.
        break;
    }

    // final inx =  _controller.currentIndex;

    // pageController.animateToPage(i,
    //    duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
  }

  Future<bool> onWillPop() {
    var atHomePage = false;
    if (AppScreens == AppScreens.Home) {
      atHomePage = true;
    }

    if (atHomePage) {
      DateTime now = DateTime.now();
      if (currentBackPressTime == null ||
          now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
        currentBackPressTime = now;
        Get.snackbar(
          "",
          "Please Press Again To Exit App",
          icon: const Icon(Icons.person, color: Colors.white),
          snackPosition: SnackPosition.BOTTOM,
        );
        return Future.value(false);
      } else {
        Get.deleteAll();
        SystemNavigator.pop();
        return Future.value(true);
      }
    }
    return Future.value(false);
  }

  void onItemTapped(int index) {
    //selectedIndex.value = index;
  }

  void showExitPopup() {}

  void initFCM() {
    subscribeToMessages();
    Fluttertoast.showToast(msg: "initFCM");
    // FirebaseMessaging.onMessageOpenedApp;

    // FirebaseMessaging.onMessage.listen((RemoteMessage event) async {
    //   Fluttertoast.showToast(msg: "message received");
    //   print(event.notification!.body);
    //
    // });
    // FirebaseMessaging.onMessageOpenedApp.listen((message) async {
    //   Fluttertoast.showToast(msg: 'Message clicked!');
    // });
  }

  void subscribeToMessages() {
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    // Getting the token makes everything work as expected
    _firebaseMessaging.getToken().then((String? token) {
      assert(token != null);
    });
    // The following handler is called, when App is in the background.
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      //   Fluttertoast.showToast(msg: 'Message data: ${message.data}');
      print('Got a message whilst in the foreground!');
      // print('Message data: ${message.data}');

      if (message.notification != null) {
        Fluttertoast.showToast(
            msg:
                'Message also contained a notification: ${message.notification}');
      }
    });
  }

  Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print('message from background handler');
    print("Handling a background message: ${message.messageId}");
  }

  //:::::::::::API:::::::::::::::::

  // getCheckpoints() async {
  //   try {
  //     //replace your restFull API here.
  //     Fluttertoast.showToast(msg: '0');
  //     //  String url = "https://jsonplaceholder.typicode.com/posts";
  //     final uri = Uri.parse(
  //         'https://trucker.eluladev.space/public/api/location-details');
  //     // var url = Uri.https('https://trucker.eluladev.space/public/api/location-details');
  //     Fluttertoast.showToast(msg: '1');
  //     final response = await http.get(uri);
  //     print('Responsecheckpt $response');
  //     Fluttertoast.showToast(msg: '$response');
  //     var jsonResponse =
  //         convert.jsonDecode(response.body) as Map<String, dynamic>;
  //     Fluttertoast.showToast(msg: '$jsonResponse');
  //     if (response.statusCode == 200) {
  //       Fluttertoast.showToast(msg: '200');
  //
  //       return null;
  //     }
  //     Fluttertoast.showToast(msg: 'No data found ${response.statusCode}');
  //     return null;
  //   } catch (e) {
  //     Fluttertoast.showToast(msg: 'Exception $e');
  //     return null;
  //   }
  //
  //   //Creating a list to store input data;
  // }

  void checkAnyPendingTask() async {
    // taskStatusInspector.value = true;
    // SqlLoadDB.instance.removeAllData();
    if (!checkingPendingLoads) {
      checkPendingLoads();
    }
    if (!checkingPendingFilesSync) {
      checkPendingFilesToSyncWithServer();
    }
    if (!checkingPendingPreCheck) {
      activatePreCheck();
    }
    if (!checkingCheckInData) {
      activateCheckInTask();
    }
    if (!checkingPendingFlagData) {
      activateReportTask();
    }
    if (!checkingPendingRejectionCheckIN) {
      activateCheckINRejectionTask();
    }
  }

  //:::::::::::::::::::::::CHECK-IN BANNER TASK ::::::::::::::::
  final dbLoad = SqlLoadDB.instance;
  var checkingPendingLoads = false;
  var pendingLoadFailureAttempts = 0;
  void checkPendingLoads() async {
    final pendingLoads = await dbLoad.getPendingLoads();
    // print('PENDING LOADS $pendingLoads');
    if (pendingLoads != null) {
      checkingPendingLoads = true;
      toggleSyncAnimation();
      final status =
          await SyncServer().controlLoadData.syncPendingLoads(pendingLoads);
      if (status == EnumServerSyncStatus.failed) {
        pendingLoadFailureAttempts += 1;
        if (pendingLoadFailureAttempts > 3) {
          CommonMethods().showToast(
              'After $pendingLoadFailureAttempts attempts ${BaseApp().appName} is unable to get load IDs from the server',
              true);
          checkingPendingLoads = false;
          toggleSyncAnimation();
        } else {
          checkPendingLoads();
        }
      } else {
        checkingPendingLoads = false;
        toggleSyncAnimation();
        if (status == EnumServerSyncStatus.success) {
          activateCheckPendingLoadFiles();
        }
      }
    } else {
      activateCheckPendingLoadFiles();
    }
  }

  var checkingPendingFilesSync = false;
  void checkPendingFilesToSyncWithServer() async {
    final pendingLoadsFilesToSync = await dbLoad.getPendingLoadsFilesToSync();
    //  print('pendingLoadsFilesToSync   ');
    pendingLoadsFilesToSync?.forEach((element) {
      print('loadID  ${element.loadID}');
      print('image  ${element.image}');
      print('documents  ${element.documents}');
    });

    if (pendingLoadsFilesToSync != null) {
      checkingPendingFilesSync = true;
      toggleSyncAnimation();
      final status =
          await SyncServer().syncPendingFilesOfLoads(pendingLoadsFilesToSync);
      checkingPendingFilesSync = false;
      toggleSyncAnimation();
    }
  }

  var triggered = false;
  void toggleSyncAnimation() {
    if (checkingPendingPreCheck ||
        checkingPendingFlagData ||
        checkingPendingLoads ||
        checkingPendingLoadFiles ||
        checkingPendingLicenseFiles ||
        checkingPendingFilesSync ||
        checkingCheckInData ||
        checkingPendingRejectionCheckIN) {
      if (!triggered) {
        triggerInspector(true);
        triggered = true;
      }
    } else {
      triggerInspector(false);
      triggered = false;
    }
  }

  var checkingPendingLoadFiles = false;
  var checkingPendingLicenseFiles = false;
  void activateCheckPendingLoadFiles() async {
    final pendingFilesBox =
        await dbLoad.getPendingPodsAndLicenseImageDataForFireStore();
    //  print('pendingFilesBox :: $pendingFilesBox');

    if (pendingFilesBox != null) {
      // List<ModelFileTransferFormat?>

      final pendingPOD = pendingFilesBox.first;
      //  print('pendingPOD :: $pendingPOD');
      final pendingLicensePhotos = pendingFilesBox.last;
      if (pendingLicensePhotos.length > 0) {
        syncLicenseImages(pendingLicensePhotos);
      }
      if (pendingPOD.length > 0) {
        checkingPendingLoadFiles = true;
        toggleSyncAnimation();
        final status =
            await UtilFireStorage().storeLoadPODFilesTest(pendingPOD);
        print('Received call back at storeLoadPODFiles $status');
        checkingPendingLoadFiles = false;
        toggleSyncAnimation();
        if (!checkingPendingFilesSync) {
          checkPendingFilesToSyncWithServer();
        }
      }
    }
  }

  void syncLicenseImages(
      List<ModelFileTransferFormat?> pendingLicensePhotos) async {
    checkingPendingLicenseFiles = true;
    toggleSyncAnimation();
    final status =
        await UtilFireStorage().storeLoadLicenseFiles(pendingLicensePhotos);
    checkingPendingLicenseFiles = false;
    toggleSyncAnimation();
    if (!checkingPendingFilesSync) {
      checkPendingFilesToSyncWithServer();
    }
  }

  var checkingCheckInData = false;
  void activateCheckInTask() async {
    final checkINData = await dbLoad.getCheckInDataNeededToSynced();
    // checkINData?.forEach((element) {
    //   print('checkINData $element');
    // });
    if (checkINData != null) {
      checkingCheckInData = true;
      toggleSyncAnimation();
      final status =
          await SyncServer().syncCheckIN(pendingCheckINData: checkINData);
      checkingCheckInData = false;
      toggleSyncAnimation();
    }
  }

  void triggerInspector(bool status) {
    if (taskStatusInspector.value != status) {
      taskStatusInspector.value = status;
    }
  }

//:::::::::::::::::::::::::CHECK-IN BANNER ENDING::::::::::::::::::
  var checkingPendingFlagData = false;
  void activateReportTask() async {
    final data = await SQLTableFlag.instance
        .fetchData(operation: CRUDFlagGet.getPendingReportsData);
    if (data != null) {
      final flagReportData = data as List<ModelFlagData>;
      print('Flag data:::::::::::');
      // flagReportData.forEach((element) {
      //   print('element ${element.sealId}');
      //   print('element ${element.tonTrackId}');
      //   print('element ${element.veh_reg_no}');
      //   print('element ${element.comment}');
      //   print('element ${element.images}');
      //
      // });
      var counter = 0;
      Future.forEach(flagReportData, (flagData) async {
        checkingPendingFlagData = true;
        toggleSyncAnimation();
        counter += 1;
        final status = await SyncServer().syncPendingFlagData(flagData);
        if (counter == flagReportData.length) {
          checkingPendingFlagData = false;
          toggleSyncAnimation();
        }
      });
    }
  }

//:::::::::::::::::::::ACTIVATE REJECTION TASK::::::::::;;
  bool checkingPendingRejectionCheckIN = false;
  void activateCheckINRejectionTask() async {
    final data = await SqlLoadDB.instance.getDataFromCheckInTable(
        queryFor: CRUDCheckINGet.getPendingCheckInRejectionData);
    if (data != null) {
      final rejectionCheckInData = data as List<ModelCheckInRejectionSql>;
      print('Rejection data:::::::');
      var counter = 0;
      Future.forEach(rejectionCheckInData, (model) async {
        checkingPendingRejectionCheckIN = true;
        toggleSyncAnimation();
        counter += 1;
        final status = await SyncServer().syncCheckInRejection(model);
        print('found here rejecton counter $counter');
        if (counter == rejectionCheckInData.length) {
          checkingPendingRejectionCheckIN = false;
          toggleSyncAnimation();
        }
      });
    }
  }

  void onTapNewLoad(BuildContext context, [bool mounted = true]) async {
    moveToAddLoadPage();
  }

  void moveToAddLoadPage() {
    appScrn.trigger(AppScreens.PageAddnewLoad);
  }

  bool checkMoveAvailability() {
    if (appScreen == AppScreens.pgCheckInVehDetail ||
        appScreen == AppScreens.pgCheckInScanSeals) {
      return false;
    }
    return true;
  }

  void onTapCheckInFromHome({required Function function}) async {
    final db = SqlLoadDB.instance;
    final load = await db
        .isLoadAvailable(); // _controller.onTapNewLoadAtHomeDashboard(context);
    final isCheckInInitiated = await db.isLoadCheckInInitiated();
    final finalCheckInActivated = await db.isDriverActivatedCheckIN();
    if (load) {
      if (isCheckInInitiated) {
        function(AppScreens.pgCheckInVehDetail);
        //  onEventNav(AppScreens.pgCheckInVehDetail);
      } else {
        if (finalCheckInActivated) {
          BaseApp().showAlertOfTypeMessage(
              StringsRef.checkInActivated, Get.context!);
        } else {
          function(AppScreens.pgCheckInScan);
          //     onEventNav(AppScreens.pgCheckInScan);
        }
      }
    } else {
      CommonMethods().showToast('Please add load first.');
    }
  }

  var checkingPendingPreCheck = false;
  void activatePreCheck() async {
    final preCheckData = await DBSharedPref.instance.getPreCheckData();
    if (preCheckData != null) {
      checkingPendingPreCheck = true;
      toggleSyncAnimation();
      await SyncServer().syncPreCheckUpdation(preCheckData);
      checkingPendingPreCheck = false;
      toggleSyncAnimation();
    }
  }

  void scanTonTrack({required Function function}) async {
    final scanData = await CommonMethods().scanQR();
    if (scanData.isNotEmpty) {
      function(scanData);
    }
  }

  List<ModelDataDetails> objTonTrackData = [];

  void setTonTrackData(ModelTonTrackData ttData) async {
    try {
      var objInnerData = ModelDataDetails('ticketNo', ttData.ticketNo);
      objTonTrackData.add(objInnerData);
      objInnerData =
          ModelDataDetails('ticketGenTimeStamp', ttData.ticketGenTimeStamp);
      objTonTrackData.add(objInnerData);
      objInnerData = ModelDataDetails('source', ttData.source);
      objTonTrackData.add(objInnerData);
      objInnerData = ModelDataDetails('destination', ttData.destination);
      objTonTrackData.add(objInnerData);
      objInnerData = ModelDataDetails('grossMass', ttData.grossMass);
      objTonTrackData.add(objInnerData);

      objInnerData = ModelDataDetails('netMass', ttData.netMass);
      objTonTrackData.add(objInnerData);

      objInnerData = ModelDataDetails('hauiler', ttData.hauiler);
      objTonTrackData.add(objInnerData);

      objInnerData = ModelDataDetails('driver_name', ttData.driver_name);
      objTonTrackData.add(objInnerData);

      objInnerData = ModelDataDetails('vehReg', ttData.vehReg);
      objTonTrackData.add(objInnerData);

      objInnerData = ModelDataDetails('supplier', ttData.supplier);
      objTonTrackData.add(objInnerData);
    } catch (e) {
      //showAlert(context, 'Error: ${e.toString()}');
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
    // Fluttertoast.showToast(msg: objVehLicenseData.length.toString());
  }
}
