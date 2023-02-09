import 'package:get/get_navigation/src/routes/get_route.dart';

import 'package:truck_tracker/views/login.dart';
import 'package:truck_tracker/views/navigation_dash_board.dart';

import '../binding/homemenu_binding.dart';
import '../binding/login_binding.dart';
import '../binding/nav_binding.dart';
import '../binding/splash_binding.dart';
import '../utils/app_screens.dart';

import '../views/navpages/home.dart';
import '../views/splash_screen.dart';

import 'app_routes.dart';

class AppPages {
  static const homeRoute = AppRoutes.splash;

  static final routes = [
    GetPage(
        name: AppRoutes.splash,
        page: () => SplashScreen(),
        binding: SplashScreenBinding()),
    GetPage(
        name: AppRoutes.login, page: () => Login(), binding: LoginBinding()),

    GetPage(
      name: AppRoutes.homemenu,
      page: () =>MainMenuHome(onEventNav:(AppScreens? moveTo, [dynamic anydata]){}  ),
      binding: HomeMenuBinding(),
    ),
    GetPage(
      name: AppRoutes.navboard,
      page: () => NavigationDashBoard(),
      binding: NavBinding(),
    ),

  ];
}
