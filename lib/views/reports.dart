
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:truck_tracker/utils/app_colors.dart';
import 'package:truck_tracker/utils/common_methods.dart';

import '../controller/report_controller.dart';
import '../utils/app_screens.dart';
import '../utils/common_widgets.dart';
import '../utils/enumeration_mem.dart';
import '../utils/image_paths.dart';
import '../utils/stringsref.dart';

class Report extends StatefulWidget {
  final Function(AppScreens? moveTo) onEventNav;

  const Report({super.key, required this.onEventNav});

  @override
  State<Report> createState() => FlagState();
}

class FlagState extends State<Report> {
 final ReportController _controller = ReportController();
  final space = const SizedBox(
    height: 10,
  );
  final spaceH = const SizedBox(
    height: 15,
  );
  final myController = TextEditingController();
  double pad = 15.0;
  String preTxt = '';

  @override
  initState()   {
    super.initState();
    try {
      onint();
// _controller.comment.listen((txt) {
//  // myController.text = txt;
// });
      _controller.moveToHome.listen((onHome) {
        if (onHome) {
        //  CommonMethods().showToast('moveToHome');
          widget.onEventNav(AppScreens.Home);
        }
      });
      _controller.isRequesting.listen((requestingsense) {
     //   CommonMethods().showToast(" listeneing $requestingsense");
        // CommonMethods().showToast('Listen it $onHome');

        //  widget.onEventNav(AppScreens.Home);
      });
    } catch (e) {
      CommonMethods().showToast('Payload Error$e');
    }
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CommonUtils().setBaseView(),
        Obx(() {
          return (_controller.isRequesting.value)
              ? CommonUtils()
                  .setProgressLayer(true, ProgressMessages.Submitting)
              : (_controller.readyForPreview.value)
                  ? _buildPreview()
                  : Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: _buildFlagBody());
        })
      ],
    );

  }

  _buildFlagBody() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1 / 0.7,
            child: Container(
             // color: AppColors.white,
              child: Wrap(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                          child: CommonUtils().setHeader(
                              'SCAN EITHER OR ALL OF THE FOLLOWING',
                              color: AppColors.base,
                              size: 20,
                              align: TextAlign.center)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          InkWell(
                            onTap: (){
                              _controller.scan(0);
                            },
                            child:  _buildTonTrack(StringsRef.tontrack),

                          ),
                          InkWell(
                            onTap: (){
                              _controller.scan(1);
                            },
                            child:  _buildSeal(StringsRef.seal),

                          ),

                          InkWell(
                            onTap: (){
                              _controller.scan(2);
                            },
                            child:    _buildVehicle(StringsRef.vehicle),

                          ),


                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 3.0, right: 3.0, top: 3.0),
                        child: CommonUtils().setSubHeader(
                            'You are making a report please share as much info as you can',
                            size: 17,
                            align: TextAlign.center,
                            color: AppColors.base),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          AspectRatio(
            aspectRatio: 2 / 1,
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  children: [
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CommonUtils().setSubHeader(
                                'Optional-add and take image',
                                color: AppColors.base,
                                size: 15),
                            IconButton(
                              icon: const Icon(
                                Icons.add,
                              ),
                              iconSize: 30,
                              color: AppColors.base,
                              splashColor: Colors.purple,
                              onPressed: () {
                                _controller.pickImageFromCamera(
                                    function: (path) {
                                  // setState(() {
                                  //   arrayImagesLink.add(path);
                                  //   CommonMethods()
                                  //       .showToast('${arrayImagesLink.length}');
                                  // });
                                });
                                // setState(() {
                                //   // Deletedata(pass your id here);
                                //   //  arrayOfSeals.removeAt(index);
                                // });
                              },
                            ),
                          ],
                        ),
                        (_controller.imgInBytes.isEmpty)
                            ? Center(
                                child: CommonUtils().setSubHeader(
                                    StringsRef.noimageAdded,
                                    color: AppColors.base))
                            : SizedBox(
                                height: 80,
                                child: ListView.builder(
                                    shrinkWrap: false,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: _controller.imgInBytes.length,
                                    itemBuilder: (_, index) {
                                      return Row(
                                        children: [
                                          SizedBox(
                                            child: Stack(
                                              children: [
                                                Image.memory(_controller.imgInBytes[index]!,

                                            width: 80,
                                            height: 100,
                                            scale: 4,
                                            fit: BoxFit.fill,
                                          ),   Positioned(
                                                    right: 5.0,
                                                    top: 0.0,
                                                    child: InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          _controller.imgInBytes
                                                              .removeAt(index);
                                                        });
                                                      },
                                                      child: Container(
                                                        width: 20,
                                                        height: 20,
                                                        color: Colors.black12,
                                                        child: const Icon(
                                                          Icons.cancel,
                                                          size: 20,
                                                          color: AppColors.base,
                                                        ),
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          )
                                        ],
                                      );
                                    }),
                              ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
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
                focusNode: _controller.focusNode,
                textInputAction: TextInputAction.done,
                maxLines: 5,
                style: const TextStyle(
                    fontSize: 15.0,
                    color: AppColors.black,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500),
                cursorColor: Colors.black,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  filled: false,
                  fillColor: AppColors.grey,
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                      color: AppColors.base,
                      fontSize: 17,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w500),
                  hintText: "Text box - comment / details",
                ),
                validator: (value) {
                  _controller.comment.value = value!;
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
          SizedBox(
            height: 10,
          ),
          CommonUtils.baseButtonok(
              title: 'Submit',
              function: () {
                _controller.onTapSubmit();
              }),
        ],
      ),
    );
  }

  _buildTonTrack(String title) {
    return Column(
      children: [
        Container(
         width: 80,
           height: 80,
          // margin: const EdgeInsets.all( 20),
          color: AppColors.base,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              ImagePaths.tontrack,
            ),
          ),
        ),
        const SizedBox(
          height: 2,
        ),
        CommonUtils().setSubHeader(title,
            color: AppColors.base, fWeight: FontWeight.w500),
        Obx(() {
          return (!_controller.tontrackLoaded.value)
              ? const Text('')
              : const Icon(
                  Icons.check_box_rounded,
                  color: AppColors.base,
                );
        }),
      ],
    );
  }

  _buildSeal(String title) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          // margin: const EdgeInsets.all( 20),
          color: AppColors.base,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              ImagePaths.qrscan,
            ),
          ),
        ),
        const SizedBox(
          height: 2,
        ),
        CommonUtils().setSubHeader(title,
            color: AppColors.base, fWeight: FontWeight.w500),
        Obx(() {
          return !_controller.sealLoaded.value
              ? const Text('')
              : const Icon(
                  Icons.check_box_rounded,
                  color: AppColors.base,
                );
        }),
      ],
    );
  }

  _buildVehicle(String title) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          // margin: const EdgeInsets.all( 20),
          color: AppColors.base,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              ImagePaths.scanprecheck,
            ),
          ),
        ),
        const SizedBox(
          height: 2,
        ),
        CommonUtils().setSubHeader(title,
            color: AppColors.base, fWeight: FontWeight.w500),
        Obx(() {
          return !_controller.vehLicenLoaded.value
              ? const Text('')
              : const Icon(
                  Icons.check_box_rounded,
                  color: AppColors.base,
                );
        }),
      ],
    );
  }

  _buildPreview() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
              flex: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonUtils().setHeader(StringsRef.scannedDetails),
                  if (_controller.driverName.value.isEmpty || _controller.vehLicenseNo.value.isEmpty)
                     Text('')
                  else
                  CommonUtils().setBaseContainerRounded(    Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonUtils().setSubHeader(
                            'VEHICLE LICENSE NO: ${_controller.vehLicenseNo.value}',
                          ),

                          CommonUtils().setSubHeader(
                              'DRIVER: ${_controller.driverName.value}' ),
                        ]),
                  ),),
                  // Container(
                  //   width: double.infinity,
                  //     decoration: BoxDecoration(
                  //         color: AppColors.base,
                  //         borderRadius: const BorderRadius.all(
                  //             Radius.elliptical(10, 10.0)),
                  //         border:
                  //             Border.all(width: 1.0, color: AppColors.base)),
                  //     child: Padding(
                  //       padding: const EdgeInsets.all(10),
                  //       child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           CommonUtils().setSubHeader(
                  //               'VEHICLE LICENSE NO: ${_controller.vehLicenseNo}',
                  //               color: AppColors.white,
                  //               size: 17),
                  //           CommonUtils().setSubHeader('DRIVER: ${_controller.driverName}',
                  //               color: AppColors.white, size: 17),
                  //         ],
                  //       ),
                  //     )),
                ],
              )),
          if (_controller.imgInBytes.isNotEmpty)
            Expanded(
                flex: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, left: 0.2, bottom: 8.0),
                      child: CommonUtils().setHeader(
                        StringsRef.images,
                        color: AppColors.base,
                      ),
                    ),
                    SizedBox(
                      height: 80,
                      child: ListView.builder(
                          shrinkWrap: false,
                          scrollDirection: Axis.horizontal,
                          itemCount: _controller.imgInBytes.length,
                          itemBuilder: (_, index) {
                            return Row(
                              children: [
                                Image.memory(_controller.imgInBytes[index]!,
                                    width: 120,
                                    height: 100,
                                    scale: 4,
                                    fit: BoxFit.cover,
                                   ),
                                const SizedBox(
                                  width: 10,
                                )
                              ],
                            );
                          }),
                    ),
                  ],
                ))
          else
            const Text(''),
          Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 8.0, left: 0.2, bottom: 8.0),
                    child: CommonUtils().setHeader(StringsRef.reportDetail),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: AppColors.base,
                        borderRadius:
                            const BorderRadius.all(Radius.elliptical(10, 10.0)),
                        border: Border.all(width: 1.0, color: AppColors.base)),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child:   CommonUtils().setSubHeader(_controller.comment.value,
                            color: AppColors.white, size: 17),
                      ),
                    ),
                  ),
                ],
              )),
          Expanded(
            flex: 1,
            child: Center(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(top: 8.0, left: 0.2, bottom: 8.0),
                  child: CommonUtils().setHeader(StringsRef.reportRef),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: AppColors.base,
                      borderRadius:
                          const BorderRadius.all(Radius.elliptical(10, 10.0)),
                      border: Border.all(width: 1.0, color: AppColors.base)),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: CommonUtils().setSubHeader(_controller.reportRefID.value,
                          color: AppColors.white, size: 17),
                    ),
                  ),
                ),
              ],
            )),
          ),
          // Expanded(
          //     flex: 0,
          //     child: CommonUtils.baseButtonok(
          //         title: StringsRef.submit,
          //         function: ()  {
          //            _controller.processSubmit();
          //         }))
        ],
      ),
    );
  }

  void onint()async {
   _controller.reportRefID.value = await CommonMethods().getRefID(EnumReferenceType.flag);
   _controller.oninit();
  }

  // void testUID() async{
  //  final  rr = await CommonMethods().getRandomReference();
  //   setState(() {
  //     reportReference =  rr;
  //   });
  // }
}

/*
*
*  _buildFlagBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 0,
          child: Center(
            child: CommonUtils().setSubHeader(
                'SCAN EITHER OR ALL OF THE FOLLOWING',
                color: AppColors.base,
                size: 18,
                align: TextAlign.center,
                fWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          flex: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  _controller.scan(0);
                },
                child: _buildTonTrack(StringsRef.tontrack),
              ),
              InkWell(
                onTap: () {
                  _controller.scan(1);
                },
                child: _buildSeal(StringsRef.seal),
              ),
              InkWell(
                onTap: () {
                  _controller.scan(2);
                },
                child: _buildVehicle(StringsRef.vehicle),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 0,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: CommonUtils().setSubHeader(
                'You are making a report please share as much info as you can',
                size: 17,
                align: TextAlign.center,
                color: AppColors.base),
          ),
        ),
        Expanded(

          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: InkWell(
                onTap: () {
                  _controller.pickImageFromCamera();
                },
                child: Container(
                     height: 80,
                    //color: AppColors.base,
                    width: 80,
                  //  margin: const EdgeInsets.all( 0),
                    decoration: BoxDecoration(
                        color: AppColors.base,
                        borderRadius:
                            const BorderRadius.all(Radius.elliptical(10.0, 10.0)),
                        border: Border.all(width: 1.0, color: AppColors.base)),
                    child: (_controller.imagePath.value!.isEmpty)
                        ? Image.asset(
                            ImagePaths.camera,
                          )
                        : Image.file(File(_controller.imagePath.value!))),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Center(
            child: CommonUtils().setSubHeader('Optional-add and take image',
                size: 17, color: AppColors.base),
          ),
        ),
        Expanded(
          flex: 0,
          child: Container(
            // height: 50,
            decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.all(Radius.elliptical(10.0, 10.0)),
                border: Border.all(width: 1.0, color: AppColors.base)),

            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: myController,
                focusNode: _controller.focusNode,
                textInputAction: TextInputAction.done,
                maxLines: 5,
                style: const TextStyle(
                    fontSize: 15.0,
                    color: AppColors.black,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500),
                cursorColor: Colors.black,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  filled: false,
                  fillColor: AppColors.grey,
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                      color: AppColors.base,
                      fontSize: 17,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w500),
                  hintText: "Text box - comment / details",
                ),
                validator: (value) {
                  _controller.comment = value!;
                  return null;
                },
                onFieldSubmitted: (v) {
                  // CommonMethods().showToast('Done');
                  setState(() {
                    _keyboardVisible = true;
                    pad = 8.0;
                  });
                },
              ),
            ),
          ),
        ),
        Visibility(
          visible: _keyboardVisible,
          child: Expanded(
              flex: 0,
              child: CommonUtils.baseButtonok(
                  title: 'Submit',
                  function: () {
                    _controller.onTapSubmit();
                  })),
        ),
      ],
    );
  }

* */
