import 'package:get/get.dart';
import 'package:truck_tracker/controller/login_controller.dart';

import '../controller/home_controller.dart';

class HomeMenuBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => MainMenuHomeController());
  }

}