import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:truck_tracker/app_db/dbsql/loadcheckintable/sql_loaddb.dart';
import 'package:truck_tracker/views/navpages/home.dart';
import 'package:truck_tracker/views/precheck/pg_pre_chk.dart';
import 'package:truck_tracker/views/reports.dart';
import 'package:truck_tracker/views/truck_exit/truck_exit.dart';
import 'package:truck_tracker/views/viewloads.dart';

import '../apis/network_util.dart';
import '../controller/navdashboard_controller.dart';
import '../model/TransferSealPgModel.dart';

import '../model/trans_checkin_veh_data.dart';
import '../routes/app_routes.dart';
import '../utils/app.dart';
import '../utils/app_colors.dart';
import '../utils/app_screens.dart';
import '../utils/common_methods.dart';
import '../utils/common_widgets.dart';
import '../utils/enumeration_mem.dart';
import '../utils/image_paths.dart';
import '../utils/stringsref.dart';


import 'checkin/pg_loadcheckin.dart';
import 'newload/pg_add_new_load.dart';

class NavigationDashBoard extends StatefulWidget {
  const NavigationDashBoard({Key? key}) : super(key: key);

  @override
  State<NavigationDashBoard> createState() => _NavigationDashBoardState();
}

class _NavigationDashBoardState extends State<NavigationDashBoard>
    with TickerProviderStateMixin {
  //::::::::::::::::::::::MEMEBERS::::::

  int bottomSelectedIndex = 0;
  var falseAtHome = false;
  final NavigationDashBoardController _controller = Get.find();

  //:::::::::::::
  late TransferSealData objTransferSealData;
  late TransferCheckInVehData objTransferCheckInSealData;
  bool showNetWorkView = false;
  bool showSyncView = false;
  late AnimationController _animationController;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this,
        duration: Duration(seconds: 1),
        animationBehavior: AnimationBehavior.preserve);
    _controller.appScreen = AppScreens.Home;
    super.initState();
    _controller.appScrn.listen((value) {
      setState(() {
        _controller.appScreen = AppScreens.PageAddnewLoad;
      });
    });
    _controller.showNoNetworkView.listen((value) {
      //  CommonMethods().showToast('status $value');
      startNetWorkAnim();
      setState(() {
        showNetWorkView = value;
      });
    });
  }
  // @override
  // Future<void> didChangeDependencies() async {
  //   super.didChangeDependencies();
  //
  //
  // }
  void startNetWorkAnim() {
    _animationController.repeat(reverse: false);
    delayEndAnim();
  }

  void delayEndAnim() {
    Future.delayed(Duration(seconds: 1)).then((value) {
      _animationController.reset();
      _animationController.forward();
    });
  }

  void changeAppPage(AppScreens? page) {
    setState(() {
      _controller.appScreen = page!;
    });
  }
var flagReceiveCheckIN = false;
//::::::::::::::: WIDGETS BUILDER METHODS::::::::::::
  Widget _buildPageView( ) {
    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      controller: _controller.pageController,
      onPageChanged: (index) {
        // pageChanged(index);
      },
      children: <Widget>[
        if (_controller.appScreen == AppScreens.Home) ...{
          MainMenuHome(onEventNav: (moveTo , [anyData]) {
           // CommonMethods().showToast('Screen ${moveTo}');
            if(anyData as bool){
              setState(() {
                flagReceiveCheckIN = anyData;
              });
            }
            changeAppPage(moveTo);
            //  _controller.changePage(moveTo!);
          }),
        }
        else if (_controller.appScreen == AppScreens.TruckExit) ...{
          TruckExit(
            // onEventNav: (AppScreens? moveTo) {
            //   changeAppPage(moveTo);
            // },
          )
        }
        else if (_controller.appScreen == AppScreens.PageAddnewLoad) ...{
          PageAddNewLoad(
            onEventNav: (AppScreens? moveTo) {
               changeAppPage(moveTo);
            },
          )
        }

        else if (_controller.appScreen == AppScreens.ViewLoads) ...{
          ViewLoad(
            onEventNav: (moveTo) {
              changeAppPage(moveTo);
            },
          )
        }
        //VEH CHECKIN STARTED
        else if (_controller.appScreen == AppScreens.pgCheckInScan) ...{
          //PageLoadCheckIN(onEventNav: onEventNav, flagMoveToReceive: flagMoveToReceive)
          PageLoadCheckIN(
            onEventNav: (AppScreens? moveTo){
              // setState(() {
              //   _vehicleLicense = vehLicData;
              // });
              changeAppPage(moveTo);
            },flagMoveToReceive: flagReceiveCheckIN
          )
        } else if (_controller.appScreen == AppScreens.pgCheckInVehDetail) ...{
          // PgCheckInVehDetail(onEventNav: (moveTo, dataForSealScreen) {
          //   if (dataForSealScreen != null) {
          //     setState(() {
          //       objTransferCheckInSealData = dataForSealScreen;
          //     });
          //   }
          //
          //   changeAppPage(moveTo);
          // }),

        } else if (_controller.appScreen == AppScreens.pgCheckInScanSeals) ...{
          // PgCheckInScanSeals(
          //   objTransferCheckInSealData,
          //   onEventNav: (AppScreens? moveTo) {
          //     changeAppPage(moveTo);
          //   },
          // )
        } else if (_controller.appScreen == AppScreens.pgPreCheck) ...{
          PagePreCheck(
            onEventNav: (AppScreens? moveTo) {
              changeAppPage(moveTo);
            },
          )
        } else if (_controller.appScreen == AppScreens.Report) ...{
          Report(
            onEventNav: (AppScreens? moveTo) {
              changeAppPage(moveTo);
            },
          )
        },
      ],
    );
  }

  Widget _buildNetworkView(bool status) {
    return Column(
        children: [
          FadeTransition(
            opacity: _animationController,
      child: Container(
        width: 15,
        height: 15,
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.25), // border color
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: EdgeInsets.all(2), // border width
          child: Container(
            // or ClipRRect if you need to clip the content
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: (!status)
                  ? Colors.green
                  : Colors.red, // inner circle color
            ),
            child: Container(), // inner content
          ),
        ),
      ),
    ),
    CommonUtils().setSubHeader((!status) ? 'Online' : 'Offline', size: 13)
        ],
      );
  }

  Widget _buildSyncView() {
    return CommonUtils().setProgressLoaderVertical(ProgressMessages.Syncing);
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
  return Scaffold(
      backgroundColor: AppColors.base,
      body: WillPopScope(
        onWillPop: _controller.onWillPop,
        child: SafeArea(
          child: Container(
          //  color: AppColors.red,
            child: Column(
              children: [
                _buildTopNavigationBar(screen),
                Expanded(
                    flex: 1,
                    child: Container(
                      color: AppColors.baseBg,
                      child: _buildPageView(),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget iconitem(String path) {
    return Image.asset(
      path,
      height: 24,
    );
  }

  void onTapCheckIn() async {
    changeAppPage(AppScreens.pgCheckInScan);
    // final db = SqlLoadDB.instance;
    // final load = await db
    //     .isLoadAvailable(); // _controller.onTapNewLoadAtHomeDashboard(context);
    // final isCheckInInitiated = await db.isLoadCheckInInitiated();
    // //
    // if (load) {
    //   if (isCheckInInitiated) {
    //     //move to checkin detail ppage
    //     changeAppPage(AppScreens.pgCheckInVehDetail);
    //   } else {
    //     checkInStep2();
    //   }
    // } else {
    //   Fluttertoast.showToast(msg: 'Please add load first.');
    // }
  }

  void checkInStep2() async {
    final finalCheckInActivated =
        await SqlLoadDB.instance.isDriverActivatedCheckIN();
    //  final chk = await SQLLicenseLoadDB.instance.isDriverActivatedCheckIN();
    if (finalCheckInActivated) {
      if (!mounted) return;
      BaseApp().showAlertOfTypeMessage(StringsRef.checkInActivated, context);
    } else {
      changeAppPage(AppScreens.pgCheckInScan);
    }
  }

  moveToLoad() {
    Get.toNamed(AppRoutes.loadcheckin);
  }

  _buildTopNavigationBar(Size screen) {

    return Stack(
      children: [
        Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              width: screen.width,
              height: 120,
              color: AppColors.baseBg,
            ),
          ],
        ),
        Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  width: screen.width,
                  height: 115,
                  child: Image.asset(
                    ImagePaths.topNavbase,
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                    right: 30,
                    bottom: 5,
                    child: Row(
                      children: [
                        Obx(() {
                          return (_controller.taskStatusInspector.value)
                              ? _buildSyncView()
                              : Text('');
                        }),
                        Obx(() {
                          return _buildNetworkView(
                              _controller.showNoNetworkView.value);
                        }),
                      ],
                    ))
              ],
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
        Column(
          children: [
            SizedBox(
              height: 42,
            ),
            SizedBox(
              width: screen.width,
              height: 55,
              child: Image.asset(
                ImagePaths.topNavWhiteLine,
                fit: BoxFit.fill,
              ),
            ),
          ],
        ),
        SizedBox(
          width: screen.width,
          height: 90,
          child: Image.asset(
            ImagePaths.topNavLayerA,
            fit: BoxFit.fill,
          ),
        ),

        Positioned(
          left: 1,
          top: 5,

          child:   InkWell(
        onTap: () {
      //    print('AppScreens ${ _controller.appScreen }');
      //     if(  _controller.appScreen == AppScreens.Home){
      //       _controller.disableTruckExit();
      //     }else{
      //       changeAppPage(AppScreens.Home);
      //     }
          changeAppPage(AppScreens.Home);
          triggerPendingTask();

        },
        child: SizedBox(
            width: 75,
           height: 75,
            child: Image.asset(
              ImagePaths.logoNav,
              fit: BoxFit.scaleDown,
            )),
        )),
        Positioned(
          top: 5,
          left: 80,
          right:1,
          child: SizedBox(
            height: 45,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    changeAppPage(AppScreens.pgPreCheck);
                  },
                  child: CommonUtils().getNavMenuBtn('Precheck'),
                ),
               // spaceMenu,
                InkWell(
                  onTap: () {
                    _controller.onTapNewLoad(context);
                  },
                  child: CommonUtils().getNavMenuBtn('New Load'),
                ),
               // spaceMenu,
                InkWell(
                  onTap: () {
                    if (_controller.checkMoveAvailability()) {
                      onTapCheckIn();
                    }
                  },
                  child: CommonUtils().getNavMenuBtn('Check In'),
                ),
               // spaceMenu,
                InkWell(
                  onTap: () {
                    changeAppPage(AppScreens.Report);
                  },
                  child: CommonUtils().getNavMenuBtn('Flag'),
                ),
               // spaceMenu,
              ],
            ),
          ),
        ),

      ],
    );
  }

  void triggerPendingTask()async {

   // CommonMethods().showToast('Ready to sync${_controller.taskStatusInspector.value}');
    if(!_controller.taskStatusInspector.value){
      //CommonMethods().showToast('Ready to sync');
      final con = await  NetworkUtil().checkInternet();
      if(con){
        _controller.checkAnyPendingTask();
      }
    }
  }
}
