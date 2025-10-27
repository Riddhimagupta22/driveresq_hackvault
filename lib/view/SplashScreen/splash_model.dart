
import 'package:get/get.dart';

import '../../resoures/route_names.dart';

class SplashViewModel extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigateToNext();
  }

  void _navigateToNext() async {
    await Future.delayed(Duration(seconds: 4));
    Get.offNamed(RouteName.selectRoleScreen);
  }
}
