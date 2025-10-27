import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Controller/request_controller.dart';
import '../../models/request_model.dart';

class RequestDetailPage extends StatelessWidget {
  final RequestModel request;
  const RequestDetailPage({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final RequestController reqC = Get.find<RequestController>();

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      maxChildSize: 0.85,
      minChildSize: 0.3,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Title / Description
                Text(
                  request.description ?? "No description provided",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),

                // Vehicle Info (if available)
                if (request.vehicleInfo != null &&
                    request.vehicleInfo!.isNotEmpty)
                  Row(
                    children: [
                      const Icon(Icons.directions_car, color: Colors.blueGrey),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          request.vehicleInfo!,
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 10),

                // Location Info
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.redAccent),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Lat: ${request.location?['latitude']?.toStringAsFixed(5) ?? '-'}, "
                        "Lng: ${request.location?['longitude']?.toStringAsFixed(5) ?? '-'}",
                        style: GoogleFonts.poppins(fontSize: 13),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Status Chip
                Row(
                  children: [
                    Text(
                      "Status: ",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Chip(
                      label: Text(
                        request.status?.toUpperCase() ?? 'UNKNOWN',
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: _statusColor(request.status),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Attached Photos
                if (request.images != null && request.images!.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Attached Photos",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 90,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: request.images!.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 10),
                          itemBuilder: (context, index) {
                            final url = request.images![index];
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                url,
                                width: 90,
                                height: 90,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: Colors.grey[300],
                                  width: 90,
                                  height: 90,
                                  child: const Icon(Icons.image_not_supported),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),

                // Mechanic actions based on status
                if (request.status == 'pending')
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () async {
                          await reqC.acceptRequest(request.id!);
                          Get.back();
                          Get.snackbar(
                            "Accepted",
                            "Request accepted successfully",
                          );
                        },
                        icon: const Icon(Icons.check),
                        label: const Text("Accept"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () async {
                          await reqC.rejectRequest(request.id!);
                          Get.back();
                          Get.snackbar("Rejected", "Request rejected");
                        },
                        icon: const Icon(Icons.close),
                        label: const Text("Reject"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  )
                else if (request.status == 'accepted')
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await reqC.completeRequest(request.id!);
                        Get.back();
                        Get.snackbar("Completed", "Service marked as complete");
                      },
                      icon: const Icon(Icons.done),
                      label: const Text("Mark Completed"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  )
                else
                  Center(
                    child: Text(
                      "✅ ${request.status!.toUpperCase()}",
                      style: GoogleFonts.poppins(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _statusColor(String? status) {
    switch ((status ?? '').toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'accepted':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
