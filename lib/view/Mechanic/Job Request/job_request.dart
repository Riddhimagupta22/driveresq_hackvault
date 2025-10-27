import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class JobAcceptedScreen extends StatelessWidget {
  const JobAcceptedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.04,
                vertical: size.height * 0.015,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(Icons.arrow_back, size: size.width * 0.06),
                  ),
                  Column(
                    children: [
                      Text(
                        "Maria Rodriguez",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: size.width * 0.045,
                        ),
                      ),
                      Text(
                        "Job #88342",
                        style: GoogleFonts.poppins(
                          fontSize: size.width * 0.035,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.035,
                      vertical: size.height * 0.005,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.yellow[700],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "New",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: size.width * 0.03,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Body Content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Problem Details Card
                      Container(
                        width: size.width,
                        padding: EdgeInsets.all(size.width * 0.04),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Problem Details",
                              style: GoogleFonts.poppins(
                                fontSize: size.width * 0.045,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: size.height * 0.02),

                            detailTile(
                              size,
                              icon: Icons.directions_car,
                              text: "2021 Honda CR-V",
                            ),
                            detailTile(
                              size,
                              icon: Icons.report_problem_rounded,
                              text:
                              "Flat front-right tire. Spare is in the trunk.",
                            ),
                            detailTile(
                              size,
                              icon: Icons.location_on_outlined,
                              text:
                              "Parked on the northbound shoulder, 1/4 mile past exit 42.",
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),

                      // Map Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          "Assest/image/936biS.jpg",
                          height: size.height * 0.25,
                          width: size.width,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),

                      // Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          actionButton(size, Icons.call, "Call Driver"),
                          actionButton(size, Icons.message, "Message Driver"),
                        ],
                      ),
                      SizedBox(height: size.height * 0.12),
                    ],
                  ),
                ),
              ),
            ),

            Container(
              padding: EdgeInsets.all(size.width * 0.04),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
                ),
                child: Text(
                  "Start Journey",
                  style: GoogleFonts.poppins(
                    fontSize: size.width * 0.045,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget detailTile(Size size, {required IconData icon, required String text}) {
    return Padding(
      padding: EdgeInsets.only(bottom: size.height * 0.015),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: size.width * 0.06, color: Colors.teal),
          SizedBox(width: size.width * 0.03),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: size.width * 0.037,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget actionButton(Size size, IconData icon, String text) {
    return Container(
      width: size.width * 0.4,
      padding: EdgeInsets.symmetric(
        vertical: size.height * 0.015,
        horizontal: size.width * 0.04,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: size.width * 0.045, color: Colors.teal),
          SizedBox(width: size.width * 0.02),
          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: size.width * 0.031,
              fontWeight: FontWeight.w500,
              color: Colors.teal,
            ),
          ),
        ],
      ),
    );
  }
}