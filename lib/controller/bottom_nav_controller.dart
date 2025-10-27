
import 'package:get/get.dart';




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
