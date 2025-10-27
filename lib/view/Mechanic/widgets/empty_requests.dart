
import 'package:flutter/material.dart';

class EmptyRequestCard extends StatelessWidget {
  const EmptyRequestCard({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(top: size.height * 0.01),
      padding: EdgeInsets.all(size.width * 0.05),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid, width: 1),
      ),
      child: Column(
        children: [
          Icon(Icons.work_off, size: size.width * 0.12, color: Colors.grey),
          SizedBox(height: size.height * 0.015),
          Text("No active jobs yet",
              style: TextStyle(
                  fontSize: size.width * 0.04, fontWeight: FontWeight.w600)),
          SizedBox(height: size.height * 0.01),
          Text("Stay online to receive new roadside\nassistance requests in your area.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: size.width * 0.035, color: Colors.grey)),
        ],
      ),
    );
  }
}
