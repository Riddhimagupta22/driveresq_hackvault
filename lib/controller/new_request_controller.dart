
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:permission_handler/permission_handler.dart' hide PermissionStatus;

class NewRequestController extends GetxController {
  final supabase = Supabase.instance.client;

  // Form controllers
  final landmarkController = TextEditingController();
  final problemController = TextEditingController();
  final phoneController = TextEditingController();

  // State variables
  final selectedImages = <File>[].obs;
  final latitude = 0.0.obs;
  final longitude = 0.0.obs;
  final isLoadingLocation = false.obs;
  final isSubmitting = false.obs;

  final picker = ImagePicker();

  /// 📍 Get current location
  Future<void> getCurrentLocation() async {
    try {
      isLoadingLocation.value = true;
      Location location = Location();

      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) return;
      }

      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) return;
      }

      final locData = await location.getLocation();
      latitude.value = locData.latitude ?? 0.0;
      longitude.value = locData.longitude ?? 0.0;
    } catch (e) {
      Get.snackbar('Error', 'Unable to fetch location: $e');
    } finally {
      isLoadingLocation.value = false;
    }
  }

  /// 📸 Pick image (max 3)
  Future<void> pickImage() async {
    if (selectedImages.length >= 3) {
      Get.snackbar('Limit Reached', 'You can upload up to 3 photos only.');
      return;
    }

    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) selectedImages.add(File(picked.path));
  }

  /// ☁️ Upload image to Supabase
  Future<String?> uploadImageToSupabase(File file) async {
    try {
      final fileName =
          'request_${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
      final filePath = 'requests/$fileName';

      await supabase.storage.from('requests').upload(filePath, file);
      return supabase.storage.from('requests').getPublicUrl(filePath);
    } catch (e) {
      print("Upload error: $e");
      return null;
    }
  }

  /// 🚗 Submit request
  Future<void> submitRequest(String driverId) async {
    try {
      Get.dialog(const Center(child: CircularProgressIndicator()),
          barrierDismissible: false);

      // Upload all selected images
      final imageUrls = <String>[];
      for (var img in selectedImages) {
        final url = await uploadImageToSupabase(img);
        if (url != null) imageUrls.add(url);
      }

      final requestData = {
        'driver_id': driverId,
        'description': problemController.text.trim(),
        'vehicle_info': landmarkController.text.isNotEmpty
            ? landmarkController.text
            : 'Unknown Vehicle',
        'status': 'pending',
        'phone': phoneController.text.trim(),
        'location': {
          'latitude': latitude.value,
          'longitude': longitude.value,
          'landmark': landmarkController.text,
        },
        'images': imageUrls,
        'created_at': DateTime.now().toIso8601String(),
      };

      await supabase.from('requests').insert(requestData);
      Get.back(); // close loader
      Get.snackbar('Success', 'Rescue request created successfully!');
      clearForm();
    } catch (e) {
      Get.back();
      Get.snackbar('Error', e.toString());
    }
  }

  void clearForm() {
    landmarkController.clear();
    problemController.clear();
    phoneController.clear();
    selectedImages.clear();
    latitude.value = 0.0;
    longitude.value = 0.0;
  }

  @override
  void onClose() {
    landmarkController.dispose();
    problemController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
