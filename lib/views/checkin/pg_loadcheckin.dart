import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:truck_tracker/app_db/dbsql/loadcheckintable/sql_model_checkin_load.dart';
import 'package:truck_tracker/utils/app_colors.dart';
import 'package:truck_tracker/utils/common_widgets.dart';
import 'package:truck_tracker/utils/image_paths.dart';

import '../../apis/network_util.dart';
import '../../apis/syncserver.dart';
import '../../app_db/dbsql/loadcheckintable/sql_loaddb.dart';
import '../../app_db/dbsql/loadcheckintable/sql_model_storeload.dart';
import '../../controller/cntrl_checkin.dart';
import '../../utils/app_constants.dart';

import '../../utils/app_screens.dart';
import '../../utils/common_methods.dart';
import '../../utils/enumeration_mem.dart';
import '../../utils/stringsref.dart';
import '../../utils/util_scanner.dart';

class PageLoadCheckIN extends StatefulWidget {
  final Function(AppScreens? moveTo) onEventNav;

  bool flagMoveToReceive;

  @override
  State<PageLoadCheckIN> createState() => PageLoadCheckINState();

  PageLoadCheckIN(
      {super.key, required this.onEventNav, required this.flagMoveToReceive});
}

class PageLoadCheckINState extends State<PageLoadCheckIN> {
  final ControllerLoadCheckIN _controller = ControllerLoadCheckIN();
  final space = const SizedBox(
    height: 10,
  );
  String loadId = '';
  String driverName = '';
  bool isLoadApiRequesting = false;
  SqlModelStoreLoad? loadData;
  // late var isGPSOn = false;
  // bool isGPSSearching = false;
  // String gps = '';

  bool activateCheckInRefView = false;
  bool previewSaveContinueView = true;

  @override
  void initState() {
    oninit();
    super.initState();
  }

  void oninit() async  {
    loadData = await  SqlLoadDB.instance.getLoadData();
    _controller.setTimeStamp();
    // setState(() {
    //   timeStamp = CommonMethods().getTimeStamp();
    // });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: Colors.transparent,
      body: SafeArea(
          child: Stack(
        children: [
          CommonUtils().setBaseView(),
          Obx(() {
            return (_controller.previewVehDetailView.value)
                ? _buildVehicleDetailView()
                : (_controller.activateSealScanView.value)
                    ? _buildSealView()
                    : _buildScanBody(context);
          }),
        ],
      )),
    );
  }

  _buildScanBody(BuildContext context) {

    return Align(
      alignment: Alignment.center,
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        space,
        CommonUtils().setHeader(StringsRef.scanVehicleCapital),
        space,
        space,
        InkWell(
          onTap: () async {
            _controller.scanVehLicense();
          // final vehData = await   UtilScanner().scanVehicleLicenseCode();
          // if (vehData != null) {
          //   checkIsGPSOn();
          //   _controller.verifyLicenseAndProcess(context, vehData);
          // }
          },
          child: CommonUtils().getCommonLicenseScanButton(),
        ),
      ]),
    );
  }

  _buildVehicleDetailView() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonUtils().setHeader(StringsRef.vehicleDetailsCapital),//'VEHICLE DETAILS'
            space,
            CommonUtils().setBaseContainerRounded(Padding(
              padding: const EdgeInsets.all(10),
              child: _licenseDataBuilder(),
            )),

            space,
            space,
            _buildTimeStampAndGPSView(),
            space,
            space,
            Obx(() {
              return (_controller.previewExitView.value)
                  ? _buildExitView()
                  : (!_controller.previewTonTrackView.value)
                      ? Text('')
                      : _buildTonTrackView();
            }),
            Visibility(
                visible: previewSaveContinueView,
                child: _buildSaveContinueView()),
            Visibility(
                visible: activateCheckInRefView,
                child: _buildCheckInReference())
          ],
        ),
      ),
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
        final fulldata = '${title!} = ${data!}';
        return Row(
          children: [
            CommonUtils()
                .setSubHeader(fulldata, color: AppColors.white, size: 17),
          ],
        );
      },
    );
  }

  _licenseTonTrackDataBuilder() {
    return ListView.builder(
      dragStartBehavior: DragStartBehavior.start,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _controller.objTonTrackData.length,
      // +1 because you are showing one extra widget.
      itemBuilder: (BuildContext context, int index) {
        // if (index == 0) {
        String? title = _controller.objTonTrackData[index].title;
        String? data = _controller.objTonTrackData[index].data;
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

  _buildSaveContinueView() {
    return Column(
      children: [
        CommonUtils().setSubHeader(StringsRef.clickthisifchekpt,
            size: 15, align: TextAlign.center, color: AppColors.base),
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              CommonUtils.baseButton(
                  title: 'SAVE',
                  ht: 45,
                  txtSize: 12,
                  fontType: AppConstants.fontSubTitle,
                  function: () async {
                    if (_controller.gps.value.isEmpty) {
                     _controller.checkIsGPSOn();
                    } else {
                      await   _controller.setCheckInRefID();
                      if (widget.flagMoveToReceive) {
                        setState(() {
                          previewSaveContinueView = false;
                        });
                        _controller.previewVehDetailView.value = false;
                        _controller.setSealViewData();
                        _controller.activateSealScanView.value = true;

                      } else {
                        setState(() {
                          previewSaveContinueView = false;
                          activateCheckInRefView = true;
                        });
                        _controller.addNewCheckINInSQL('',true);
                      }

                    }
                  }),
              SizedBox(
                height: 10,
              ),
              CommonUtils.baseButton(
                  title: 'CONTINUE',
                  ht: 45,
                  txtSize: 12,
                  fontType: AppConstants.fontSubTitle,
                  function: () {

                    _controller.continueLoad();
                  }),
              SizedBox(
                height: 10,
              ),
              CommonUtils.baseButton(
                  title: 'TRUCK EXIT',
                  ht: 45,
                  txtSize: 12,
                  fontType: AppConstants.fontSubTitle,
                  function: () {
                    setState(() {
                      previewSaveContinueView = false;
                      activateCheckInRefView = false;
                      _controller.previewExitView.value = true;
                    });

                    //  widget.onEventNav(AppScreens.Home, null);
                  }),
            ],
          ),
        ),
      ],
    );
  }

  _buildCheckInReference() {
    return CommonUtils().buildReferenceView(
        EnumReferenceType.checkIn, _controller.checkInRefID.value);
  }
  List<String> documents = [];
  bool showDocSave = false;
  _buildDocListView() {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,

        itemCount: documents.length,
        // +1 because you are showing one extra widget.
        itemBuilder: (BuildContext context, int index) {
          // if (index == 0) {
          //   String? title = 'Seal ${index + 1}: ${arrayOfSeals[index]}';

          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right:1.0,top: 8,bottom: 8.0),
                child: Image.asset(ImagePaths.doc,height: 80,width: 80,),
              )

            ],
          );
          //  }
          // int numberOfExtraWidget = 1; // here we have 1 ExtraWidget i.e Container.
          //  index = index - numberOfExtraWidget; // index of actual post.
        },
      ),
    );
  }
  _buildExitView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonUtils().setSubHeader(
            StringsRef.thisTruckHasBeenCheckedIn,
            color: AppColors.base,
            align: TextAlign.center),
        SizedBox(
          height: 10,
        ),
        CommonUtils().setHeader('Add document'),

        (documents.isNotEmpty)?_buildDocListView():Text(''),

        Row(

          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            CommonUtils().setBaseContainerRounded(InkWell(  onTap:() async {
              final doc = await    _controller.onTapAddDocument();
              if(doc != null){
                setState(() {
                  showDocSave = true;
                  documents.add(doc);
                });

              }
            },
                child: Image.asset(ImagePaths.qrscan,height: 60,width: 60,))),
            SizedBox(
              width: 5,
            ),

            Expanded(flex: 1, child: CommonUtils().setHeader((documents.isEmpty)? 'Proceed to scan POD':'Add another doc',align: TextAlign.start)),


          ],
        ),
        //::::::::::TEMPORARY DISABLED
        // Padding(
        //   padding: const EdgeInsets.only(left: 30.0,right: 30.0),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.start,
        //     children: [
        //
        //       CommonUtils().setBaseContainerRounded(InkWell(  onTap:(){
        //         _controller.scanTonTrack(function: (scannedData) {
        //           _controller.analyseTonTrackData(scannedData,
        //               onCompletion: (vhData) {
        //                 //
        //                 //    if (vhData != null) {
        //                 //
        //                 //    _controller.previewTonTrackView.value = true;
        //                 //    }
        //               });
        //         });
        //
        //       },
        //           child: Padding(
        //             padding: const EdgeInsets.all(8.0),
        //             child: Image.asset(ImagePaths.qrscan,height: 80,width: 80,),
        //           )),0.0,0.0),
        //       SizedBox(
        //         width: 5,
        //       ),
        //
        //       Expanded(flex: 1, child: CommonUtils().setHeader(  'SCAN TON TRACK',align: TextAlign.start)),
        //
        //
        //     ],
        //   ),
        // ),
        //::::::::::TEMPORARY DISABLED END
        SizedBox(
          height: 20,
        ),
Visibility(
    visible: showDocSave,
  child:   Padding(
    padding: const EdgeInsets.all(20.0),
    child: CommonUtils.baseButton(title: 'Submit', function: (){
_controller.setUpTontrackView();
      setState(() {
        _controller.previewExitView.value = false;
        _controller.previewTonTrackView.value = true;
      });

        }),
  ),
)
      ],
    );
  }

  _buildTonTrackView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //pending disabled
        // Container(
        //   decoration: BoxDecoration(
        //       color: AppColors.base,
        //       borderRadius: const BorderRadius.all(Radius.elliptical(10, 10.0)),
        //       border: Border.all(width: 1.0, color: AppColors.base)),
        //   child: Center(
        //     child: Padding(
        //       padding: const EdgeInsets.all(10),
        //       child: _licenseTonTrackDataBuilder(),
        //     ),
        //   ),
        // ),

        CommonUtils().buildReferenceView(EnumReferenceType.exit, _controller.exitRefID.value),

        SizedBox(
          height: 10,
        ),
        CommonUtils.baseButton(
            title: 'CONFIRM EXIT',
            ht: 45,
            txtSize: 12,
            fontType: AppConstants.fontSubTitle,
            function: () {
              CommonMethods().showToast('Work in progress');
              // widget.onEventNav(AppScreens.Home,null);
            }),
      ],
    );
  }

//::::::::::::::::::::::::::SEAL VIEW PAGE::::::::::::::::::::::::::::::
  List<String> arrayOfSeals = [];
  var listContHeight = 0.0;
  bool isRequesting = false;
  bool previewRejection = false;

  String? imagePath;

  _buildSealView() {
    final space = SizedBox(height: 10);

    return SafeArea(
        child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            if(_controller.sealDriverName.value.isEmpty)
              Text('')
            else...{
        CommonUtils().setHeader('VEHICLE DETAILS'),
        space,
        CommonUtils().setBaseContainerRounded(    Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        CommonUtils().setSubHeader(
        'VEHICLE LICENSE NO: ${_controller.sealVehLicenseNumber}',
        ),

        CommonUtils().setSubHeader(
        'DRIVER: ${_controller.sealDriverName}' ),
        ]),
        ),),
        SizedBox(
        height: 20,
        )
            },


            Obx(() {
              return (_controller.sealPagePreviewOnCheckInTap.value)
                  ? _buildOnTapCheckINView():(_controller.sealPagePreviewOnRejectTap.value)?
              
              _buildRejectionView()
                   : _buildCheckINView();
            }),
           
          ],
        ),
      ),
    ));
  }
String rejectionComment = '';
  _buildRejectionView() {
    return Obx(() {
      return (_controller.rejectionEditor.value)
          ? Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonUtils().setHeader('REASON FOR REJECTION'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              // height: 80,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.purple),
                  color: AppColors.white,
                  boxShadow: [
                    BoxShadow(
                        spreadRadius: 1,
                        blurRadius: 1,
                        color: Colors.grey.shade500)
                    ,
                  ],
                ),
                alignment: Alignment.center,
                child:  _buildRejectionPageRejectionView(),

            ),
          ),

          
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CommonUtils().setBaseContainerRounded(
                    InkWell(
                        onTap: () {
                          _controller.chooseRejectionPhoto();
                          
                        },
                        child:  Obx(() {
                          return (_controller.listenRejectionImage.value)
                              ?Image.file(_controller.imgOfRejection!, height: 80,
                            width: 80,): Image.asset(
                            ImagePaths.camera,
                            height: 80,
                            width: 80,
                          )  ;
                        }),
                      
                     
            
            ),
                    5,
                    2),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                    flex: 1,
                    child: CommonUtils().setHeader(
                        'CLICK TO ADD PHOTO'
                        ,
                        align: TextAlign.center)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: CommonUtils.baseButton(
                title: 'REJECT',
                ht: 50,
                txtSize: 12,
                fontType: AppConstants.fontSubTitle,
                function: () {
                 // print(_controller.imgOfRejection );
                  if(rejectionComment.isNotEmpty && _controller.imgOfRejection != null){
                    _controller.setRejectionView();
                    _controller.sealPagePreviewOnCheckInTap.value = false;
                    _controller.rejectionEditor.value = false;
                    _controller.processLoadRejection(rejectionComment);
                  }else{
                    CommonMethods().showToast('Please add reason and choose photo');
                  }
                  // openRejectionPop(context,
                  //     onCompletion: (mReason, photoClicked) {
                  //       setState((){
                  //         reason = mReason;
                  //         previewRejection = true;
                  //       });
                  //       _controller.setUpRejectionView();
                  //
                  //       // final licenseNo =
                  //       //     widget._receivedData?.vehLicenData.license_no;
                  //       // if (licenseNo != null) {
                  //       //   if (photoClicked == false) {
                  //       //     _controller.submitReasonWithoutPhoto(
                  //       //         licenseNo, mReason);
                  //       //   } else {
                  //       //     _controller.submitReasonWithPhoto(
                  //       //         licenseNo, reason);
                  //       //   }
                  //       // } else {
                  //       //   CommonMethods()
                  //       //       .showToast('License id not available');
                  //       // }
                  //
                  //       //
                  //     });
                }),
          ),

        ],) : Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonUtils().setHeader('REASON FOR REJECTION'),
          CommonUtils().setBaseContainerRounded(CommonUtils().setSubHeader(rejectionComment),10,20,Alignment.center),
          CommonUtils().buildReferenceView(EnumReferenceType.rejection, _controller.rejectionRefID.value),


        ],);
    });}


_buildRejectionPageRejectionView(){

    const hintStyle = TextStyle(
      color: AppColors.base,
      fontSize: 13,
      fontFamily: AppConstants.fontRegular,
      // fontStyle: FontStyle.normal,
      // fontWeight: FontWeight.w500,
    );
    var  typeStyle = TextStyle(
        fontSize: 17.0,
        color:  AppColors.base ,
        fontFamily: AppConstants.fontSubTitle,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w500);
    getInputDeco(String hintTitle){
      return InputDecoration(
        isDense: true,
        // contentPadding:
        //  EdgeInsets.fromLTRB(10, 10, 10, 0),
        //  EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),

        filled: true,
        fillColor: AppColors.white ,
        hintStyle: hintStyle,
        hintText: hintTitle,
border: InputBorder.none

      );
    }

    //end
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        Row(children: [

          Expanded(
            flex: 1,
            child: TextFormField(
              maxLines: 3,
            //  enabled: onDriverEditMode,
              textAlign: TextAlign.start,
              textInputAction: TextInputAction.done,
              style: typeStyle,
              cursorColor: Colors.black,
              autovalidateMode:
              AutovalidateMode.onUserInteraction,
              decoration:  getInputDeco('') ,
              validator: (value){
                rejectionComment = value!;
                return;
              },
            ),
          ),


        ],),


      ],),
    );

}
  _buildCheckINView() {
    return Wrap(
      children: [
        (arrayOfSeals.isEmpty) ? Text('') : CommonUtils().setHeader('SEALS'),
        _buildTimeStampAndGPSView(),
        space,
        (arrayOfSeals.isEmpty)
            ? Center(child: CommonUtils().setHeader('', size: 13))
            : Container(
                // width: double.infinity,
                // height: _buildSealList().,
                decoration: BoxDecoration(
                    color: AppColors.base,
                    borderRadius:
                        const BorderRadius.all(Radius.elliptical(10, 10.0)),
                    border: Border.all(width: 1.0, color: AppColors.base)),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: _buildSealList(),
                )),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 40, left: 20.0, bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CommonUtils().setBaseContainerRounded(
                  InkWell(
                      onTap: () {
                        onTapSealScan();
                      },
                      child: Image.asset(
                        ImagePaths.qrscan,
                        height: 80,
                        width: 80,
                      )),
                  0,
                  5),
              SizedBox(
                width: 5,
              ),
              Expanded(
                  flex: 1,
                  child: CommonUtils().setHeader(
                      (arrayOfSeals.isEmpty)
                          ? 'Proceed to scan the seals'
                          : 'Scan another seal',
                      align: TextAlign.center)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              CommonUtils().setSubHeader(
                  'There is a problem in seal 4 click check-in to accept and continue or reject',
                  size: 15,
                  color: AppColors.base,
                  align: TextAlign.center),
              space,
              space,
              CommonUtils.baseButton(
                  title: 'CHECK IN',
                  ht: 50,
                  txtSize: 12,
                  fontType: AppConstants.fontSubTitle,
                  function: () async {
                    if (arrayOfSeals.isNotEmpty) {
                     await _controller.setCheckInRefID();
                      _controller.sealPagePreviewOnCheckInTap.value = true;
                     _controller.processCheckIn(arrayOfSeals);
                    } else {
                      Fluttertoast.showToast(
                          msg: 'Please scan seals to proceed');
                    }
                  }),
              space,
              space,
              CommonUtils.baseButton(
                  title: 'REJECT',
                  ht: 50,
                  txtSize: 12,
                  fontType: AppConstants.fontSubTitle,
                  function: () {
                    _controller.sealPagePreviewOnCheckInTap.value = false;
                    _controller.sealPagePreviewOnRejectTap.value = true;

                  })
            ],
          ),
        )
      ],
    );
  }

  _buildOnTapCheckINView() {
    return Wrap(
      children: [
        CommonUtils().setHeader('SEALS'),
        space,
        Container(
            // width: double.infinity,
            // height: _buildSealList().,
            decoration: BoxDecoration(
                color: AppColors.base,
                borderRadius:
                    const BorderRadius.all(Radius.elliptical(10, 10.0)),
                border: Border.all(width: 1.0, color: AppColors.base)),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: _buildSealList(),
            )),
        SizedBox(
          height: 20,
        ),
        CommonUtils().buildReferenceView(
            EnumReferenceType.checkIn, _controller.checkInRefID.value)
      ],
    );

    // space,
    //
    // CommonUtils().buildReferenceView(EnumReferenceType.checkIn, _controller.checkInRefID.value),
  }

  _buildSealList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: arrayOfSeals.length,
      // +1 because you are showing one extra widget.
      itemBuilder: (BuildContext context, int index) {
        // if (index == 0) {
        String? title = 'Seal ${index + 1}: ${arrayOfSeals[index]}';
        final item = arrayOfSeals[index];
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CommonUtils().setSubHeader(title, color: AppColors.white, size: 17),
            IconButton(
              icon: Icon(
                Icons.cancel_rounded,
              ),
              iconSize: 30,
              color: Colors.white,
              splashColor: Colors.purple,
              onPressed: () {
//removeItem////////////
                // Fluttertoast.showToast(msg: '$index');
                ////// arrayOfSeals.removeAt(index);
                setState(() {
                  // Deletedata(pass your id here);
                  arrayOfSeals.removeAt(index);
                });
              },
            ),
          ],
        );

        //  }
        // int numberOfExtraWidget = 1; // here we have 1 ExtraWidget i.e Container.
        //  index = index - numberOfExtraWidget; // index of actual post.
      },
    );
  }

  Future<void> onTapSealScan() async {
    if (arrayOfSeals.length < 10) {
      //arrayOfSeals.clear();
      final scanResult = await UtilScanner().scanBarCode();
      var available = true;
      if (arrayOfSeals.isNotEmpty) {
        if (arrayOfSeals.contains(scanResult)) {
          Fluttertoast.showToast(msg: 'Seal already scanned.');
          available = false;
        } else {
          available = true;
        }
      }
      if (available) {
        setState(() {
          arrayOfSeals.add(scanResult!);
        });
        //

      } else {
        Fluttertoast.showToast(msg: 'Scan limit reached');
      }
    }
  }

  _buildTimeStampAndGPSView() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonUtils().setSubHeader('Time Stamp:${_controller.timeStamp.value}',
              size: 15, color: AppColors.base),
          (!_controller.isGPSOn.value)
              ? Column(
                  children: [
                    CommonUtils().setSubHeader(
                        'Please enable location and refresh',
                        size: 15,
                        color: AppColors.base),
                    CommonUtils.baseButton(
                        title: 'Refresh',
                        function: () {
                          _controller.checkIsGPSOn();
                        })
                  ],
                )
              : (_controller.isGPSSearching.value)
                  ? Row(
                      children: [
                        CommonUtils().setSubHeader(
                            'Locating you please wait...',
                            size: 15,
                            color: AppColors.base),
                        const SizedBox(
                          width: 20,
                        ),
                        const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(color: AppColors.base,strokeWidth: 2.0,))
                      ],
                    )
                  : CommonUtils().setSubHeader('GPS Location:${_controller.gps.value}',
                      size: 15, color: AppColors.base),
        ],
      ),
    );
  }



  void synchroniseCheckIN(SqlModelCheckIn checkInBody) async {
    // final status = await SyncServer().syncCheckIN(checkInBody);
    // if (status == EnumServerSyncStatus.success) {
    //   SqlLoadDB.instance.cancelLoad();
    //   CommonMethods().showToast('Data sync successfully');
    // } else {
    //   SqlLoadDB.instance.activateOfflineCheckIn();
    // }

  }

  void onTapRejectionSave() {
  _controller.rejectionEditor.value = true;
  }

  

}
