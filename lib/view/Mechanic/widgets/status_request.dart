
import 'package:flutter/material.dart';

class StatsCard extends StatelessWidget {
  const StatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    Widget statItem(String title, String value, IconData icon) {
      return Container(
        width: size.width * 0.27,
        padding: EdgeInsets.all(size.width * 0.03),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Icon(icon, size: size.width * 0.07, color: Colors.teal),
            SizedBox(height: size.height * 0.01),
            Text(value,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: size.width * 0.04)),
            Text(title,
                style: TextStyle(
                    fontSize: size.width * 0.033, color: Colors.grey)),
          ],
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        statItem("Today's Jobs", "5", Icons.work),
        statItem("Earnings", "₹3,500", Icons.currency_rupee),
        statItem("Rating", "4.8", Icons.star),
      ],
    );
  }
}
