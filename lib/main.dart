import 'package:ai_fitness_app/features/onboarding/views/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/bindings/app_bindings.dart';
import 'core/services/api/services/api_services.dart';
import 'core/util/app_navigation.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AppBindings.init();
  Get.put(ApiServices(baseUrl: 'https://skinseekapi.dsrt321.online'));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      navigatorKey: AppNavigation.navigatorKey,

      home: const OnboardingScreen(),
    );
  }
}




