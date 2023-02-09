import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:truck_tracker/utils/common_widgets.dart';
import '../../controller/cntrl_truckexit.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_screens.dart';
import '../../utils/common_methods.dart';
import '../../utils/image_paths.dart';
import '../../utils/stringsref.dart';

class TruckExit extends StatefulWidget {
 // final Function(AppScreens? moveTo ) onEventNav;

   //TruckExit({super.key, required this.onEventNav});
  //createState(): When the Framework is instructed to build a StatefulWidget, it immediately calls createState()

  @override
  State<TruckExit> createState() => _TruckExitState();
}

class _TruckExitState extends State<TruckExit> {
  final TruckExitController _controller = TruckExitController();

  @override
  Widget build(BuildContext context) {
    //
    return Stack(
      children: [
        CommonUtils().setBaseView(),
        Obx(() {
          return (_controller.previewExitReference.value)
              ?_buildTonTrackView()
              : _buildExitView();
        }),
      ],
    );
  }

  _buildDetailListView() {
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

  _buildDocListView() {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,

        itemCount: _controller.documents.length,
        // +1 because you are showing one extra widget.
        itemBuilder: (BuildContext context, int index) {
          // if (index == 0) {
          //   String? title = 'Seal ${index + 1}: ${arrayOfSeals[index]}';

          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 1.0, top: 8, bottom: 8.0),
                child: Image.asset(
                  ImagePaths.doc,
                  height: 80,
                  width: 80,
                ),
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CommonUtils().setHeader('SCAN VEHICLE LICENSE'),
                    SizedBox(
                      height: 10,
                    ),
                    Obx(() {
                      return (_controller.previewVehLicenseData.value)
                          ? CommonUtils()
                              .setBaseContainerRounded(_buildDetailListView())
                          : InkWell(
                              onTap: () {
                                _controller.scanVehicleLicense();
                              },
                              child: Container(
                                width: 80,
                                height: 80,
                                // margin: const EdgeInsets.all( 20),
                                color: AppColors.base,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Image.asset(
                                    ImagePaths.qrscan,
                                  ),
                                ),
                              ),
                            );
                    }),
                  ]),
            ),
            SizedBox(
              height: 10,
            ),
            CommonUtils().setSubHeader(StringsRef.thisTruckHasBeenCheckedIn,
                color: AppColors.base, align: TextAlign.center),
            SizedBox(
              height: 20,
            ),

            CommonUtils().setHeader('Add document'),
            Obx(() {
              return (_controller.docAdded.value)
                  ? _buildDocListView()
                  : Text('');
            }),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CommonUtils().setBaseContainerRounded(InkWell(
                      onTap: () async {
                        _controller.onTapAddDocument();
                      },
                      child: Image.asset(
                        ImagePaths.qrscan,
                        height: 60,
                        width: 60,
                      ))),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                      flex: 1,
                      child: CommonUtils().setHeader(
                          (!_controller.docAdded.value)
                              ? 'Proceed to scan POD'
                              : 'Add another doc',
                          align: TextAlign.start)),
                ],
              ),
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
            Obx(() {
              return (_controller.docAdded.value)
                  ? Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: CommonUtils.baseButton(
                          title: 'Submit',
                          function: () {
                            if (_controller.objVehLicenseData.length == 0) {
                              CommonMethods()
                                  .showToast('Please scan vehicle license');
                            } else {
                              _controller.setUpTontrackView();
                            }

                            // setState(() {
                            //   _controller.previewExitView.value = false;
                            //   _controller.previewTonTrackView.value = true;
                            // });
                          }),
                    )
                  : Text('');
            }),
          ],
        ),
      ),
    );
  }

  _buildTonTrackView() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonUtils().setBaseContainerRounded(_buildDetailListView()),

          SizedBox(
            height: 10,
          ),
          // Container(
          //   decoration: BoxDecoration(
          //       color: AppColors.base,
          //       borderRadius: const BorderRadius.all(
          //           Radius.elliptical(10, 10.0)),
          //       border:
          //       Border.all(width: 1.0, color: AppColors.base)),
          //   child: Center(
          //     child: Padding(
          //       padding: const EdgeInsets.all(10),
          //       child: _licenseTonTrackDataBuilder(),
          //     ),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CommonUtils()
                .setHeader('EXIT-REFERENCE', color: AppColors.base),
          ),
          CommonUtils().setBaseContainerRounded(Center(
              child: CommonUtils().setSubHeader(_controller.exitRefID.value))),
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
                // widget.onEventNav(AppScreens.Home, null);
              }),
        ],
      ),
    );
  }

  // _licenseTonTrackDataBuilder() {
  //   return ListView.builder(
  //     shrinkWrap: true,
  //     physics: const NeverScrollableScrollPhysics(),
  //     itemCount: _controller.objTonTrackData.length,
  //     // +1 because you are showing one extra widget.
  //     itemBuilder: (BuildContext context, int index) {
  //       // if (index == 0) {
  //       String? title = _controller.objTonTrackData[index].title;
  //       String? data = _controller.objTonTrackData[index].data;
  //       final fulldata = '${title!}=${data!}';
  //       return Row(
  //         children: [
  //           CommonUtils()
  //               .setSubHeader(fulldata, color: AppColors.white, size: 17),
  //         ],
  //       );
  //     },
  //   );
  // }


}
