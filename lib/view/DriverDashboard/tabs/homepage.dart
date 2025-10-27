
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../models/request_model.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final supabase = Supabase.instance.client;
  late final Stream<List<RequestModel>> _requestStream;

  @override
  void initState() {
    super.initState();

    // ✅ Create live stream from Supabase Realtime
    _requestStream = supabase
        .from('requests')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map((data) => data.map((e) => RequestModel.fromMap(e)).toList());
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF00695C);
    final Color secondaryTextColor = Colors.grey.shade600;

    return Column(
      children: [
        // ✅ Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.menu, color: secondaryTextColor),
                onPressed: () {},
              ),
              const Text(
                "DriveResQ",
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
              ),
              IconButton(
                icon: Icon(Icons.notifications_none, color: secondaryTextColor),
                onPressed: () {},
              ),
            ],
          ),
        ),

        // ✅ StreamBuilder with Supabase data
        Expanded(
          child: StreamBuilder<List<RequestModel>>(
            stream: _requestStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF00695C)));
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return _buildEmptyState(secondaryTextColor);
              }

              final pending = snapshot.data!
                  .where((r) => r.status == "pending")
                  .toList();

              if (pending.isEmpty) {
                return _buildEmptyState(secondaryTextColor);
              }

              final request = pending.first;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: _buildRequestCard(context, request, primaryColor),
              );
            },
          ),
        ),
      ],
    );
  }

  // ✅ Empty state
  Widget _buildEmptyState(Color secondaryTextColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.car_repair_rounded, size: 100, color: Colors.grey.shade300),
          const SizedBox(height: 24),
          const Text(
            "No active rescue requests yet",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            "When you need help, tap the '+' button\nto start a new request.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: secondaryTextColor),
          ),
        ],
      ),
    );
  }

  // ✅ Request card
  Widget _buildRequestCard(
      BuildContext context, RequestModel request, Color primaryColor) {
    final lat = request.location?['lat'] ?? 'Unknown';
    final lng = request.location?['lng'] ?? 'Unknown';
    final landmark = request.location?['landmark'] ?? '';
    Uint8List? imageBytes;

    final String? firstImage =
    request.images.isNotEmpty ? request.images.first : null;

    if (firstImage != null &&
        !firstImage.startsWith("http") &&
        firstImage.length > 100) {
      try {
        imageBytes = base64Decode(firstImage);
      } catch (e) {
        debugPrint("Image decode error: $e");
      }
    }

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "🆘 Active Rescue Request",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00695C),
              ),
            ),
            const SizedBox(height: 10),
            Text("📍 Location: $lat, $lng"),
            if (landmark.toString().isNotEmpty) Text("📌 Landmark: $landmark"),
            if (request.description?.isNotEmpty ?? false)
              Text("📝 Problem: ${request.description}"),
            if (request.vehicleInfo?.isNotEmpty ?? false)
              Text("🚗 Vehicle: ${request.vehicleInfo}"),
            if (request.phone?.isNotEmpty ?? false)
              Text("📞 Phone: ${request.phone}"),
            const SizedBox(height: 10),

            if (firstImage != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: imageBytes != null
                    ? Image.memory(
                  imageBytes,
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                )
                    : Image.network(
                  firstImage,
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const Text("⚠️ Invalid image data"),
                ),
              ),
            const SizedBox(height: 12),

            // ✅ Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () async {
                    await supabase
                        .from('requests')
                        .update({'status': 'completed'})
                        .eq('id', request.id!);
                    Get.snackbar("✅ Completed", "Request marked as completed");
                  },
                  icon:
                  const Icon(Icons.check_circle_outline, color: Colors.green),
                  label: const Text("Complete",
                      style: TextStyle(color: Colors.green)),
                ),
                TextButton.icon(
                  onPressed: () async {
                    await supabase.from('requests').delete().eq('id', request.id!);
                    Get.snackbar("🗑️ Deleted", "Request removed successfully");
                  },
                  icon: const Icon(Icons.delete_outline,
                      color: Colors.redAccent),
                  label: const Text("Delete",
                      style: TextStyle(color: Colors.redAccent)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
