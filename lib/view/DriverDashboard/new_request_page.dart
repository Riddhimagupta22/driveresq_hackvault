import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../controller/new_request_controller.dart';
import '../../controller/request_controller.dart';

class NewRequestScreen extends GetView<NewRequestController> {
  const NewRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF00695C);
    final Color secondaryTextColor = Colors.grey.shade600;

    final requestController = Get.put(RequestController());
    Get.put(NewRequestController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "New Rescue Request",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLocationCard(primaryColor, secondaryTextColor),
            const SizedBox(height: 24),

            Text(
              "Location Details",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.landmarkController,
              decoration: _buildInputDecoration(
                "Nearby Landmark (Optional)",
                Icons.pin_drop_outlined,
                secondaryTextColor,
              ),
            ),
            const SizedBox(height: 24),

            Text(
              "Problem Details",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.problemController,
              maxLines: 4,
              decoration: _buildInputDecoration(
                "e.g., Engine won’t start, flat tyre...",
                Icons.report_problem_outlined,
                secondaryTextColor,
              ),
            ),
            const SizedBox(height: 24),

            Text(
              "Contact Information",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.phoneController,
              keyboardType: TextInputType.phone,
              decoration: _buildInputDecoration(
                "Phone Number",
                Icons.phone_outlined,
                secondaryTextColor,
              ),
            ),
            const SizedBox(height: 24),

            Text(
              "Add Photos (Max 3)",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            _buildPhotoUploaders(),
            const SizedBox(height: 40),
          ],
        ),
      ),

      // ✅ Submit button
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: Obx(() {
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: controller.isSubmitting.value
                  ? null
                  : () async {
                      controller.isSubmitting.value = true;

                      if (controller.problemController.text.isEmpty) {
                        Get.snackbar("Error", "Please describe your problem.");
                        controller.isSubmitting.value = false;
                        return;
                      }

                      final location = {
                        "lat": controller.latitude.value,
                        "lng": controller.longitude.value,
                        "landmark": controller.landmarkController.text,
                      };

                      // ✅ Get the logged-in Supabase user ID
                      final user = Supabase.instance.client.auth.currentUser;
                      if (user == null) {
                        Get.snackbar("Error", "Please log in first.");
                        controller.isSubmitting.value = false;
                        return;
                      }

                      // ✅ Create request in Supabase
                      await requestController.createRequest(
                        description: controller.problemController.text,
                        vehicleInfo: controller.landmarkController.text,
                        location: location,
                        driverId: user.id, // real UUID
                        phone: controller.phoneController.text,
                        images: controller.selectedImages,
                      );

                      // ✅ Refresh data after new request
                      await requestController.fetchPendingRequests();

                      // ✅ Success message + auto back
                      Get.snackbar(
                        "Success",
                        "Your rescue request has been created successfully!",
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.BOTTOM,
                      );

                      controller.isSubmitting.value = false;
                      Get.back(); // 👈 automatically go back
                    },
              child: controller.isSubmitting.value
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      "Create Request",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            );
          }),
        ),
      ),
    );
  }

  // 📍 Location card
  Widget _buildLocationCard(Color primaryColor, Color secondaryTextColor) {
    return Obx(() {
      if (controller.isLoadingLocation.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.location_on, color: primaryColor, size: 30),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                controller.latitude.value == 0.0
                    ? "No location detected"
                    : "Lat: ${controller.latitude.value.toStringAsFixed(5)}, Lng: ${controller.longitude.value.toStringAsFixed(5)}",
                style: const TextStyle(fontSize: 16),
              ),
            ),
            TextButton(
              onPressed: controller.getCurrentLocation,
              child: const Text("Refresh"),
            ),
          ],
        ),
      );
    });
  }

  // 📦 Input field decoration
  InputDecoration _buildInputDecoration(
    String label,
    IconData icon,
    Color hintColor,
  ) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: hintColor),
      prefixIcon: Icon(icon, color: hintColor),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  // 📸 Photo picker
  Widget _buildPhotoUploaders() {
    return Obx(() {
      return Row(
        children: [
          ...controller.selectedImages.map((file) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Stack(
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(file),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  Positioned(
                    top: 2,
                    right: 2,
                    child: GestureDetector(
                      onTap: () => controller.selectedImages.remove(file),
                      child: const CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.black54,
                        child: Icon(Icons.close, size: 14, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          if (controller.selectedImages.length < 3)
            GestureDetector(
              onTap: controller.pickImage,
              child: Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.camera_alt_outlined),
              ),
            ),
        ],
      );
    });
  }
}
