import 'package:get/get.dart';

import '../view/Mechanic/mechanic_tabs/HomeTab/home_tab.dart';
import '../view/Mechanic/mechanic_tabs/history_tab.dart';
import '../view/Mechanic/mechanic_tabs/profile_tab.dart';

class BottomNavController extends GetxController {
  var currentIndex = 0.obs;

  final pages = [Hometab(), Historytab(), Profiletab()];

  void changeTabIndex(int index) {
    currentIndex.value = index;
  }
}
