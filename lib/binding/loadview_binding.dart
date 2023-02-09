import 'package:get/get.dart';
import '../controller/load_view_controller.dart';

class LoadViewBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => LoadViewController());
  }

}