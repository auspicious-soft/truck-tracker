import 'package:get/get.dart';
import 'package:truck_tracker/controller/login_controller.dart';

class LoginBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
  }
}