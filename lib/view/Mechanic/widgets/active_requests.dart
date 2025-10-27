import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../request_detal.dart';

class ActiveRequestCard extends StatelessWidget {
  final Size size;
  const ActiveRequestCard({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      margin: const EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(size.width * 0.03),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              "Assest/image/936biS.jpg",
              height: size.height * 0.18,
              width: size.width,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Pending",
            style: TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.w600,
              fontSize: size.width * 0.035,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Kylie Evans",
            style: TextStyle(
              fontSize: size.width * 0.04,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            "Flat Tire - Toyota Corolla",
            style: TextStyle(fontSize: size.width * 0.035, color: Colors.grey),
          ),
          Text(
            "12 min ETA • 4.5 km away",
            style: TextStyle(fontSize: size.width * 0.034, color: Colors.red),
          ),
          const SizedBox(height: 10),

          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: () {
                Get.bottomSheet(
                  RequestDetailPage(),
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "View Details",
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}