import 'package:get/get.dart';

import '../controller/navdashboard_controller.dart';

class NavBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => NavigationDashBoardController());
  }

}