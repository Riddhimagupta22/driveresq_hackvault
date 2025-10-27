
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Controller/home_controller.dart';

class OnlineStatusCard extends StatelessWidget {
  final HomeController controller;
  const OnlineStatusCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      padding: EdgeInsets.all(size.width * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              "You are online\nYou're available for requests in a 5 km radius",
              style: TextStyle(fontSize: size.width * 0.035),
            ),
          ),
          Obx(() => Switch(
              value: controller.isOnline.value,
              activeColor: Colors.teal,
              onChanged: (val) => controller.isOnline.value = val)),
        ],
      ),
    );
  }
}
