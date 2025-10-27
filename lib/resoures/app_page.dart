import 'package:driveresq_hackvault/resoures/route_names.dart';
import 'package:get/get.dart';

import '../models/request_model.dart';
import '../view/DriverDashboard/driver_home_page.dart';
import '../view/DriverDashboard/new_request_page.dart';
import '../view/SplashScreen/splash_screen.dart';
import '../view/auth/driver/driver_login.dart';
import '../view/auth/driver/driver_signup.dart';
import '../view/auth/mechanic/mechanic_login.dart';
import '../view/auth/mechanic/mechanic_signup.dart';
import '../view/auth/select_role.dart';

class AppPages {
  static final routes = [
    // Splash Screen
    GetPage(name: RouteName.splashScreen, page: () => const SplashScreen()),

    // Role Selection
    GetPage(
      name: RouteName.selectRoleScreen,
      page: () => const RoleSelectionScreen(),
    ),

    // Driver Auth
    GetPage(name: RouteName.driverLogin, page: () => DriverLogin()),
    GetPage(name: RouteName.driverSignup, page: () => DriverSignUp()),

    // Driver Dashboard
    GetPage(name: RouteName.driverHome, page: () => DriverHome()),
    GetPage(name: RouteName.newRequest, page: () => const NewRequestScreen()),

    // Mechanic Auth
    GetPage(name: RouteName.mechanicLogin, page: () => MechanicLogin()),
    GetPage(name: RouteName.mechanicSignup, page: () => MechanicSignUp()),

    // Mechanic Dashboard
    GetPage(name: RouteName.mechanicHome, page: () => MechanicHome()),

    // Request Details
    GetPage(
      name: RouteName.requestDetail,
      page: () {
        final RequestModel req = Get.arguments as RequestModel;
        return RequestDetailPage(request: req);
      },
    ),
  ];
}
