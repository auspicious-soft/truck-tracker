import 'package:get/get.dart';
class MainMenuHomeController extends GetxController {
  DateTime? currentBackPressTime;
  Rx<int> selectedIndex = 0.obs;

  Future<bool> onWillPop() {
    return Future.value(true);
    // DateTime now = DateTime.now();
    // if (currentBackPressTime == null ||
    //     now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
    //   currentBackPressTime = now;
    //   Get.snackbar(
    //     "",
    //     "Please Press Again To Exit App",
    //     icon: const Icon(Icons.person, color: Colors.white),
    //     snackPosition: SnackPosition.BOTTOM,
    //   );
    //   return Future.value(false);
    // }
    // return Future.value(true);
  }

  void onItemTapped(int index) {
    selectedIndex.value = index;
  }



}
