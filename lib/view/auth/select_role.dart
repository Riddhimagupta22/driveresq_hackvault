import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'driver/driver_login.dart';
import 'driver/driver_signup.dart';
import 'mechanic/mechanic_login.dart';
import 'mechanic/mechanic_signup.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF00695C);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'DriveResQ',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Roadside help, on demand.',
                style: TextStyle(color: Colors.black54, fontSize: 16),
              ),
              const SizedBox(height: 50),

              // Driver Card
              _RoleCard(
                icon: Icons.directions_car,
                title: "I'm a Driver",
                subtitle: 'Get nearby mechanics & live help',
                color: primaryColor,
                onTap: () => _showAuthOptions(context, 'driver', primaryColor),
              ),
              const SizedBox(height: 24),

              // Mechanic Card
              _RoleCard(
                icon: Icons.build,
                title: "I'm a Mechanic",
                subtitle: 'Receive help requests in your area',
                color: primaryColor,
                onTap: () =>
                    _showAuthOptions(context, 'mechanic', primaryColor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAuthOptions(BuildContext context, String role, Color color) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Wrap(
          children: [
            Column(
              children: [
                Text(
                  'Welcome, ${role.capitalizeFirst}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

                // LOGIN BUTTON
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                    if (role == 'driver') {
                      Get.to(() => DriverLogin());
                    } else {
                      Get.to(() => MechanicLogin());
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: const Text(
                    'Log In',
                    style: TextStyle(color: Colors.white),
                  ),
                ),

                const SizedBox(height: 16),

                // REGISTER BUTTON
                OutlinedButton(
                  onPressed: () {
                    Get.back();
                    if (role == 'driver') {
                      Get.to(() => DriverSignUp());
                    } else {
                      Get.to(() => MechanicSignUp());
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: color),
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: Text(
                    'Register (New User)',
                    style: TextStyle(color: color),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(subtitle, style: const TextStyle(color: Colors.black54)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
