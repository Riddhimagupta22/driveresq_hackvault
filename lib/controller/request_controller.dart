import 'dart:io';
import 'package:get/get.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/request_model.dart';

class RequestController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;
  final RxList<RequestModel> requests = <RequestModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPendingRequests();
  }

  // ✅ Fetch all pending requests
  Future<void> fetchPendingRequests() async {
    try {
      isLoading.value = true;

      final response = await supabase
          .from('requests')
          .select()
          .order('created_at', ascending: false);

      final List data = response as List;
      requests.assignAll(data.map((r) => RequestModel.fromMap(r)).toList());
    } catch (e) {
      print('Error fetching requests: $e');
      Get.snackbar('Error', 'Unable to load requests.');
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ Upload images to Supabase Storage
  Future<List<String>> uploadImages(List<File> images) async {
    List<String> urls = [];

    for (final file in images) {
      final fileName =
          'request_${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
      try {
        // Upload file to "request-photos" bucket
        await supabase.storage.from('request-photos').upload(fileName, file);

        // Get public URL
        final publicUrl = supabase.storage
            .from('request-photos')
            .getPublicUrl(fileName);
        urls.add(publicUrl);
      } catch (e) {
        print('Image upload failed: $e');
        Get.snackbar('Error', 'Failed to upload image');
      }
    }
    return urls;
  }

  // ✅ Create a new request
  Future<void> createRequest({
    required String description,
    required String vehicleInfo,
    required Map<String, dynamic> location,
    required String driverId,
    required String phone,
    required List<File> images,
  }) async {
    try {
      final uploadedUrls = await uploadImages(images);

      await supabase.from('requests').insert({
        'driver_id': driverId,
        'description': description.trim(),
        'vehicle_info': vehicleInfo.trim(),
        'status': 'pending',
        'location': location,
        'phone': phone,
        'images': uploadedUrls,
        'created_at': DateTime.now().toIso8601String(),
      });

      Get.snackbar('✅ Success', 'Request created successfully!');
      await fetchPendingRequests();
    } catch (e) {
      print('Error creating request: $e');
      Get.snackbar('Error', e.toString());
    }
  }

  // ✅ Update status
  Future<void> _updateStatus(String id, String newStatus) async {
    try {
      await supabase
          .from('requests')
          .update({'status': newStatus})
          .eq('id', id);
      await fetchPendingRequests();
    } catch (e) {
      print("Error updating status: $e");
      Get.snackbar('Error', 'Could not update status.');
    }
  }

  Future<void> acceptRequest(String id) async => _updateStatus(id, 'accepted');
  Future<void> rejectRequest(String id) async => _updateStatus(id, 'rejected');
  Future<void> completeRequest(String id) async =>
      _updateStatus(id, 'completed');
}
