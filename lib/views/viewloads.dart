import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:truck_tracker/utils/common_methods.dart';
import 'package:velocity_x/velocity_x.dart';

import '../controller/load_view_controller.dart';
import '../utils/app_colors.dart';
import '../utils/app_screens.dart';
import '../utils/common_widgets.dart';
import '../utils/enumeration_mem.dart';
import '../utils/image_paths.dart';
// class NavigationDashBoard extends StatefulWidget {
//   const NavigationDashBoard({Key? key}) : super(key: key);
//
//   ///  VehicleLicense?  vehicleLicenseData;
//   @override
//   State<NavigationDashBoard> createState() => _NavigationDashBoardState();
// }
//
// class _NavigationDashBoardState extends State<NavigationDashBoard> {
class ViewLoad extends StatefulWidget {

  final Function(AppScreens? moveTo) onEventNav;

  ViewLoad({super.key, required this.onEventNav});
  @override
  State<ViewLoad> createState() => ViewLoadState();
}


class ViewLoadState extends State<ViewLoad>{
  final LoadViewController _controller = LoadViewController();
@override
  void initState() {

    super.initState();
    // _controller.loadData.listen((receivedData) {
    //   CommonMethods().showToast('Length ${receivedData.length}');
    // });
  }
  @override
  Widget build(BuildContext context) {
    //_controller.getLoadData();
  //  _controller.filldata();
    return Stack(
      children: [
        CommonUtils().setBaseView(),
        Image.asset(ImagePaths.logoBlue)
        // SingleChildScrollView(
        //     child: Obx(() {
        //       return  (_controller.isRequesting.value)?
        //       SizedBox( height:
        //       MediaQuery.of(context).size.height,
        //           width:double.infinity,
        //           child: CommonUtils().setProgessLoader(ProgressMessages.Loading,AppColors.base)):
        //       (_controller.loadData.isEmpty)?
        //
        //
        //       SizedBox( height: MediaQuery.of(context).size.height, width:double.infinity, child:Column(
        //         crossAxisAlignment: CrossAxisAlignment.center,
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           CommonUtils().setHeader('No Data'),
        //           SizedBox(height: 50,)
        //         ],
        //       )):
        //
        //       Padding(
        //         padding: const EdgeInsets.all(15.0),
        //         child: ClipRRect(
        //             borderRadius: BorderRadius.circular(10.0),child: Container(child: Container(   color: AppColors.base, child: Padding(
        //           padding: const EdgeInsets.all(15.0),
        //           child: dataTable(),
        //         )))),
        //       );
        //
        //     }) //,
        //   // ],
        // ),
      ],
    );


  }

  static var tblTxtStyle =
      const TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold);
  static var marginLeft = const SizedBox(
    width: 3,
  );

  static setTitle(String title) {
    return CommonUtils().setSubHeader(title,
        size:
            13); // title.text.semiBold.maxLines(2).align(TextAlign.start).size(10).make();
  }

  static setsubTitle(String title) {
    return title.text
        .align(TextAlign.start)
        .normal
        .maxLines(1)
        .size(10)
        .color(AppColors.white)
        .ellipsis
        .center
        .make();
  }

  Table dataTable() {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      border: TableBorder.all(
        color: AppColors.white,
      ),
      children: [
        TableRow(
            decoration: const BoxDecoration(color: AppColors.base),
            children: [
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: SizedBox(
                    height: 30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CommonUtils().setSubHeader('Load', size: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              ImagePaths.arrowup,
                              width: 15,
                              height: 15,
                            ),
                            Image.asset(
                              ImagePaths.arrowdown,
                              width: 15,
                              height: 15,
                            ),
                          ],
                        )
                      ],
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(child: setTitle('Last check')),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            ImagePaths.arrowup,
                            width: 15,
                            height: 15,
                          ),
                          Image.asset(
                            ImagePaths.arrowdown,
                            width: 15,
                            height: 15,
                          ),
                        ],
                      )
                    ]),
              ),
              Center(
                child: setTitle('Vehicle'),
              ),
              Center(
                child: setTitle('Status'),
              ),
            ]),

        for (int index = 0; index < _controller.loadData.length; index++)
          TableRow(
              decoration: (index % 2 == 0)
                  ? const BoxDecoration(color: AppColors.base)
                  : const BoxDecoration(color: AppColors.base),
              children: [
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: SizedBox(
                      height: 30,
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: setsubTitle(
                              _controller.loadData[index].load.toString()),
                        )),
                  ),
                ),
                setsubTitle(_controller.loadData[index].lastcheck.toString()),
                setsubTitle(_controller.loadData[index].vehicle.toString()),
                (_controller.loadData[index].status == 1)?
                const SizedBox(
                  height: 20,
                  width: 20,
                  child: Icon(
                    Icons.circle,
                    color: Colors.green,
                  ),
                ): const SizedBox(
                  height: 20,
                  width: 20,
                  child: Icon(
                    Icons.circle,
                    color: Colors.red,
                  ),
                )
              ])
      ],
    );
  }
}
