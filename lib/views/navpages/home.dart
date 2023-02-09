import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:truck_tracker/apis/network_util.dart';
import 'package:truck_tracker/controller/navdashboard_controller.dart';
import 'package:truck_tracker/utils/common_widgets.dart';
import '../../app_db/dbsharedpref/db_sharedpref.dart';
import '../../firebasehelper/pg_firestore.dart';
import '../../routes/app_routes.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_screens.dart';
import '../../utils/common_methods.dart';
import '../../utils/image_paths.dart';
import '../../utils/stringsref.dart';
import '../testdocscanner/cameraexample.dart';

class MainMenuHome extends StatefulWidget {
  final Function(AppScreens? moveTo, [ dynamic anydata ]) onEventNav;

  MainMenuHome({super.key, required this.onEventNav});
  //createState(): When the Framework is instructed to build a StatefulWidget, it immediately calls createState()

  @override
  State<MainMenuHome> createState() => _MainMenuHomeState();
}

class _MainMenuHomeState extends State<MainMenuHome>{
  final NavigationDashBoardController _controller =
  NavigationDashBoardController();


  @override
  Widget build(BuildContext context) {
    //
    return Stack(
      children: [
        CommonUtils().setBaseView(),
        _buildHomeView(context)
   ],
   );
  }
  _buildHomeView(BuildContext context){
 return   Padding(
      padding: const EdgeInsets.only(top: 0.0, right: 20.0, left: 20.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

             Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                    onTap: () {
                    widget.onEventNav(AppScreens.pgPreCheck,false);
                    },
                    child: CommonUtils.menuButton(
                        ImagePaths.precheck, StringsRef.precheck,30.0, 30.0)),
                const SizedBox(
                  width: 20,
                ),
                InkWell(
                  onTap: () {
                    widget.onEventNav(AppScreens.pgCheckInScan,false);
                    // _controller.onTapCheckInFromHome(function: (appscreen){
                    //   onEventNav(appscreen,false);
                    // });

                  },
                  child:
                  CommonUtils.menuButton(ImagePaths.checkin, StringsRef.checkin),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                    onTap: () {
                      processOnTapNewLoad(context);
                    },
                    child: CommonUtils.menuButton(
                        ImagePaths.newload, StringsRef.newload,30.0, 30.0)),
                const SizedBox(
                  width: 20,
                ),
                InkWell(
                  onTap: () {
                    widget.onEventNav(AppScreens.TruckExit,false);
                //    _controller.enableTruckExit();

                  },
                  child:
                  CommonUtils.menuButton(ImagePaths.truckexit, StringsRef.truckexit,40,40 ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                    onTap: () {
                      widget.onEventNav(AppScreens.pgCheckInScan,true);
                      // _controller.onTapCheckInFromHome(function: (appscreen){
                      //   onEventNav(appscreen,true);
                      // });

                    },
                    child: CommonUtils.menuButton(
                        ImagePaths.icnreceive, 'Receiving',30,30)),
                // InkWell(
                //     onTap: () {
                //       onEventNav(AppScreens.ViewLoads,false);
                //     },
                //     child: CommonUtils.menuButton(
                //         ImagePaths.viewload, StringsRef.viewload,30,30)),
                const SizedBox(
                  width: 20,
                ),
                InkWell(
                    onTap: () {
                      widget.onEventNav(AppScreens.Report,false);
                    },
                    child:
                    CommonUtils.menuButton(ImagePaths.report, StringsRef.flag)),


              ],
            ),
          //  TextButton(onPressed:(){ moveToFireStoreTest(context);} , child:Text('Firestore'))

          ],
        ),
      ),
    );
  }

  Future<void> showLogoutPop(
    BuildContext context,
  ) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: CommonUtils().setHeader('Alert', size: 20),
            content:
                CommonUtils().setHeader('Are you sure to logout?', size: 18),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.base,
                ),
                child: CommonUtils()
                    .setSubHeader('Yes', size: 10, color: AppColors.white),
                onPressed: () {
                  Navigator.pop(context);
                  DBSharedPref.instance.unlockUser();
                  Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login,
                      (Route<dynamic> route) => false);
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.base,
                ),
                child: CommonUtils()
                    .setSubHeader('No', size: 10, color: AppColors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  void processOnTapNewLoad(BuildContext context, [bool mounted = true]) async {

    widget.onEventNav(AppScreens.PageAddnewLoad,false);
  }

  void moveToCameraTest(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context)=>     CameraAccess()));
  }

  void moveToFireStoreTest(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context)=>     PageFireStore()));
  }

}
