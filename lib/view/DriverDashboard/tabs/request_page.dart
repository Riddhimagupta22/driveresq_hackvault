
import 'package:flutter/material.dart';

class RequestsTab extends StatelessWidget {
  const RequestsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final Color secondaryTextColor = Colors.grey.shade600;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1.0,
        title: const Text(
          "My Requests",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.list_alt_rounded,
              size: 100,
              color: Colors.grey.shade200,
            ),
            const SizedBox(height: 24),
            const Text(
              "No Requests Found",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Your past and active requests will show up here.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: secondaryTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
