import 'package:driveresq_hackvault/resoures/app_page.dart';
import 'package:driveresq_hackvault/resoures/route_names.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/auth_controller.dart';
import 'core/supabse_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.init(); // Initialize Supabase
  Get.put(AuthController()); // Initialize AuthController
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Mechanic Connect',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      initialRoute: RouteName.splashScreen,
      getPages: AppPages.routes,
    );
  }
}
