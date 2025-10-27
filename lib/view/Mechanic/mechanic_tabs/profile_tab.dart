import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/auth_controller.dart';


class Profiletab extends StatelessWidget {
  Profiletab({super.key});

  final authC = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.white,
        elevation: 1,
        automaticallyImplyLeading: false, // No back button
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[300],
              child: Icon(Icons.person, size: 60, color: Colors.grey[600]),
            ),
            SizedBox(height: 16),

            // User Name
            Text(
              'User Name', // Placeholder
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),

            // User Email
            Text(
              'user.email@example.com', // Placeholder
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 32),

            // Profile Options List
            ListTile(
              leading: Icon(
                Icons.account_balance_wallet_outlined,
                color: Colors.black,
              ),
              title: Text('My Wallet'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                // To Wallet Screen
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.settings_outlined, color: Colors.black),
              title: Text('Settings'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                // To Settings Screen
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.help_outline, color: Colors.black),
              title: Text('Help & Support'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                // To Help Screen
              },
            ),
            Divider(),

            SizedBox(height: 40),

            // Log Out Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                authC.logout(); // Call controller method
              },
              child: Text('Log Out', style: TextStyle(fontSize: 16)),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}