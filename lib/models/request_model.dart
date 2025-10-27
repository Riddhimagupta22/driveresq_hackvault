
import 'dart:convert';

class RequestModel {
  final String? id;
  final String? description;
  final String? vehicleInfo;
  final String? status;
  final Map<String, dynamic>? location; // latitude, longitude, landmark
  final String? phone;
  final List<String> images; // Supabase storage URLs

  RequestModel({
    this.id,
    this.description,
    this.vehicleInfo,
    this.status,
    this.location,
    this.phone,
    required this.images,
  });

  factory RequestModel.fromMap(Map<String, dynamic> map) {
    Map<String, dynamic>? parsedLocation;

    // ✅ Handle multiple possible location formats safely
    if (map['location'] != null) {
      if (map['location'] is String) {
        try {
          parsedLocation = Map<String, dynamic>.from(
            jsonDecode(map['location']),
          );
        } catch (e) {
          parsedLocation = {};
        }
      } else if (map['location'] is Map) {
        parsedLocation = Map<String, dynamic>.from(map['location']);
      }
    }

    return RequestModel(
      id: map['id']?.toString(),
      description: map['description'] ?? '',
      vehicleInfo: map['vehicle_info'] ?? '',
      status: map['status'] ?? '',
      location: parsedLocation ?? {},
      phone: map['phone'] ?? '',
      images: (map['images'] != null)
          ? List<String>.from(map['images'])
          : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'vehicle_info': vehicleInfo,
      'status': status,
      'location': location,
      'phone': phone,
      'images': images,
    };
  }
}
