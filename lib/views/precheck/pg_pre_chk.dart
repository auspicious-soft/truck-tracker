import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:truck_tracker/apis/syncserver.dart';
import 'package:truck_tracker/app_db/dbsql/loadcheckintable/sql_loaddb.dart';
import 'package:truck_tracker/utils/app.dart';
import 'package:truck_tracker/utils/common_methods.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../app_db/dbsharedpref/shared_model_precheck.dart';
import '../../controller/cntrl_precheck.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_screens.dart';
import '../../utils/common_widgets.dart';
import '../../utils/enumeration_mem.dart';
import '../../utils/image_paths.dart';
import '../../utils/stringsref.dart';

class PagePreCheck extends StatefulWidget {
  final Function(AppScreens? moveTo) onEventNav;

  const PagePreCheck({super.key, required this.onEventNav});

  @override
  State<PagePreCheck> createState() => _PgPreCheckState();
}

class _PgPreCheckState extends State<PagePreCheck> {
  final ControllerPreCheck _controller = ControllerPreCheck();
  //var commentViewActivated = false;
 ///// var previewProceedView = false;
    var space = SizedBox(height: 10);
  final myController = TextEditingController();
  String comment = "";
  bool toggleComment = true;
  bool toggleAllClear = false;
  @override
  void initState() {
   super.initState();
   _controller.setPreCheckRefID();

   _controller.getCurrentLocation();
  }
  @override
  void dispose() {
     super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CommonUtils().setBaseView(),
        Obx(() {
          return (_controller.pvVehicleDetail.value)
              ? _buildVehDetailView()
              : _buildScanBody();
        }),
      ],
    );
  }

  _buildCommentView(){
  return Column(

    children: [
      Visibility(
        visible: toggleComment,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonUtils().setHeader(StringsRef.comments),
            Container(
              // height: 50,
              decoration: BoxDecoration(
                  borderRadius:
                  const BorderRadius.all(Radius.elliptical(10.0, 10.0)),
                  border: Border.all(width: 1.0, color: AppColors.base)),

              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: myController,
                  // focusNode: myController.f,
                  textInputAction: TextInputAction.done,
                  maxLines: 5,
                  style: const TextStyle(
                      fontSize: 15.0,
                      color: AppColors.black,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w500),
                  cursorColor: Colors.black,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration:   InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    filled: false,
                    fillColor: AppColors.grey,
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                        color: AppColors.base,
                        fontSize: 15,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w500),
                    hintText: StringsRef.acceptFlagComment,
                  ),
                  validator: (value) {
                    comment = value!;
                    return null;
                  },
                  // onFieldSubmitted: (v) {
                  // CommonMethods().showToast('Done');
                  // setState(() {
                  //   _keyboardVisible = true;
                  //   // pad = 8.0;
                  // });
                  //},
                ),
              ),
            ),
          ],
        ),
      ),
      Center(
        child: Visibility(
          visible: toggleAllClear,
          child: Column(
            children: [
              CommonUtils().setHeader('All Clear'),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset(
                  ImagePaths.thumbsup,
                  fit: BoxFit.fill,
                ),
              ),

            ],
          ),
        ),
      ),
space,
    Visibility(
       visible: toggleAllClear,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonUtils().setHeader('Pre-Check Reference:'),
        Container(
            decoration: BoxDecoration(
                color: AppColors.base,
                borderRadius: const BorderRadius.all(Radius.elliptical(
                  10,
                  10,
                )),
                border: Border.all(width: 1.0, color: AppColors.base)),
            child: Wrap(
              spacing: 0.0,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Center(
                    child: CommonUtils()
                        .setSubHeader(_controller.preCheckRefID.value),
                  ),
                ),
              ],
            )),

      ],
    )),

    space,
    Visibility(
      visible: toggleComment,
      child: Padding(
        padding: const EdgeInsets.only(top: 15.0,left: 40,right: 40),
        child: CommonUtils.baseButton(
            title: StringsRef.accept,
            ht: 45,
            txtSize: 12,
            fontType: AppConstants.fontSubTitle,
            function: () {
              if(comment.isEmpty){
                CommonMethods().showToast('Please add comment');
              }else{
                setState(() {
                  toggleComment = false;
                  toggleAllClear = true;
                });

                processPreCheckUpdation(comment);
                // if(toggleAllClear){
                //   processPreCheckUpdation(comment);
                // }else{
                //   setState(() {
                //     toggleComment = false;
                //     toggleAllClear = true;
                //   });
                // }
              }

            }),
      ),
    ),
  ],);
}
  _buildScanBody() {
    return Align(
      alignment: Alignment.center,
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        const SizedBox(
          height: 10,
        ),
        CommonUtils().setHeader(StringsRef.scanVehicle),
        const SizedBox(
          height: 10,
        ),
      InkWell(
          onTap: () async {
            _controller.scan();
           },
        child:Padding(
          padding: const EdgeInsets.only(left: 100.0,right: 100),
          child: Image(
            image: AssetImage(ImagePaths.scanprecheck),
            fit: BoxFit.fill,
           // height: 120,
           // width: 120//fill type of image inside aspectRatio
          ),
        ) ,
      ),


        (_controller.checkingFlag.value)
            ? CommonUtils().setProgessLoader(
            ProgressMessages.CheckingRedFlag, AppColors.base):Text('')

      ]),
    );
  }


  _buildVehDetailView() {

    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonUtils().setHeader(StringsRef.vehicleDetails),
                space,
                CommonUtils().setBaseContainerRounded(_licenseDataBuilder()),

                space,
                space,
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonUtils().setSubHeader('Time Stamp:${_controller.timeStamp}',
                          size: 15, color: AppColors.base),
                      (!_controller.isGPSOn.value) ? Column(children: [
                        CommonUtils().setSubHeader(
                            'Please enable location and refresh',
                            size: 15, color: AppColors.base),
                        CommonUtils.baseButton(
                            title: 'Refresh', function: () {
                          _controller.getCurrentLocation();
                        })
                      ],) : (_controller.isGPSSearching.value) ? Row(
                        children: [CommonUtils().setSubHeader(
                            'Locating you please wait...',
                            size: 15, color: AppColors.base), const SizedBox(
                          width: 20,), const SizedBox(width: 30,
                            height: 30,
                            child: CircularProgressIndicator())
                        ],) :
                      CommonUtils().setSubHeader('GPS Location:${_controller.gps.value}',
                          size: 15, color: AppColors.base),
                    ],
                  ),
                ),
                space,

                Obx(() {
                  return  (_controller.previewFlagView.value)
                          ?_buildFlagView():(_controller.previewProceedView.value)
                             ? _buildCommentView():Container();
                }),

              ],
            ),
          ),
        ),
        Obx(() {
          return CommonUtils().setProgressLayer(
              _controller.isRequesting.value, ProgressMessages.LoadReceive);
        }),
      ],
    );
  }

  _licenseDataBuilder() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _controller.objVehLicenseData.length,
      // +1 because you are showing one extra widget.
      itemBuilder: (BuildContext context, int index) {
        // if (index == 0) {
        String? title = _controller.objVehLicenseData[index].title;
        String? data = _controller.objVehLicenseData[index].data;
        final fulldata = '${title!}=${data!}';
        return Row(
          children: [
            CommonUtils()
                .setSubHeader(fulldata, color: AppColors.white, size: 17),
          ],
        );
      },
    );
  }
  _buildFlagView() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          CommonUtils().setHeader('Red Flag!'),
          CommonUtils().setBaseContainerRounded(CommonUtils().setSubHeader((_controller.flagComment.value.isEmpty)?'No Flag Found':_controller.flagComment.value)),
          space,
          space,
          Padding(
            padding:   EdgeInsets.only(top:8.0,left: 20,right: 20),
            child: Column(
              children: [
                CommonUtils.baseButton(
                    title: StringsRef.proceed,
                    ht: 45,
                    txtSize: 12,
                    fontType: AppConstants.fontSubTitle,
                    function: () {
                      if (!_controller.checkingFlag.value && !_controller.isGPSSearching.value ) {
                        if(_controller.gps.value.isEmpty){
                          CommonMethods().showToast('Please enable location');
                        }else{
                          _controller.previewFlagView.value = false;
                           _controller.previewProceedView.value = true;
                           if(_controller.flagComment.value.isEmpty){
                             setState(() {
                               toggleComment = false;
                               toggleAllClear = true;
                             });
                           }

                        }
 }
                    }),
                CommonUtils.baseButton(
                    title: StringsRef.truckRejected,
                    ht: 45,
                    txtSize: 12,
                    fontType: AppConstants.fontSubTitle,
                    function: () {
                      if (!_controller.checkingFlag.value && !_controller.isGPSSearching.value ) {
                        if(_controller.gps.value.isEmpty){
                          CommonMethods().showToast('Please enable location');
                        }else{
                          _controller.previewFlagView.value = false;
                          _controller.previewProceedView.value = true;
                          // if(_controller.flagComment.value.isEmpty){
                          //   setState(() {
                          //     toggleComment = false;
                          //     toggleAllClear = true;
                          //   });
                          // }

                        }
                      }
                    }),
              ],
            ),
          )

        ],);

    }
  void processPreCheckUpdation(String cmnt) async {
final lno = _controller.scanData?.licenseno;
final mloadID = await SqlLoadDB.instance.getLoadID();
if(mloadID.isNotEmpty){
  CommonMethods().showToast('Load id unavailable');
 // gotToHome();
}else{
  final obj = SharedModelPreCheck(refID: _controller.preCheckRefID.value, comment: cmnt, licenseNo: lno, loadID: mloadID);
  final status = await    SyncServer().syncPreCheckUpdation(obj);
 // gotToHome();
 // CommonMethods().showToast(cmnt);
}
  }
  void gotToHome(){
    widget.onEventNav(AppScreens.Home);
    // Future.delayed(const Duration(seconds: 1),(){
    //
    //   BaseApp().showAlertAllClear(context, function: (){
    //     widget.onEventNav(AppScreens.Home);
    //   });
    // });
  }

  // void testA() {
  //   Navigator.of(context).push(
  //
  //     MaterialPageRoute(
  //         builder: (context) => TempScanner(onEventNav: (String? scannedresult) {  },)
  //       //controller: camController),
  //     ),
  //   );
  // }
  //
  // void testB() {
  //   Navigator.of(context).push(
  //
  //     MaterialPageRoute(
  //         builder: (context) => CameraScreen()
  //       //controller: camController),
  //     ),
  //   );
  // }

}
