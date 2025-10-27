
import 'package:driveresq_app/Test/View/mech/mech_tab/profiletab.dart';
import 'package:get/get.dart';

import '../View/mech/mech_tab/histroytab.dart';
import '../View/mech/mech_tab/Home Tab/hometab.dart';


class BottomNavController extends GetxController {
  var currentIndex = 0.obs;

  final pages = [
    Hometab(),
    Historytab(),
    Profiletab(),
  ];

  void changeTabIndex(int index) {
    currentIndex.value = index;
  }
}
