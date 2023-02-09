import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:truck_tracker/utils/app_colors.dart';
import 'package:truck_tracker/utils/common_widgets.dart';
import 'package:truck_tracker/utils/image_paths.dart';

import '../../controller/cntrl_addLoad.dart';
import '../../model/model_license_data.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_pops.dart';
import '../../utils/app_screens.dart';
import '../../utils/common_methods.dart';
import '../../utils/enumeration_mem.dart';
import '../../utils/services/services_files.dart';

class PageAddNewLoad extends StatefulWidget {
  final Function(AppScreens? moveTo) onEventNav;

  // final ModelLicenseData? _vehData;

  const PageAddNewLoad({super.key, required this.onEventNav});

  @override
  State<PageAddNewLoad> createState() => PageAddNewLoadState();
}

class PageAddNewLoadState extends State<PageAddNewLoad> {
  final ControllerAddLoad controller = ControllerAddLoad();
  var surName = '';
  var driverName = '';
  var driverNumber = '';
  var isdriverNameAdded = false;

  var grossWeight = 0.0;
  var tarWeight = 0.0;

  //DETAILSVIEW MEMEBERS
  List<String> arrayTrailers = [];

  //SEAL VIEW MEMBERES
  List<String> arrayOfSeals = [];
  List<String> documents = [];
  var listContHeight = 0.0;

  // bool isRequesting = false;
  File? scannedDocument;
  Future<PermissionStatus>? cameraPermissionFuture;

  bool showDocScan = false;

  final space = SizedBox(height: 10);
  var activeSealAddView = false;
  var activeDocAddView = false;

  // final objWidgets = WidgetAddNewLoad();

  @override
  void initState() {
    super.initState();
    controller.moveToHome.listen((toHome) {
      if (toHome) {
        widget.onEventNav(AppScreens.Home);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CommonUtils().setBaseView(),
        Obx(
          () {
            return (controller.previewLoadDetail.value)
                ? _buildLoadDetailView()
                : (controller.previewSealScan.value)
                    ? _buildScanSealView()
                    : _buildScanView(context);
          },
        ),
        Obx(() {
          return Visibility(
            visible: controller.isRequesting.value,
            child: Stack(
              children: [
                const Opacity(
                  opacity: 0.8,
                  child: ModalBarrier(dismissible: false, color: Colors.black),
                ),
                Center(
                  child: SizedBox(
                    height: double.infinity,
                    child: CommonUtils()
                        .setProgessLoader(ProgressMessages.Submitting),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  //::::::::::::::::::BUILDS UI:::::::::::::::::
  //:::::::::::::SCAN VIEW::::::::;
  _buildScanView(BuildContext context) {
    final space = const SizedBox(
      height: 10,
    );
    return Align(
      alignment: Alignment.center,
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        space,
        space,
        space,
        CommonUtils().setHeader('ADD NEW LOAD'),
        space,
        space,
        CommonUtils().setHeader('SCAN VEHICLE LICENSE'),
        space,
        space,
        InkWell(
          onTap: () {
            controller.scanVehicleLicense(function: (scannedData) {
              controller.analyseVehicleLicense(context, scannedData,
                  onCompletion: (vehData) {
                if (vehData != null) {
                  controller.previewLoadDetail.value = true;
                  controller.objVehLicenseData =
                      CommonMethods().getStructuredLicenseData(vehData);
                  //  widget.onEventNav(AppScreens.PgLoadVehcileDetail, vhData);
                }
              });
            });
          },
          child:   CommonUtils().getCommonLicenseScanButton()
        ),
      ]),
    );
  }

//:::::::::::::LOAD DETAIL VIEW
  _buildLoadDetailView() {
    final space = const SizedBox(height: 10);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            space,
            CommonUtils().setHeader('VEHICLE DETAILS'),
            space,
            Container(
                decoration: BoxDecoration(
                    color: AppColors.base,
                    borderRadius:
                        const BorderRadius.all(Radius.elliptical(10, 10.0)),
                    border: Border.all(width: 1.0, color: AppColors.base)),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: _buildDetailListView(),
                  ),
                )),
            const SizedBox(
              height: 30,
            ),
            (arrayTrailers.isEmpty)
                ? Center(child: CommonUtils().setHeader('', size: 13))
                : Container(
                    // width: double.infinity,
                    // height:    listContHeight  ,
                    decoration: BoxDecoration(
                        color: AppColors.base,
                        borderRadius:
                            const BorderRadius.all(Radius.elliptical(10, 10.0)),
                        border: Border.all(width: 1.0, color: AppColors.base)),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: _buildTrailerList(),
                      ),
                    )),
            space,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CommonUtils().setHeader('ADD TRAILERS '),
                InkWell(
                  onTap: () {
                    onTapAddTrailer();
                  },
                  child: SizedBox(
                      height: 30,
                      width: 30,
                      child: Image.asset(
                        ImagePaths.icnadd,
                        fit: BoxFit.scaleDown,
                      )),
                ),
                // const SizedBox(
                //   width: 40,
                // ),
                // Column(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     ClipOval(
                //       child: Material(
                //           color: AppColors.base,
                //           child: InkWell(
                //             onTap: () {
                //
                //             },
                //             child: const SizedBox(
                //               width: 30,
                //               height: 30,
                //               child: Icon(
                //                 Icons.add,
                //                 size: 25.0,
                //                 color: AppColors.white,
                //               ),
                //             ),
                //           )),
                //     ),
                //     CommonUtils().setHeader('ADD TRAILER', size: 10),
                //   ],
                // ),
              ],
            ),
            space,
            CommonUtils().setHeader('THE CURRENT DRIVER FOR THIS VEHICLE IS:'),
            space,
            _buildDriverDetailAddView(),
            space,
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: CommonUtils().setHeader(
                  "IF THIS IS CORRECT PLEASE CLICK PROCEED, IF IT'S NOT CLICK EDIT ABOVE",
                  size: 10,
                  align: TextAlign.center),
            ),
            space,
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 30, right: 30),
              child: CommonUtils.baseButton(
                  title: 'Submit',
                  ht: 50,
                  txtSize: 12,
                  fontType: AppConstants.fontSubTitle,
                  function: () {
                    //validate trailers
                    if (arrayTrailers.isEmpty) {
                      CommonMethods().showToast('Please Add Trailer');
                    } else if (!isdriverNameAdded) {
                      CommonMethods()
                          .showToast('Please Set driver name and number');
                    } else if (onDriverEditMode) {
                      CommonMethods().showToast('Please save driver details');
                    } else {

                      controller.previewLoadDetail.value = false;
                      controller.setRefID();
                      controller.previewSealScan.value = true;
                      activeSealAddView = true;
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }

//:::::::::::Detail List View
  _buildDetailListView() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: controller.objVehLicenseData.length,
      // +1 because you are showing one extra widget.
      itemBuilder: (BuildContext context, int index) {
        // if (index == 0) {
        String? title = controller.objVehLicenseData[index].title;
        String? data = controller.objVehLicenseData[index].data;
        final fulldata = '${title!} = ${data!}';
        return Row(
          children: [
            CommonUtils()
                .setSubHeader(fulldata, color: AppColors.white, size: 17),
          ],
        );
        //  }
        // int numberOfExtraWidget = 1; // here we have 1 ExtraWidget i.e Container.
        //  index = index - numberOfExtraWidget; // index of actual post.
      },
    );
  }

  _buildTrailerList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: arrayTrailers.length,
      // +1 because you are showing one extra widget.
      itemBuilder: (BuildContext context, int index) {
        // if (index == 0) {
        String? title = 'Trailer ${index + 1}: ${arrayTrailers[index]}';

        return Row(
          children: [
            CommonUtils().setSubHeader(title, color: AppColors.white, size: 17),
          ],
        );
        //  }
        // int numberOfExtraWidget = 1; // here we have 1 ExtraWidget i.e Container.
        //  index = index - numberOfExtraWidget; // index of actual post.
      },
    );
  }

  //:::::::::::::::::::SCAN SEAL View

  _buildScanSealView() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonUtils().setHeader('DETAILS'),
            space,
            CommonUtils().setBaseContainerRounded(    Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonUtils().setSubHeader(
                      'VEHICLE LICENSE NO:${controller.vehLicenseData.licenseno}',
                    ),
                    CommonUtils()
                        .setSubHeader('DRIVER: $surName $driverName'),
                  ]),
            ),),

            SizedBox(
              height: 20,
            ),
            space,
            //CommonUtils().setBaseContainerRounded(_buildSealList()),

            (arrayOfSeals.isEmpty)
                ? Text('')
                : Container(
                     decoration: BoxDecoration(
                        color: AppColors.base,
                        borderRadius:
                            const BorderRadius.all(Radius.elliptical(10, 10.0)),
                        border: Border.all(width: 1.0, color: AppColors.base)),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: _buildSealList(),
                    )),

            space,
            Visibility(visible: activeSealAddView, child: _buildSealAddView()),

            Visibility(visible: activeDocAddView, child: getDocView()),
            Obx(() {
              return (controller.activeEndView.value) ? getEndView() : Text('');
            })
            // Visibility(visible: controller.activeEndView.value, child: Text('Enddndn')),
          ],
        ),
      ),
    );
  }

  _buildSealList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: arrayOfSeals.length,
      // +1 because you are showing one extra widget.
      itemBuilder: (BuildContext context, int index) {
        // if (index == 0) {
        String? title = 'Seal ${index + 1}: ${arrayOfSeals[index]}';

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CommonUtils().setSubHeader(title, color: AppColors.white, size: 17),
          ],
        );
        //  }
        // int numberOfExtraWidget = 1; // here we have 1 ExtraWidget i.e Container.
        //  index = index - numberOfExtraWidget; // index of actual post.
      },
    );
  }

  _buildDocView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CommonUtils().setHeader('DOCUMENTS'),
        const SizedBox(
          width: 40,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipOval(
              child: Material(
                  color: AppColors.base,
                  child: InkWell(
                    onTap: () {
                      CommonMethods().showToast('work in progress');
                      openDocScanner();
                    },
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      // margin: const EdgeInsets.all( 20),
                      // color: AppColors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          color: AppColors.white,
                          ImagePaths.qrscan,
                        ),
                      ),
                    ),
                  )),
            ),
            CommonUtils().setHeader('Scan to add a doc', size: 10),
          ],
        ),
      ],
    );
  }

  var onDriverEditMode = true;

  _buildDriverDetailAddView() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          // height: 80,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.purple),
            color: (onDriverEditMode) ? AppColors.white : AppColors.base,
            boxShadow: [
              BoxShadow(
                  spreadRadius: 1, blurRadius: 1, color: Colors.grey.shade500),
            ],
          ),
          alignment: Alignment.center,
          child: _buildDriverDetailFields()),
    );
  }

  void openDocScanner() {
    setState(() {
      if (showDocScan) {
        showDocScan = false;
      } else {
        showDocScan = true;
      }
    });
  }

//::::::::::::::::TRAILER SCANNING:::::::::

  void scanToAddTrailers() async {
    final scanResult = await CommonMethods().scanQR();
    if (scanResult.isNotEmpty) {
      final licenseData = CommonMethods().getLicenseData(scanResult);
      if (licenseData != null) {
        setTrailer(licenseData.licenseno!);
      }
    } else {
      popUpEnterManually();
    }
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (context) => BarCodeScanner(onEventNav: (scanResult) {
    //       if (scanResult != null) {
    //         final licenseData = CommonMethods().getLicenseData(scanResult);
    //         if(licenseData != null){
    //           setTrailer(licenseData.licenseno!);
    //         }
    //       } else {
    //         popUpEnterManually();
    //       }
    //     }),
    //     //controller: camController),
    //   ),
    // );
  }

  void popUpEnterManually() {
    AppPops().showDialogWithManualEntryOfLicenseData(context, function: (obj) {
      try {
        final data = obj as ModelLicenseData;
        setTrailer(data.licenseno!);
      } catch (e) {
        AppPops().showAlertOfTypeErrorWithDismiss('Exception:$e');
      }
    });
  }

  void setTrailer(String licenseNo) {
    var addto = true;
    if (arrayTrailers.isNotEmpty) {
      if (arrayTrailers.contains(licenseNo)) {
        CommonMethods().showToast('Trailer already added.');
        addto = false;
      } else {
        addto = true;
      }
    }
    if (addto) {
      setState(() {
        arrayTrailers.add(licenseNo);
      });
    }
  }

  //::::DRIVER SCAN
  Future<void> setDriverName(BuildContext context,
      {required Function(String driversurname, String driverNm, String drivNo)
          onCompletion}) async {
    var _dvnaem = '';
    var dvnum = '';
    var dvsurname = '';
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: CommonUtils().setHeader('Set driver name and number.',
                color: AppColors.base),
            content: Wrap(
              children: [
                Column(
                  children: [
                    TextField(
                      onChanged: (value) {
                        dvsurname = value;
                      },
                      decoration: const InputDecoration(hintText: "Surname"),
                    ),
                    TextField(
                      onChanged: (value) {
                        _dvnaem = value;
                        // setState(() {
                        //   driverName = value;
                        // });
                      },
//glpat-Vyz_rJymgU-W8ReBysZy
                      ///   controller: _textFieldController,
                      decoration:
                          const InputDecoration(hintText: "Driver name"),
                    ),
                    TextField(
                      keyboardType: TextInputType.phone,
                      onChanged: (value) {
                        dvnum = value;
                        // setState(() {
                        //   driverName = value;
                        // });
                      },
//glpat-Vyz_rJymgU-W8ReBysZy
                      ///   controller: _textFieldController,
                      decoration:
                          const InputDecoration(hintText: "Driver number"),
                    ),
                  ],
                ),
              ],
            ),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.base,
                ),
                child: CommonUtils()
                    .setSubHeader('SAVE', size: 10, color: AppColors.white),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                    if (_dvnaem.isNotEmpty && dvnum.isNotEmpty) {
                      onCompletion(dvsurname, _dvnaem, dvnum);
                    }
                  });
                },
              ),
            ],
          );
        });
  }

  void onTapAddTrailer() {
    if (arrayTrailers.length < 3) {
      scanToAddTrailers();

      // _showTrailerBoxDialogue(context,
      //     onCompletion: (String? trailerdata) {
      //   //Fluttertoast.showToast(msg: trailerdata!);
      //   var addto = true;
      //   if (arrayTrailers.isNotEmpty) {
      //     if (arrayTrailers.contains(trailerdata)) {
      //       Fluttertoast.showToast(
      //           msg: 'Trailer already added.');
      //       addto = false;
      //     } else {
      //       addto = true;
      //     }
      //   }
      //   if (addto) {
      //     setState(() {
      //       arrayTrailers.add(trailerdata!);
      //     });
      //   }
      // });
    } else {
      CommonMethods().showToast('Trailer limit reached');
    }
  }

  void onTapFloppyIcon() {
    if (surName.isEmpty || driverName.isEmpty || driverNumber.isEmpty) {
      CommonMethods().showToast('Please set driver details.');
    } else {
      isdriverNameAdded = true;
      if (!onDriverEditMode) {
        setState(() {
          onDriverEditMode = true;
        });
      } else {
        setState(() {
          onDriverEditMode = false;
        });
      }
    }
  }

  _buildDriverDetailFields() {
    const hintStyle = TextStyle(
      color: AppColors.base,
      fontSize: 13,
      fontFamily: AppConstants.fontRegular,
      // fontStyle: FontStyle.normal,
      // fontWeight: FontWeight.w500,
    );
    var typeStyle = TextStyle(
        fontSize: 13.0,
        color: (onDriverEditMode) ? AppColors.base : AppColors.white,
        fontFamily: AppConstants.fontSubTitle,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w500);
    getInputDeco(String hintTitle) {
      return InputDecoration(
        isDense: true,
        // contentPadding:
        //  EdgeInsets.fromLTRB(10, 10, 10, 0),
        //  EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),

        filled: true,
        fillColor: (onDriverEditMode) ? AppColors.white : AppColors.base,
        hintStyle: hintStyle,
        hintText: hintTitle,
      );
    }

    //end
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: TextFormField(
                  enabled: onDriverEditMode,
                  textAlign: TextAlign.center,
                  textInputAction: TextInputAction.next,
                  style: typeStyle,
                  cursorColor: Colors.black,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: getInputDeco('Surname'),
                  validator: (value) {
                    surName = value!;
                    return;
                  },
                ),
              ),
              Expanded(
                flex: 2,
                child: TextFormField(
                  enabled: onDriverEditMode,
                  textAlign: TextAlign.center,
                  textInputAction: TextInputAction.next,
                  style: typeStyle,
                  cursorColor: Colors.black,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: getInputDeco('Name'),
                  validator: (value) {
                    driverName = value!;
                    return;
                  },
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                  enabled: onDriverEditMode,
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  textInputAction: TextInputAction.done,
                  style: typeStyle,
                  cursorColor: Colors.black,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: getInputDeco('ID number'),
                  validator: (value) {
                    driverNumber = value!;
                    return;
                  },
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Obx(() {
                return Padding(
                  padding: const EdgeInsets.only(top: 5.0, left: 5.0),
                  child: InkWell(
                      onTap: () {
                        controller.pickDriverCardImage();
                      },
                      child: Column(
                        children: [
                          CommonUtils().setBaseContainerRounded(
                              (controller.listenLicenseImage.value)
                                  ? Image.file(
                                      File(controller.licenseImg!.path),
                                      height: 30,
                                      width: 30)
                                  : Image.asset(
                                      ImagePaths.camera,
                                      height: 30,
                                      width: 30,
                                    ),
                              5.0,
                              2.0),
                          CommonUtils().setSubHeader('License',
                              size: 10, color: AppColors.base)
                        ],
                      )),
                );
              }),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: InkWell(
                    onTap: () {
                      onTapFloppyIcon();
                    },
                    child: CommonUtils().setBaseContainerRounded(
                        Image.asset(
                          (onDriverEditMode)
                              ? ImagePaths.icnfloppy
                              : ImagePaths.editdriver,
                          height: 40,
                          width: 30,
                        ),
                        5.0,
                        2.0)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void onTapSealScan() {
    if (arrayOfSeals.length < 10) {
      //arrayOfSeals.clear();
      controller.scanVehicleLicense(function: (scanResult) {
        var addto = true;
        if (arrayOfSeals.isNotEmpty) {
          if (arrayOfSeals.contains(scanResult)) {
            CommonMethods().showToast('Seal already scanned.');
            addto = false;
          } else {
            addto = true;
          }
        }
        if (addto) {
          setState(() {
            arrayOfSeals.add(scanResult!);
          });
        }
        //
      //  CommonMethods().showToast(scanResult.toString());
      });
    } else {
      CommonMethods().showToast('Scan limit reached');
    }
  }

  _buildSealAddView() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CommonUtils().setBaseContainerRounded(InkWell(
                  onTap: () {
                    onTapSealScan();
                  },
                  child: Image.asset(
                    ImagePaths.qrscan,
                    height: 80,
                    width: 80,
                  ))),
              SizedBox(
                width: 5,
              ),
              Expanded(
                  flex: 1,
                  child: CommonUtils().setHeader(
                      (arrayOfSeals.isEmpty)
                          ? 'Proceed to scan the seals'
                          : 'Add another seal',
                      align: TextAlign.center)),
            ],
          ),
        ),
        CommonUtils().setHeader(
            'Make sure all seals are scanned before pushing submit',
            align: TextAlign.center),
        space,
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: CommonUtils.baseButton(
              title: 'Submit',
              ht: 50,
              txtSize: 12,
              fontType: AppConstants.fontSubTitle,
              function: () {
                // setLoadRef();
                if (arrayOfSeals.isNotEmpty) {
                  setState(() {
                    activeSealAddView = false;
                    activeDocAddView = true;
                  });
                  // _controller.onSubmit(
                  //     driverName, driverNumber, arrayTrailers, arrayOfSeals);
                  //
                } else {
                  CommonMethods().showToast('Please scan seals to proceed');
                }
              }),
        )
      ],
    );
  }

  void onTapSubmitAtDocView() {
    activeDocAddView = false;
    controller.activeEndView.value = true;
  }

  /////////////////////////////////////DOCUMENT VIEW ::::::::::::::::::::::::::::::::
  _buildDocListView() {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,

        itemCount: documents.length,
        // +1 because you are showing one extra widget.
        itemBuilder: (BuildContext context, int index) {

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

  Widget getDocView() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonUtils().setHeader('Add document'),
          SizedBox(
            height: 10,
          ),
          (documents.isNotEmpty) ? _buildDocListView() : Text(''),

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CommonUtils().setBaseContainerRounded(InkWell(
                  onTap: () async {
                    final doc = await controller.onTapAddDocument();
                    if (doc != null) {
                      setState(() {
                        documents.add(doc);
                      });
                    }
                  },
                  child: Image.asset(
                    ImagePaths.qrscan,
                    height: 80,
                    width: 80,
                  ))),
              SizedBox(
                width: 5,
              ),
              Expanded(
                  flex: 1,
                  child: CommonUtils().setHeader(
                      (documents.isEmpty)
                          ? 'Proceed to scan POD'
                          : 'Add another doc',
                      align: TextAlign.start)),
            ],
          ),

          SizedBox(
            height: 30,
          ),
          CommonUtils().setHeader('Add details:'),
          SizedBox(
            height: 30,
          ),
          _getWeightForm(),
          SizedBox(
            height: 30,
          ),
          Obx(() {
            return CommonUtils()
                .setHeader('NET WEIGHT ${controller.netWeight.value}');
          }),

          // CommonUtils().setHeader('Net Weight:'),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: CommonUtils.baseButton(
                title: 'Submit',
                ht: 50,
                txtSize: 12,
                fontType: AppConstants.fontSubTitle,
                function: () async {
                  if (controller.netWeight.value == 0.0) {
                    CommonMethods().showToast('Please set weight');
                  } else {
                    setState(() {
                      activeDocAddView = false;
                    });
                    activeDocAddView = false;
                    controller.setLoadRef();
                    controller.activeEndView.value = true;
                    driverName = '$surName $driverName';
                    final licensePhoto = controller.licenseImg;
                    if (licensePhoto != null) {
                      var fName = CommonMethods().getTimeStamp();
                      fName = 'licenseImage' + fName;
                      final fileName = await FileServices().getFilePath(fName);
                      if (fileName != null) {
                        final getBytes = await licensePhoto.readAsBytes();
                        final isSaved =
                            await FileServices().saveFile(getBytes, fileName);
                        if (isSaved) {
                          controller.onSubmit(driverName, driverNumber,
                              arrayTrailers, arrayOfSeals, documents, fileName);
                        }
                      }
                    } else {
                      controller.onSubmit(driverName, driverNumber,
                          arrayTrailers, arrayOfSeals, documents, '');
                    }
                  }
                }),
          )
        ],
      ),
    );
  }

  _getWeightForm() {
    // final fieldTarCntrl = TextEditingController();
    // final fieldGrossCntrl = TextEditingController();
    final spaceBt = SizedBox(
      height: 20,
    );
    const hintStyle = TextStyle(
      color: AppColors.base,
      fontSize: 17,
      fontFamily: AppConstants.fontRegular,
      // fontStyle: FontStyle.normal,
      // fontWeight: FontWeight.w500,
    );
    var typeStyle = TextStyle(
        fontSize: 13.0,
        color: AppColors.base,
        fontFamily: AppConstants.fontSubTitle,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w500);
    getInputDeco(String hintTitle) {
      return InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          //  EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),

          filled: true,
          fillColor: AppColors.white,
          hintStyle: hintStyle,
          hintText: hintTitle,
          border: InputBorder.none);
    }

    return Column(
      children: [
        Container(
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
                    color: Colors.grey.shade500),
              ],
            ),
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                textAlign: TextAlign.start,

                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
                ],
                style: typeStyle,
                cursorColor: Colors.black,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: getInputDeco('TAR WEIGHT'),
                // onFieldSubmitted: (value){
                //   if(value.isNotEmpty){
                //     tarWeight = double.parse(value);
                //   }
                //   controller.calculateNetWeight(tarWeight, grossWeight);
                //   // final listData = [tarWeight,grossWeight];
                //   // contextEventFunction(EnumEventAddNewload.calculateNetWeight, listData);
                //
                // },
                onChanged: (value) {
                  try {
                    tarWeight = double.parse(value);
                  } catch (e) {
                    tarWeight = 0.0;
                  }
                  controller.calculateNetWeight(tarWeight, grossWeight);
                },
              ),
            )),
        spaceBt,
        Container(
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
                    color: Colors.grey.shade500),
              ],
            ),
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                  textAlign: TextAlign.start,
//controller: fieldGrossCntrl,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
                  ],
                  style: typeStyle,
                  cursorColor: Colors.black,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: getInputDeco('GROSS'),
                  // validator: (v){
                  //   return ;
                  // },
                  // onFieldSubmitted: (value){
                  //   if(value.isNotEmpty){
                  //     grossWeight = double.parse(value);
                  //   }
                  //   controller.calculateNetWeight(tarWeight, grossWeight);
                  // },
                  onChanged: (value) {
                    try {
                      grossWeight = double.parse(value);
                    } catch (e) {
                      grossWeight = 0.0;
                    }
                    controller.calculateNetWeight(tarWeight, grossWeight);
                  }),
            )),
        spaceBt,
        Container(
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
                    color: Colors.grey.shade500),
              ],
            ),
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                textAlign: TextAlign.start,
                textInputAction: TextInputAction.next,
                style: typeStyle,
                cursorColor: Colors.black,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: getInputDeco('DOC NUMBER'),

                onFieldSubmitted: (value) {
                  CommonMethods().showToast(value);
                },
              ),
            )),
      ],
    );
  }

//:::::::::::::::::END DOC VIEW:::::::::::::::
//::::::::::::::::::::::::::::::::::END VIEW OF THE SCREEN::::::::::::::::::
  getEndView() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CommonUtils()
                .setHeader('NET WEIGHT ${controller.netWeight.value}'),
          ),
          CommonUtils().setBaseContainerRounded(
              CommonUtils().setHeader('${controller.netWeight.value} kg',
                  color: AppColors.white, align: TextAlign.center),
              10.0,
              10.0,
              Alignment.center),
          space,
          CommonUtils().buildReferenceView(
              EnumReferenceType.addLoad, controller.loadRefID.value)
        ]);
  }
//::::::::::::::::::::::::::::UI END::::::::::::::::::::::::::::::::
}
