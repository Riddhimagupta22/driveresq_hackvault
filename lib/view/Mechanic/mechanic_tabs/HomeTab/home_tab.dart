import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Controller/home_controller.dart';
import '../../widgets/active_requests.dart';
import '../../widgets/empty_requests.dart';
import '../../widgets/online_status_card.dart';
import '../../widgets/status_request.dart';

class Hometab extends StatelessWidget {
  const Hometab({super.key});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final HomeController controller = Get.put(HomeController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.menu, color: Colors.black),
        title: const Text(
          "Mechanic Dashboard",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 20),
        ),
        actions: const [
          Icon(Icons.notifications_none, color: Colors.black),
          SizedBox(width: 12),
          Icon(Icons.person_outline, color: Colors.black),
          SizedBox(width: 12),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(size.width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OnlineStatusCard(controller: controller),

            SizedBox(height: size.height * 0.02),
            Text(
              "Active Request",
              style: TextStyle(
                fontSize: size.width * 0.045,
                fontWeight: FontWeight.w600,
              ),
            ),
            ActiveRequestCard(size: size),

            SizedBox(height: size.height * 0.02),
            Text(
              "Today's Stats",
              style: TextStyle(
                fontSize: size.width * 0.045,
                fontWeight: FontWeight.w600,
              ),
            ),
            const StatsCard(),

            SizedBox(height: size.height * 0.02),
            Text(
              "Active Request (Empty State)",
              style: TextStyle(
                fontSize: size.width * 0.045,
                fontWeight: FontWeight.w600,
              ),
            ),
            const EmptyRequestCard(),
          ],
        ),
      ),
    );
  }
}