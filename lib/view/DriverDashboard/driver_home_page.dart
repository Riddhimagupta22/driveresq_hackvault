import 'package:driveresq_hackvault/view/DriverDashboard/tabs/homepage.dart';
import 'package:driveresq_hackvault/view/DriverDashboard/tabs/profile_tab.dart';
import 'package:driveresq_hackvault/view/DriverDashboard/tabs/recharge_tab.dart';
import 'package:driveresq_hackvault/view/DriverDashboard/tabs/request_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/auth_controller.dart';
import '../../services/request_service.dart';
import 'new_request_page.dart';

class DriverHome extends StatelessWidget {
  DriverHome({super.key});

  // ✅ Replace placeholder tabs with your real screens
  final List<Widget> pages = [
    HomeTab(),
    RequestsTab(),
    RechargeTab(),
    ProfileTab(),
  ];

  final RequestService _requestService = RequestService();

  // 👇 simple reactive controller (no external file needed)
  final RxInt selectedPageIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    final AuthController authC = Get.find<AuthController>();

    return Obx(
      () => Scaffold(
        body: pages[selectedPageIndex.value],

        // --- FAB + Bottom Navigation ---
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () => Get.to(() => const NewRequestScreen()),
          backgroundColor: const Color(0xFF00695C),
          shape: const CircleBorder(),
          child: const Icon(Icons.add, color: Colors.white, size: 30),
        ),

        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 8.0,
          color: Colors.white,
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 6.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildBottomIcon(Icons.home, 0),
                _buildBottomIcon(Icons.list_alt, 1),
                const SizedBox(width: 40), // space for FAB
                _buildBottomIcon(Icons.account_balance_wallet, 2),
                _buildBottomIcon(Icons.person, 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- UI for Bottom Navigation Button ---
  Widget _buildBottomIcon(IconData icon, int index) {
    return Obx(() {
      final isSelected = selectedPageIndex.value == index;
      return IconButton(
        icon: Icon(
          icon,
          color: isSelected ? const Color(0xFF00695C) : Colors.grey,
          size: isSelected ? 28 : 25,
        ),
        onPressed: () => selectedPageIndex.value = index,
      );
    });
  }
}
