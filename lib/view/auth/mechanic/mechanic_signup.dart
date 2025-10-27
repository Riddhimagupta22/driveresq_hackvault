import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../controller/auth_controller.dart';
import 'mechanic_login.dart';

class MechanicSignUp extends StatelessWidget {
  MechanicSignUp({super.key});

  final authC = Get.put(AuthController());
  final _formKey = GlobalKey<FormState>();
  final Color primaryColor = const Color(0xFF00695C);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.08,
          vertical: height * 0.05,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 75),

            Text(
              "Join as a Mechanic",
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              "Create your account and start assisting drivers nearby",
              style: GoogleFonts.poppins(
                color: Colors.grey[700],
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // 🧾 Form Container
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // 🧍 Full Name
                    TextFormField(
                      controller: authC.nameController,
                      decoration: _inputDecoration(
                        label: 'Full Name',
                        icon: Icons.person_outline,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // 📞 Phone Number
                    TextFormField(
                      controller: authC.phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: _inputDecoration(
                        label: 'Phone Number',
                        icon: Icons.phone_outlined,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        if (value.length < 10) {
                          return 'Enter a valid phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // 📧 Email
                    TextFormField(
                      controller: authC.emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: _inputDecoration(
                        label: 'Email Address',
                        icon: Icons.email_outlined,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@')) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // 🔒 Password
                    Obx(
                          () => TextFormField(
                        controller: authC.passwordController,
                        obscureText: authC.isPasswordHidden.value,
                        decoration: _inputDecoration(
                          label: 'Password',
                          icon: Icons.lock_outline,
                          suffixIcon: IconButton(
                            icon: Icon(
                              authC.isPasswordHidden.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: () =>
                                authC.togglePasswordVisibility(),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 28),

                    // 🚀 Register Button
                    Obx(
                          () => authC.isLoading.value
                          ? const CircularProgressIndicator()
                          : SizedBox(
                        width: double.infinity,
                        height: height * 0.06,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              authC.signUp(
                                authC.emailController.text.trim(),
                                authC.passwordController.text.trim(),
                                authC.nameController.text.trim(),
                                authC.phoneController.text.trim(),
                                'mechanic',
                              );
                            }
                          },
                          child: Text(
                            'Register',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 🔁 Login Redirect
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account? ",
                  style: GoogleFonts.poppins(color: Colors.grey[700]),
                ),
                TextButton(
                  onPressed: () => Get.to(() => MechanicLogin()),
                  child: Text(
                    "Login",
                    style: GoogleFonts.poppins(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 🎨 Reusable Input Decoration
  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      prefixIcon: Icon(icon),
      suffixIcon: suffixIcon,
      labelText: label,
      labelStyle: GoogleFonts.poppins(),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF00695C), width: 1.8),
      ),
    );
  }
}