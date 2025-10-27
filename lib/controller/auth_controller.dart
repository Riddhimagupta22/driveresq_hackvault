import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/supabse_client.dart';
import '../view/DriverDashboard/driver_home_page.dart';
import '../view/Mechanic/mechanic_home.dart';
import '../view/auth/driver/driver_login.dart';
import '../view/auth/mechanic/mechanic_login.dart';

class AuthController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  var userRole = ''.obs;
  var isLoading = false.obs;

  final SupabaseClient _client = SupabaseConfig.client;

  User? get currentUser => _client.auth.currentUser;

  final isPasswordHidden = true.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  Future<void> signUp(
    String email,
    String password,
    String name,
    String phone,
    String role,
  ) async {
    try {
      isLoading.value = true;

      final res = await _client.auth.signUp(
        email: email.trim(),
        password: password.trim(),
      );

      final user = res.user;
      if (user == null) throw Exception('Sign-up failed');

      await _client.from('users').insert({
        'auth_id': user.id,
        'name': name,
        'phone': phone,
        'role': role,
      });

      Get.snackbar('Success', 'Account created! Please log in.');

      if (role == 'driver') {
        Get.offAll(() => DriverLogin());
      } else {
        Get.offAll(() => MechanicLogin());
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;

      final res = await _client.auth.signInWithPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final authUser = res.user;
      if (authUser == null) throw Exception('Invalid login');

      final data = await _client
          .from('users')
          .select('role')
          .eq('auth_id', authUser.id)
          .maybeSingle();

      if (data == null) throw Exception('User record not found');
      userRole.value = data['role'] ?? '';

      if (userRole.value == 'driver') {
        Get.offAll(() => DriverHome());
      } else if (userRole.value == 'mechanic') {
        Get.offAll(() => MechanicHome());
      } else {
        throw Exception('Unknown user role');
      }
    } catch (e) {
      Get.snackbar(
        'Login Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await _client.auth.signOut();
      Get.offAllNamed('/role');
    } catch (e) {
      Get.snackbar('Error', 'Logout failed: $e');
    }
  }

  Future<void> checkUserSession() async {
    final currentUser = _client.auth.currentUser;
    if (currentUser != null) {
      final data = await _client
          .from('users')
          .select('role')
          .eq('auth_id', currentUser.id)
          .maybeSingle();

      if (data != null && data['role'] == 'driver') {
        Get.offAll(() => DriverHome());
      } else if (data != null && data['role'] == 'mechanic') {
        Get.offAll(() => MechanicHome());
      }
    } else {
      Get.offAllNamed('/role');
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
